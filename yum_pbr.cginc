#ifndef __YUM_PBR
#define __YUM_PBR

#include "cnlohr.cginc"
#include "data.cginc"
#include "decals.cginc"
#include "features.cginc"
#include "filamented.cginc"
#include "glitter.cginc"
#include "globals.cginc"
#include "math.cginc"
#include "oklab.cginc"
#include "texture_utils.cginc"

void propagateRoughness(in float smoothness, out float roughness_perceptual, out float roughness) {
  roughness_perceptual = normalFiltering(1.0 - smoothness, float3(0, 0, 1));
  roughness = roughness_perceptual * roughness_perceptual;
}

// Shitty hacky filtering, not in any way robust or mathematically sound.
void filterGradient(v2f i, inout float2 g)
{
  float3 normal = normalize(float3(-g.x, 1.0f, -g.y));
  float dn = length(fwidth(normal));
  g *= saturate(0.05 / dn);
}

#if defined(_GRADIENT_NORMALS)
void applyGradientNormals(v2f i, inout YumPbr pbr) {
  float2 uv = i.uv01.xy;

  // Math lifted from "Ocean waves simulation with Fast Fourier transform" by
  // Jump Trajectory.
  float2 gradient = 0;

#if defined(_GRADIENT_NORMALS_0_VERTICAL)
  float2 g0_uv = uv * _Gradient_Normals_0_Vertical_ST.xy;
  float2 g0_dfy = _Gradient_Normals_0_Vertical.SampleLevel(bilinear_repeat_s, g0_uv, 0).rg;
  float2 g0 = g0_dfy;
#if defined(_GRADIENT_NORMALS_0_HORIZONTAL)
  float2 g0_dfxz = _Gradient_Normals_0_Horizontal.SampleLevel(bilinear_repeat_s, g0_uv, 0).rg;
  g0 = float2(
      g0_dfy[0] / (1 + g0_dfxz[0]),
      g0_dfy[1] / (1 + g0_dfxz[1])
      );
  filterGradient(i, g0);
#endif  // _GRADIENT_NORMALS_0_HORIZONTAL
  gradient += g0;
#endif  // _GRADIENT_NORMALS_0_VERTICAL

#if defined(_GRADIENT_NORMALS_1_VERTICAL)
  float2 g1_uv = uv * _Gradient_Normals_1_Vertical_ST.xy;
  float2 g1_dfy = _Gradient_Normals_1_Vertical.SampleLevel(bilinear_repeat_s, g1_uv, 0).rg;
  float2 g1 = g1_dfy;
#if defined(_GRADIENT_NORMALS_1_HORIZONTAL)
  float2 g1_dfxz = _Gradient_Normals_1_Horizontal.SampleLevel(bilinear_repeat_s, g1_uv, 0).rg;
  g1 = float2(
      g1_dfy[0] / (1 + g1_dfxz[0]),
      g1_dfy[1] / (1 + g1_dfxz[1])
      );
  filterGradient(i, g1);
#endif  // _GRADIENT_NORMALS_1_HORIZONTAL
  gradient += g1;
#endif  // _GRADIENT_NORMALS_1_VERTICAL

#if defined(_GRADIENT_NORMALS_2_VERTICAL)
  float2 g2_uv = uv * _Gradient_Normals_2_Vertical_ST.xy;
  float2 g2_dfy = _Gradient_Normals_2_Vertical.SampleLevel(bilinear_repeat_s, g2_uv, 0).rg;
  float2 g2 = g2_dfy;
#if defined(_GRADIENT_NORMALS_2_HORIZONTAL)
  float2 g2_dfxz = _Gradient_Normals_2_Horizontal.SampleLevel(bilinear_repeat_s, g2_uv, 0).rg;
  g2 = float2(
      g2_dfy[0] / (1 + g2_dfxz[0]),
      g2_dfy[1] / (1 + g2_dfxz[1])
      );
#endif  // _GRADIENT_NORMALS_2_HORIZONTAL
  gradient += g2;
#endif  // _GRADIENT_NORMALS_2_VERTICAL

#if defined(_GRADIENT_NORMALS_3_VERTICAL)
  float2 g3_uv = uv * _Gradient_Normals_3_Vertical_ST.xy;
  float2 g3_dfy = _Gradient_Normals_3_Vertical.SampleLevel(bilinear_repeat_s, g3_uv, 0).rg;
  float2 g3 = g3_dfy;
#if defined(_GRADIENT_NORMALS_3_HORIZONTAL)
  float2 g3_dfxz = _Gradient_Normals_3_Horizontal.SampleLevel(bilinear_repeat_s, g3_uv, 0).rg;
  g3 = float2(
      g3_dfy[0] / (1 + g3_dfxz[0]),
      g3_dfy[1] / (1 + g3_dfxz[1])
      );
  filterGradient(i, g2);
#endif  // _GRADIENT_NORMALS_3_HORIZONTAL

  gradient += g3;
#endif  // _GRADIENT_NORMALS_3_VERTICAL

  float3 gradient_normal = normalize(float3(-gradient.x, 1.0f, -gradient.y));

  pbr.normal = gradient_normal;
}
#endif

#if defined(_SEA_FOAM)
void applySeaFoam(v2f i, inout YumPbr pbr) {
  float2 uv = i.uv01.xy;

  float4 slope = 0;

  #if defined(_SEA_FOAM_0)
    slope += _Sea_Foam_0_Slope.SampleLevel(bilinear_repeat_s, uv * _Sea_Foam_0_Slope_ST.xy, 0);
  #endif
  #if defined(_SEA_FOAM_1)
    slope += _Sea_Foam_1_Slope.SampleLevel(bilinear_repeat_s, uv * _Sea_Foam_1_Slope_ST.xy, 0);
  #endif
  #if defined(_SEA_FOAM_2)
    slope += _Sea_Foam_2_Slope.SampleLevel(bilinear_repeat_s, uv * _Sea_Foam_2_Slope_ST.xy, 0);
  #endif
  #if defined(_SEA_FOAM_3)
    slope += _Sea_Foam_3_Slope.SampleLevel(bilinear_repeat_s, uv * _Sea_Foam_3_Slope_ST.xy, 0);
  #endif

  float dfx_dx = slope[0];
  float dfy_dy = slope[1];
  float dfx_dy = slope[3];

  float Jxx = 1 + dfx_dx * _Sea_Foam_Lambda;
  float Jyy = 1 + dfy_dy * _Sea_Foam_Lambda;
  float Jxy = dfx_dy * _Sea_Foam_Lambda;

  float det = Jxx * Jyy - Jxy * Jxy;
  float foam_contribution = det;
  foam_contribution += _Sea_Foam_Bias;
  foam_contribution = saturate(foam_contribution);

  pbr.albedo.rgb = lerp(pbr.albedo.rgb, _Sea_Foam_Color.rgb, foam_contribution * _Sea_Foam_Color.a);
  pbr.smoothness = lerp(pbr.smoothness, 1.0f - _Sea_Foam_Roughness, foam_contribution);
  propagateRoughness(pbr.smoothness, pbr.roughness_perceptual, pbr.roughness);
}
#endif

YumPbr GetYumPbr(v2f i, float3x3 tangentToWorld) {
  YumPbr result = (YumPbr)0;

  float2 raw_uv = i.uv01.xy;
#if defined(_UV_DOMAIN_WARPING)
  {
    float2 warped_uv = raw_uv;
    float amplitude = _UV_Domain_Warping_Spatial_Strength;
    float frequency = _UV_Domain_Warping_Spatial_Scale;

    float2 speed_direction = _UV_Domain_Warping_Spatial_Direction;
    float2 time_offset = speed_direction * _Time.y * _UV_Domain_Warping_Spatial_Speed;

    const float lacunarity = 2.0;
    const float persistence = 0.5;

    [loop]
    for (uint ii = 0; ii < _UV_Domain_Warping_Spatial_Octaves; ii++) {
      float2 noise_uv = warped_uv * frequency + time_offset;
      float2 offset_sample = _UV_Domain_Warping_Noise.SampleLevel(trilinear_repeat_s, noise_uv, 0).rg;
      offset_sample = (offset_sample * 2.0 - 1.0);
      warped_uv += offset_sample * amplitude;
      frequency *= lacunarity;
      amplitude *= persistence;
    }
    i.uv01.xy = warped_uv;
  }
#endif

#if defined(OUTLINE_PASS)
  result.albedo = _Outline_Color;
  result.albedo.a *= tex2D(_MainTex,
      UV_SCOFF(i, _MainTex_ST, /*which_channel=*/0)).a;
#else
  result.albedo = tex2D(_MainTex,
      UV_SCOFF(i, _MainTex_ST, /*which_channel=*/0)) * _Color;
#endif

#if defined(_3D_SDF)
  {
    float2 sdf_uv_raw = get_uv_by_channel(i, _3D_SDF_UV_Channel);
    float3 sdf_uv = float3(sdf_uv_raw, _3D_SDF_Z + _Time.y * _3D_SDF_Z_Speed);
    sdf_uv.xy = saturate((sdf_uv.xy - (_3D_SDF_ST.zw + 0.5)) * _3D_SDF_ST.xy + (_3D_SDF_ST.zw + 0.5));
    float sdf_value = _3D_SDF_Texture.SampleLevel(trilinear_repeat_s, sdf_uv, 0).r;
    float eps = 1E-4;
    float4 is_lit = sdf_value < _3D_SDF_Thresholds && sdf_uv.x > eps && sdf_uv.x < 1 - eps && sdf_uv.y > eps && sdf_uv.y < 1 - eps;
    float4 skin_albedo = result.albedo;
    result.albedo.rgb = lerp(result.albedo.rgb, lerp(skin_albedo.rgb, _3D_SDF_Color_3.rgb, _3D_SDF_Color_3.a), is_lit.w);
    result.albedo.rgb = lerp(result.albedo.rgb, lerp(skin_albedo.rgb, _3D_SDF_Color_2.rgb, _3D_SDF_Color_2.a), is_lit.z);
    result.albedo.rgb = lerp(result.albedo.rgb, lerp(skin_albedo.rgb, _3D_SDF_Color_1.rgb, _3D_SDF_Color_1.a), is_lit.y);
    result.albedo.rgb = lerp(result.albedo.rgb, lerp(skin_albedo.rgb, _3D_SDF_Color_0.rgb, _3D_SDF_Color_0.a), is_lit.x);
  }
#endif

  float3 normal_tangent = UnpackScaleNormal(
      tex2D(_BumpMap, UV_SCOFF_IMPL(raw_uv, _BumpMap_ST)), _BumpScale);

#if defined(_DETAIL_MAPS)
  float detail_mask = _DetailMask.SampleLevel(point_repeat_s, i.uv01.xy, 0);
  float4 detail_albedo = tex2D(_DetailAlbedoMap,
      UV_SCOFF_IMPL(raw_uv, _DetailNormalMap_ST));
  float3 detail_normal = UnpackScaleNormal(
      tex2D(_DetailNormalMap,
          UV_SCOFF_IMPL(raw_uv, _DetailNormalMap_ST)),
      _DetailNormalMapScale);
  result.albedo = lerp(result.albedo, result.albedo * detail_albedo, detail_mask);
  //result.albedo.a *= detail_albedo.a;
  normal_tangent = lerp(normal_tangent, blendNormalsHill12(normal_tangent, detail_normal), detail_mask);
#endif

#if defined(_ALPHA_MULTIPLIER)
  result.albedo.a = saturate(result.albedo.a * _Alpha_Multiplier);
#endif

#if defined(FORWARD_BASE_PASS)
#if defined(_EMISSION)
  result.emission = tex2D(_EmissionMap, UV_SCOFF(i, _EmissionMap_ST, /*which_channel=*/0)) * _EmissionColor;
#endif
#if defined(OUTLINE_PASS)
  result.emission += _Outline_Color * _Outline_Emission;
#endif
#endif  // FORWARD_BASE_PASS

#if defined(_METALLICS)
  float4 metallic_gloss = tex2D(_MetallicGlossMap, UV_SCOFF(i, _MetallicGlossMap_ST, /*which_channel=*/0));
  float metallic = metallic_gloss.r * _Metallic;
  float smoothness = metallic_gloss.a * _Smoothness;

  result.smoothness = smoothness;
  result.metallic = metallic;
#else
  result.smoothness = 0.2;
  result.metallic = 0;
#endif

#if defined(_AMBIENT_OCCLUSION)
  result.ao = lerp(1, tex2D(_OcclusionMap, i.uv01), _OcclusionStrength);
#else
  result.ao = 1;
#endif

  applyDecals(i, result.albedo, normal_tangent, result.metallic, result.smoothness, result.emission);
  const float min_roughness_perceptual = 0.045f;
  result.smoothness = min(1.0f - min_roughness_perceptual, result.smoothness);
  propagateRoughness(result.smoothness, result.roughness_perceptual, result.roughness);

#if defined(_OKLCH_CORRECTION)
  float3 lch = LRGBtoOKLCH(result.albedo.rgb);
  lch.x = lch.x * _Oklch_Correction_L;
  lch.y = lch.y * _Oklch_Correction_C;
  lch.z = lch.z * _Oklch_Correction_H;
  result.albedo.rgb = OKLCHtoLRGB(lch);
#endif

#if defined(_OKLAB_BRIGHTNESS_CLAMP)
  float3 lab = LRGBtoOKLAB(result.albedo.rgb);
  lab.x = clamp(lab.x, _Oklab_Brightness_Clamp_Min, _Oklab_Brightness_Clamp_Max);
  result.albedo.rgb = OKLABtoLRGB(lab);
#endif

  result.normal = normalize(mul(normal_tangent, tangentToWorld));

#if defined(_GRADIENT_NORMALS)
  applyGradientNormals(i, result);
#endif
#if defined(_SEA_FOAM)
  applySeaFoam(i, result);
#endif

#if (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS)) && defined(_GLITTER)
  GlitterParams glitter_p;
  glitter_p.color = _Glitter_Color;
  glitter_p.layers = _Glitter_Layers;
  glitter_p.cell_size = _Glitter_Grid_Size;
  glitter_p.size = _Glitter_Size;
  glitter_p.major_minor_ratio = _Glitter_Major_Minor_Ratio;
  glitter_p.angle_randomization_range = _Glitter_Angle_Randomization_Range;
  glitter_p.center_randomization_range = _Glitter_Center_Randomization_Range;
  glitter_p.size_randomization_range = _Glitter_Size_Randomization_Range;
  glitter_p.existence_chance = _Glitter_Existence_Chance;
#if defined(_GLITTER_ANGLE_LIMIT)
  glitter_p.angle_limit = _Glitter_Angle_Limit;
  glitter_p.angle_limit_transition_width = _Glitter_Angle_Limit_Transition_Width;
#endif
#if defined(_GLITTER_MASK)
  glitter_p.mask = _Glitter_Mask.SampleLevel(linear_repeat_s, i.uv01.xy, 0);
#endif
  float4 glitter_albedo = getGlitter(i, glitter_p, result.normal);
  result.albedo = alphaBlend(result.albedo, glitter_albedo);

  result.emission += glitter_albedo.rgb * glitter_albedo.a * _Glitter_Emission;
#endif

  return result;
}

#endif

