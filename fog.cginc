#ifndef __FOG_INC
#define __FOG_INC

#include "audiolink.cginc"
#include "cnlohr.cginc"
#include "interpolators.cginc"
#include "globals.cginc"
#include "LightVolumes.cginc"

#if defined(_RAYMARCHED_FOG)

struct FogParams {
    float3 color;
    float steps;
    float y_cutoff;
    texture2D dithering_noise;
    float4 dithering_noise_texelsize;
    texture3D density_noise;
    float4 density_noise_scale;
    float3 velocity;
    // Physical description of the medium (all in metres or unit-less)
    float mean_free_path;  //  ⟨s⟩  = 1 / σ_t
    float albedo;          //  ω   = σ_s / σ_t  (0 … 1)
    float g;               //  Henyey-Greenstein anisotropy (−1 … 1)
    float height_scale;    //  H   where ρ(y)=ρ₀·exp(−y/H)
    float height_offset;
    float turbulence;      //  Strength of noise modulation (0 … 1)
    float step_size;
    float step_growth;
#if defined(_RAYMARCHED_FOG_EMITTER_TEXTURE)
    texture2D emitter_texture;
    float4 emitter_texture_texelsize;
    float3 emitter_world_pos;
    float3 emitter_normal;
    float3 emitter_tangent;
    float3 emitter_normal_x_tangent;
    float2 emitter_scale;  // [tangent scale in meters, bitangent scale in meters]
    float2 emitter_scale_rcp;
#endif
};

#if defined(_RAYMARCHED_FOG_EMITTER_TEXTURE)
// Returns weighted color
float3 getEmitterData(FogParams p, float3 pp)
{
  // Using identity a_parallel_to_b = (dot(a, b) / dot(b, b)) * b
  //   float3 along_tangent = dot(p - em_loc, em_tangent) * em_tangent;
  //   float3 along_normal_x_tangent = dot(p - em_loc, em_normal_x_tangent) *
  //       em_normal_x_tangent;
  // Given that em_tangent and em_normal_x_tangent are normalized, and the fact
  // that we really want uvs, we can simplify this:
  float2 uv = float2(dot(pp - p.emitter_world_pos, p.emitter_normal_x_tangent), dot(pp - p.emitter_world_pos, p.emitter_tangent));
  uv *= p.emitter_scale_rcp;
  uv *= 0.5;
  uv += 0.5;

  bool in_range = uv.x < 1 && uv.y < 1 && uv.x > 0 && uv.y > 0;
  [branch]
  if (!in_range) {
    return p.color;
  }

  float4 c = p.emitter_texture.SampleLevel(linear_clamp_s, uv, 0);
  return lerp(p.color, c.rgb, c.a);
}
#endif

// ---------------------------------------------------------------------------
// Henyey–Greenstein phase function
static const float INV_FOUR_PI = 0.079577471545947667884f;  // 1/(4π)

inline float PhaseHG(float cosTheta, float g)
{
    float g2 = g * g;
    return INV_FOUR_PI * (1.0 - g2) / pow(1.0 + g2 - 2.0 * g * cosTheta, 1.5);
}

struct FogResult {
    float4 color;
    float depth;
};

FogResult raymarched_fog(v2f i, FogParams p)
{
  float3 ro = _WorldSpaceCameraPos;
  float3 rd = normalize(i.eyeVec.xyz);

  const float ro_epsilon = 1E-3;
  ro += rd * ro_epsilon;

  float4 clipPos = UnityObjectToClipPos(i.objPos);
  float2 screen_uv = ComputeScreenPos(clipPos) / clipPos.w;
  float zDepthFromMap = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screen_uv);

  float linearZ =
    GetLinearZFromZDepth_WorksWithMirrors(zDepthFromMap, screen_uv);

  // Get intersection with plane at elevation y.
  float plane_y = p.y_cutoff;
  float distance_to_y = 1E3;
  if (abs(rd.y) > 1E-6) {
    float t = (plane_y - ro.y) / rd.y;
    if (t > 0) {
      distance_to_y = min(t, 1E3);
    }
  }
  linearZ = min(linearZ, distance_to_y);
  linearZ -= ro_epsilon;

  float dither = p.dithering_noise.SampleLevel(point_repeat_s,
      screen_uv * _ScreenParams.xy * p.dithering_noise_texelsize.xy, 0).r;

  const float frame = ((float) AudioLinkData(ALPASS_GENERALVU + int2(1, 0)).x);
  dither = frac(dither + PHI * frame);

  // Exponential stepping parameters
  float step_size = p.step_size;
  float step_growth = p.step_growth;
  
  float3 pp = ro;
  float max_dist = linearZ;
  
  float T = 1;    // Transmittance
  float3 L = 0;   // Accumulated radiance
  float traveled = 0;
  
  [loop]
  for (uint ii = 0; ii < p.steps && traveled < max_dist; ++ii)
  {
    // Apply dithering to this step
    float cur_dither = frac(dither + (ii + 1) * PHI);
    float dithered_step = step_size * (cur_dither + 0.5);
    float remaining = max_dist - traveled;
    remaining = max(remaining, 0.1);
    dithered_step = min(dithered_step, remaining);

    // Advance position
    pp += dithered_step * rd;
    traveled += dithered_step;

    // --- Density ----------------------------------------------------------
    float3 noise_coord = (pp + _Time[0] * p.velocity) * p.density_noise_scale.xyz;
    float noise_sample = p.density_noise.SampleLevel(bilinear_repeat_s, noise_coord, 0).r;
    float noise_factor = lerp(1.0 - 0.5 * p.turbulence, 1.0 + 0.5 * p.turbulence, noise_sample);

    float height_factor = exp(-max(pp.y - p.height_offset, 0.0) / p.height_scale);

    float sigma_t = noise_factor * height_factor / max(p.mean_free_path, 1e-4);
    float sigma_s = sigma_t * p.albedo;

    // Analytic integration over the segment
    float exp_term = exp(-sigma_t * dithered_step);

    // If the segment is almost transparent, skip expensive work
    if (sigma_t < 1e-6)
    {
      T *= exp_term;
      continue;
    }

    // --- Incoming radiance ------------------------------------------------
    float3 L_in;
#if defined(_RAYMARCHED_FOG_EMITTER_TEXTURE)
    L_in = getEmitterData(p, pp);
#else
    // Indirect from SH / light volumes
    float3 l00, l01r, l01g, l01b;
    LightVolumeSH(pp, l00, l01r, l01g, l01b);
    float3 indirect = LightVolumeEvaluate(float3(0, 1, 0), l00, l01r, l01g, l01b);

    // Direct from the dominant realtime light
    float3 to_light = (_WorldSpaceLightPos0.w == 0.0) ? normalize(_WorldSpaceLightPos0.xyz)
                                                     : normalize(_WorldSpaceLightPos0.xyz - pp);
    float phase = PhaseHG(dot(to_light, -rd), p.g);
    float3 direct = _LightColor0.rgb * phase;

    L_in = (direct + indirect) * p.color;
#endif

    // --- Accumulate radiance ---------------------------------------------
    float scattering_integral = (sigma_s / sigma_t) * (1.0 - exp_term);
    L += T * scattering_integral * L_in;

    // Update transmittance
    T *= exp_term;

    // Early exit if virtually opaque
    if (T < 1e-3)
      break;
      
    // Grow step size exponentially
    step_size *= step_growth;
  }
  
  float4 color;
  color.rgb = L;
  color.a = 1 - T;  // Alpha for proper compositing

  FogResult r;
  r.color = color;
  //r.color.rgb = saturate(log(linearZ) / 5.0);
  //r.color.rgb = float3(screen_uv, 0);
  //r.color.a = d;
  r.depth = 0.0001;  // Very small depth value to render in front
  return r;
}

#endif  // _RAYMARCHED_FOG
#endif  // __FOG_INC
