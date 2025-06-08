#ifndef __FOG_INC
#define __FOG_INC

#include "audiolink.cginc"
#include "cnlohr.cginc"
#include "interpolators.cginc"
#include "globals.cginc"

#if defined(_RAYMARCHED_FOG)

struct FogParams {
    float3 color;
    float steps;
    float density;
    float y_cutoff;
    texture2D dithering_noise;
    float4 dithering_noise_texelsize;
    texture3D density_noise;
    float4 density_noise_scale;
    float3 velocity;
#if defined(_RAYMARCHED_FOG_DENSITY_EXPONENT)
    float density_exponent;
#endif
#if defined(_RAYMARCHED_FOG_HEIGHT_DENSITY)
    float height_density_start;
    float height_density_half_life;
#endif
#if defined(_CUSTOM30_FOG_HEIGHT_DENSITY_MINIMUM)
    float height_density_minimum;
#endif
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
  linearZ = min(linearZ, 1200);
  linearZ -= ro_epsilon;

  float dither = p.dithering_noise.SampleLevel(point_repeat_s,
      screen_uv * _ScreenParams.xy * p.dithering_noise_texelsize.xy, 0).r;

  const float frame = ((float) AudioLinkData(ALPASS_GENERALVU + int2(1, 0)).x);
  dither = frac(dither + PHI * frame);
  ro += rd * dither;
  linearZ -= dither;

  float step_size = linearZ / p.steps;
  float3 pp = ro;
  float4 color = 0;
  [loop]
  for (uint ii = 0; ii < p.steps; ++ii) {
    pp += step_size * rd;

    float3 noise_coord = (pp + _Time[0] * p.velocity) * p.density_noise_scale.xyz;

    float cur_d = p.density_noise.SampleLevel(bilinear_repeat_s,
        noise_coord, 0);

#if defined(_RAYMARCHED_FOG_DENSITY_EXPONENT)
    cur_d = pow(cur_d, p.density_exponent);
#endif

    cur_d *= p.density * step_size;

#if defined(_RAYMARCHED_FOG_HEIGHT_DENSITY)
    float height_clamped = max(pp.y - p.height_density_start, 0);
    // if half_life = 2 and start = 0, then
    //   y=2 -> density = 1/2
    //   y=4 -> density = 1/4
    //   y=6 -> density = 1/8
    // if half_life = 3 and start = 0, then
    //   y=3 -> density = 1/2
    //   y=6 -> density = 1/4
    //   y=9 -> density = 1/8
    float exponent = height_clamped / p.height_density_half_life;
    float factor = pow(2, -exponent);
#if defined(_CUSTOM30_FOG_HEIGHT_DENSITY_MINIMUM)
    factor = max(factor, p.height_density_minimum);
#endif
    cur_d *= factor;
#endif

    cur_d = saturate(cur_d);

#if defined(_RAYMARCHED_FOG_EMITTER_TEXTURE)
    float4 cur_c = float4(getEmitterData(p, pp) * cur_d, cur_d);
#else
    float4 cur_c = float4(p.color * cur_d, cur_d);
#endif
    color += (1.0f - color.a) * cur_c;
  }

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
