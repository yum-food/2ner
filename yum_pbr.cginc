#ifndef __YUM_PBR
#define __YUM_PBR

#include "features.cginc"
#include "filamented.cginc"
#include "globals.cginc"
#include "texture_utils.cginc"

struct YumPbr {
  float4 albedo;
  float3 normal;
  float smoothness;
  float roughness;
  float roughness_perceptual;
  float metallic;
  float ao;
};

YumPbr GetYumPbr(v2f i) {
  YumPbr result;

#if defined(OUTLINE_PASS)
  result.albedo = _Outline_Color;
  result.albedo.a *= tex2D(_MainTex,
      UV_SCOFF(i, _MainTex_ST, /*which_channel=*/0)).a;
#else
  result.albedo = tex2D(_MainTex,
      UV_SCOFF(i, _MainTex_ST, /*which_channel=*/0)) * _Color;
#endif

  float3 normal_raw = UnpackScaleNormal(
      tex2D(_BumpMap, UV_SCOFF(i, _BumpMap_ST, /*which_channel=*/0)),
      _BumpScale);
  float3x3 tangentToWorld = float3x3(i.tangent, i.binormal, i.normal);
  result.normal = normalize(mul(normal_raw, tangentToWorld));

  result.smoothness = _Smoothness;
  result.roughness_perceptual =
    normalFiltering(1.0 - result.smoothness, result.normal);
  result.roughness = result.roughness_perceptual * result.roughness_perceptual;

  result.metallic = _Metallic;

#if defined(_AMBIENT_OCCLUSION)
  result.ao = lerp(1, tex2D(_OcclusionMap, i.uv01), _OcclusionStrength);
#else
  result.ao = 1;
#endif

  return result;
}

#endif

