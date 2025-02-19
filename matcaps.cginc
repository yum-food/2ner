#ifndef __MATCAPS_INC
#define __MATCAPS_INC

#include "features.cginc"
#include "globals.cginc"
#include "interpolators.cginc"
#include "yum_pbr.cginc"

#if defined(_MATCAP0) || defined(_RIM_LIGHTING0)
float2 getMatcapUV(v2f i, inout YumPbr pbr) {
  const float3 cam_normal = normalize(mul(UNITY_MATRIX_V, float4(pbr.normal, 0)));
  const float3 cam_view_dir = normalize(mul(UNITY_MATRIX_V, float4(-i.eyeVec.xyz, 0)));
  const float3 cam_refl = -reflect(cam_view_dir, cam_normal);
  float m = 2.0 * sqrt(
      cam_refl.x * cam_refl.x +
      cam_refl.y * cam_refl.y +
      (cam_refl.z + 1) * (cam_refl.z + 1));
  return cam_refl.xy / m + 0.5;
}

void applyMatcap(inout YumPbr pbr, float3 sample, uint mode, float mask)
{
  [forcecase]
  switch(mode) {
    case MATCAP_MODE_REPLACE:
      pbr.albedo.rgb = lerp(pbr.albedo.rgb, sample, mask);
      break;
    case MATCAP_MODE_ADD:
      pbr.albedo.rgb += lerp(0, sample, mask);
      break;
    case MATCAP_MODE_MULTIPLY:
      pbr.albedo.rgb *= lerp(1, sample, mask);
      break;
    case MATCAP_MODE_SUBTRACT:
      pbr.albedo.rgb -= lerp(0, sample, mask);
      break;
    case MATCAP_MODE_ADD_PRODUCT:
      pbr.albedo.rgb += lerp(0, sample * pbr.albedo.rgb, mask);
      break;
    default:
      break;
  }
}
#endif

void applyMatcapsAndRimLighting(v2f i, inout YumPbr pbr) {
#if defined(_MATCAP0) || defined(_RIM_LIGHTING0) || defined(_RIM_LIGHTING1)
  float2 muv = getMatcapUV(i, pbr);
#endif
#if defined(_MATCAP0)
  float3 m0 = _Matcap0.Sample(linear_repeat_s, muv);
  m0 = lerp(m0, 1 - m0, _Matcap0_Invert);
  m0 *= _Matcap0_Strength;
#if defined(_MATCAP0_MASK)
  float m0_mask = _Matcap0_Mask.Sample(linear_repeat_s, i.uv01.xy);
#else
  float m0_mask = 1;
#endif
  applyMatcap(pbr, m0, _Matcap0_Mode, m0_mask);
#endif
#if defined(_RIM_LIGHTING0) || defined(_RIM_LIGHTING1)
  float rl_radius = length(muv - 0.5);
#endif
#if defined(_RIM_LIGHTING0)
  float rl0_dist = exp2(-_Rim_Lighting0_Power * abs(rl_radius - _Rim_Lighting0_Center));
  float3 rl0 = _Rim_Lighting0_Color * _Rim_Lighting0_Brightness * rl0_dist;
#if defined(_RIM_LIGHTING0_MASK)
  float rl0_mask = _Rim_Lighting0_Mask.Sample(linear_repeat_s, i.uv01.xy);
#else
  float rl0_mask = 1;
#endif
  applyMatcap(pbr, rl0, _Rim_Lighting0_Mode, rl0_mask);
#endif
#if defined(_RIM_LIGHTING1)
  float rl1_dist = exp2(-_Rim_Lighting1_Power * abs(rl_radius - _Rim_Lighting1_Center));
  float3 rl1 = _Rim_Lighting1_Color * _Rim_Lighting1_Brightness * rl1_dist;
#if defined(_RIM_LIGHTING1_MASK)
  float rl1_mask = _Rim_Lighting1_Mask.Sample(linear_repeat_s, i.uv01.xy);
#else
  float rl1_mask = 1;
#endif
  applyMatcap(pbr, rl1, _Rim_Lighting1_Mode, rl1_mask);
#endif
}

#endif

