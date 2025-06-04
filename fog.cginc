#ifndef __FOG_INC
#define __FOG_INC

#include "cnlohr.cginc"
#include "interpolators.cginc"
#include "globals.cginc"

#if defined(_RAYMARCHED_FOG)

struct FogParams {
    float steps;
    float density;
    float y_cutoff;
    texture2D dithering_noise;
    texture3D density_noise;
    float4 density_noise_scale;
};

struct FogResult {
    float4 color;
    float depth;
};

FogResult raymarched_fog(v2f i, FogParams p)
{
  float3 ro = _WorldSpaceCameraPos;
  float3 rd = normalize(i.eyeVec.xyz);

  ro += rd * 1E-3;

  float2 screen_uv = (i.pos.xy + 0.5) / _ScreenParams.xy;
  float zDepthFromMap = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screen_uv);
  float linearZ =
    GetLinearZFromZDepth_WorksWithMirrors(zDepthFromMap, screen_uv);
  linearZ = min(1E3, linearZ);

  // Get intersection with plane at elevation y.
  float plane_y = -10;
  float distance_to_y = 1E3;
  if (abs(rd.y) > 1E-6) {
    float t = (plane_y - ro.y) / rd.y;
    if (t > 0) {
      distance_to_y = min(t, 1E3);
    }
  }
  linearZ = min(linearZ, distance_to_y);

  float step_size = linearZ / p.steps;
  float3 pp = ro;
  float d = 0;
  for (uint ii = 0; ii < p.steps; ++ii) {
    pp += step_size * rd;
    float cur_d = p.density_noise.SampleLevel(linear_repeat_s,
        pp * p.density_noise_scale.xyz, 0);
    cur_d *= p.density * step_size;

    d = d + (1 - d) * cur_d;
  }

  FogResult r;
  r.color.rgb = 1;
  r.color.rgb = saturate(log(linearZ) / 5.0);
  //r.color.a = saturate(d);
  r.color.a = 1;
  r.depth = 0.0001;  // Very small depth value to render in front
  return r;
}

#endif  // _RAYMARCHED_FOG
#endif  // __FOG_INC
