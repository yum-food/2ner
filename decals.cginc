#ifndef __DECALS
#define __DECALS

#include "features.cginc"
#include "globals.cginc"
#include "math.cginc"

void applyDecals(in v2f i, inout float4 albedo, inout float3 normal_tangent, inout float metallic, inout float smoothness) {
#if defined(_DECAL0)
  float2x2 decal0_rot = float2x2(
    cos(_Decal0_Angle * TAU), -sin(_Decal0_Angle * TAU),
    sin(_Decal0_Angle * TAU), cos(_Decal0_Angle * TAU)
  );
  float2 decal0_uv = mul(decal0_rot, i.uv01.xy);
  decal0_uv = (decal0_uv * _Decal0_MainTex_ST.xy + _Decal0_MainTex_ST.zw) * _Decal0_Tiling_Mode;
  decal0_uv = (_Decal0_Tiling_Mode == DECAL_TILING_MODE_CLAMP ? saturate(decal0_uv) : decal0_uv);

  float4 decal0_albedo = _Decal0_MainTex.Sample(linear_repeat_s, decal0_uv) * _Decal0_Color;
  decal0_albedo.a *= _Decal0_Opacity;
  albedo = alphaBlend(albedo, decal0_albedo);

#if defined(_DECAL0_NORMAL)
  float3 decal0_normal = UnpackScaleNormal(
    _Decal0_Normal.Sample(linear_repeat_s, decal0_uv), _Decal0_Normal_Scale * _Decal0_Opacity);
  normal_tangent = blendNormalsHill12(normal_tangent, decal0_normal);
#endif
#if defined(_DECAL0_REFLECTIONS)
  float4 metallic_gloss = _Decal0_MetallicGlossMap.Sample(linear_repeat_s, decal0_uv);
  metallic = lerp(metallic, metallic_gloss.r * _Decal0_Metallic, decal0_albedo.a);
  smoothness = lerp(smoothness, metallic_gloss.a * _Decal0_Smoothness, decal0_albedo.a);
#endif
#endif
}

#endif  // __DECALS
