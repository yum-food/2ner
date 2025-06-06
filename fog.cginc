#ifndef __FOG_INC
#define __FOG_INC

#include "audiolink.cginc"
#include "cnlohr.cginc"
#include "interpolators.cginc"
#include "globals.cginc"

#if defined(_RAYMARCHED_FOG)

struct FogParams {
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
};

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

  // TODO maybe we can accelerate this?
  float perspective_divide = 1.0f / i.pos.w;
  float perspective_factor = length(i.eyeVec.xyz * perspective_divide);

  const float2 screen_uv = (i.pos.xy + 0.5) / _ScreenParams.xy;
  float zDepthFromMap = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screen_uv);

  float linearZ =
    GetLinearZFromZDepth_WorksWithMirrors(zDepthFromMap, screen_uv);
  linearZ = min(1E3, linearZ);

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
  ro += rd * dither;
  linearZ -= dither;

  float step_size = linearZ / p.steps;
  float3 pp = ro;
  float d = 0;
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
    cur_d *= factor;
#endif

    cur_d = saturate(cur_d);
    d = d + (1 - d) * cur_d;
  }

  FogResult r;
  r.color.rgb = _Raymarched_Fog_Color;
  //r.color.rgb = saturate(log(linearZ) / 5.0);
  //r.color.rgb = float3(screen_uv, 0);
  r.color.a = d;
  r.depth = 0.0001;  // Very small depth value to render in front
  return r;
}

#endif  // _RAYMARCHED_FOG
#endif  // __FOG_INC
