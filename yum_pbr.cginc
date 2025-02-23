#ifndef __YUM_PBR
#define __YUM_PBR

#include "features.cginc"
#include "filamented.cginc"
#include "globals.cginc"
#include "texture_utils.cginc"

struct YumPbr {
  float4 albedo;
  float3 normal;
#if defined(_EMISSION)
  float3 emission;
#endif
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

#if defined(_ALPHA_MULTIPLIER)
  result.albedo.a = saturate(result.albedo.a * _Alpha_Multiplier);
#endif

  float3 normal_raw = UnpackScaleNormal(
      tex2D(_BumpMap, UV_SCOFF(i, _BumpMap_ST, /*which_channel=*/0)),
      _BumpScale);
  float3x3 tangentToWorld = float3x3(i.tangent, i.binormal, i.normal);
  result.normal = normalize(mul(normal_raw, tangentToWorld));

#if defined(_EMISSION)
  result.emission = tex2D(_EmissionMap, UV_SCOFF(i, _EmissionMap_ST, /*which_channel=*/0)) * _EmissionColor;
#endif

#if defined(_METALLICS)
  float4 metallic_gloss = tex2D(_MetallicGlossMap, UV_SCOFF(i, _MetallicGlossMap_ST, /*which_channel=*/0));
  float metallic = metallic_gloss.r * _Metallic;
  float smoothness = metallic_gloss.a * _Smoothness;

  result.smoothness = smoothness;
  result.roughness_perceptual =
    normalFiltering(1.0 - result.smoothness, result.normal);
  result.roughness = result.roughness_perceptual * result.roughness_perceptual;
  result.metallic = metallic;
#else
  result.smoothness = 0.2;
  result.roughness_perceptual =
    normalFiltering(1.0 - result.smoothness, result.normal);
  result.roughness = result.roughness_perceptual * result.roughness_perceptual;
  result.metallic = 0;
#endif

#if defined(_AMBIENT_OCCLUSION)
  result.ao = lerp(1, tex2D(_OcclusionMap, i.uv01), _OcclusionStrength);
#else
  result.ao = 1;
#endif

  return result;
}

#endif

