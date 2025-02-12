#ifndef __YUM_PBR
#define __YUM_PBR

#include "filamented.cginc"
#include "globals.cginc"

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

  result.albedo = tex2D(_MainTex, i.uv) * _Color;

  float3 normal_raw = UnpackScaleNormal(tex2D(_BumpMap, i.uv), _BumpScale);
  float3x3 tangentToWorld = float3x3(i.tangent, i.bitangent, i.normal);
  result.normal = normalize(mul(normal_raw, tangentToWorld));

  result.smoothness = _Smoothness;
  result.roughness_perceptual =
    normalFiltering(1.0 - result.smoothness, result.normal);
  result.roughness = result.roughness_perceptual * result.roughness_perceptual;

  result.metallic = _Metallic;

  result.ao = lerp(1, tex2D(_OcclusionMap, i.uv), _OcclusionStrength);

  return result;
}

#endif

