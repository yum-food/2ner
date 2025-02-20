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

float getAngleAttenuation(float2 muv, float2 target_vector, float power) {
  muv = muv * 2 - 1;
  float NoL = dot(muv, target_vector);
  NoL =  halfLambertianNoL(NoL);
  return pow(NoL, power);
}

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
#if defined(_RIM_LIGHTING0_ANGLE_LIMIT)
  rl0_dist *= getAngleAttenuation(muv, _Rim_Lighting0_Angle_Limit_Target_Vector,
      _Rim_Lighting0_Angle_Limit_Power);
#endif
#if defined(_RIM_LIGHTING0_QUANTIZATION)
  rl0_dist = floor(rl0_dist * _Rim_Lighting0_Quantization_Steps) / _Rim_Lighting0_Quantization_Steps;
#endif
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
#if defined(_RIM_LIGHTING1_ANGLE_LIMIT)
  rl1_dist *= getAngleAttenuation(muv, _Rim_Lighting1_Angle_Limit_Target_Vector,
      _Rim_Lighting1_Angle_Limit_Power);
#endif
#if defined(_RIM_LIGHTING1_QUANTIZATION)
  rl1_dist = floor(rl1_dist * _Rim_Lighting1_Quantization_Steps) / _Rim_Lighting1_Quantization_Steps;
#endif
  float3 rl1 = _Rim_Lighting1_Color * _Rim_Lighting1_Brightness * rl1_dist;
#if defined(_RIM_LIGHTING1_MASK)
  float rl1_mask = _Rim_Lighting1_Mask.Sample(linear_repeat_s, i.uv01.xy);
#else
  float rl1_mask = 1;
#endif
  applyMatcap(pbr, rl1, _Rim_Lighting1_Mode, rl1_mask);
#endif

#if defined(_RIM_LIGHTING2)
  float rl2_dist = exp2(-_Rim_Lighting2_Power * abs(rl_radius - _Rim_Lighting2_Center));
#if defined(_RIM_LIGHTING2_ANGLE_LIMIT)
  rl2_dist *= getAngleAttenuation(muv, _Rim_Lighting2_Angle_Limit_Target_Vector,
      _Rim_Lighting2_Angle_Limit_Power);
#endif
#if defined(_RIM_LIGHTING2_QUANTIZATION)
  rl2_dist = floor(rl2_dist * _Rim_Lighting2_Quantization_Steps) / _Rim_Lighting2_Quantization_Steps;
#endif
  float3 rl2 = _Rim_Lighting2_Color * _Rim_Lighting2_Brightness * rl2_dist;
#if defined(_RIM_LIGHTING2_MASK)
  float rl2_mask = _Rim_Lighting2_Mask.Sample(linear_repeat_s, i.uv01.xy);
#else
  float rl2_mask = 1;
#endif
  applyMatcap(pbr, rl2, _Rim_Lighting2_Mode, rl2_mask);
#endif

#if defined(_RIM_LIGHTING3)
  float rl3_dist = exp2(-_Rim_Lighting3_Power * abs(rl_radius - _Rim_Lighting3_Center));
#if defined(_RIM_LIGHTING3_ANGLE_LIMIT)
  rl3_dist *= getAngleAttenuation(muv, _Rim_Lighting3_Angle_Limit_Target_Vector,
      _Rim_Lighting3_Angle_Limit_Power);
#endif
#if defined(_RIM_LIGHTING3_QUANTIZATION)
  rl3_dist = floor(rl3_dist * _Rim_Lighting3_Quantization_Steps) / _Rim_Lighting3_Quantization_Steps;
#endif
  float3 rl3 = _Rim_Lighting3_Color * _Rim_Lighting3_Brightness * rl3_dist;
#if defined(_RIM_LIGHTING3_MASK)
  float rl3_mask = _Rim_Lighting3_Mask.Sample(linear_repeat_s, i.uv01.xy);
#else
  float rl3_mask = 1;
#endif
  applyMatcap(pbr, rl3, _Rim_Lighting3_Mode, rl3_mask);
#endif
}

#endif

