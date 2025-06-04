#ifndef __YUM_PBR
#define __YUM_PBR

#include "audiolink.cginc"
#include "cnlohr.cginc"
#include "decals.cginc"
#include "features.cginc"
#include "filamented.cginc"
#include "glitter.cginc"
#include "globals.cginc"
#include "math.cginc"
#include "texture_utils.cginc"

struct YumPbr {
  float4 albedo;
  float3 normal;
#if defined(_EMISSION) || (defined(_GLITTER) && (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS))) || defined(OUTLINE_PASS)
  float3 emission;
#endif
  float smoothness;
  float roughness;
  float roughness_perceptual;
  float metallic;
  float ao;
};

void propagateRoughness(in float smoothness, out float roughness_perceptual, out float roughness) {
  roughness_perceptual = normalFiltering(1.0 - smoothness, float3(0, 0, 1));
  roughness = roughness_perceptual * roughness_perceptual;
}

YumPbr GetYumPbr(v2f i) {
  YumPbr result;

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

#if defined(_EMISSION)
  result.emission = tex2D(_EmissionMap, UV_SCOFF(i, _EmissionMap_ST, /*which_channel=*/0)) * _EmissionColor;
#endif
#if defined(OUTLINE_PASS)
#if defined(_EMISSION)
  result.emission += _Outline_Color * _Outline_Emission;
#else
  result.emission = _Outline_Color * _Outline_Emission;
#endif
#endif

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

  applyDecals(i, result.albedo, normal_tangent, result.metallic, result.smoothness);
  propagateRoughness(result.smoothness, result.roughness_perceptual, result.roughness);

  const float3x3 tangentToWorld = float3x3(i.tangent, i.binormal, i.normal);
  result.normal = normalize(mul(normal_tangent, tangentToWorld));

#if defined(_SSAO)
  {
    const float fragment_depth = GetDepthOfWorldPos(i.worldPos);

    float2 screen_uv;
    float perspective_factor;
    GetScreenUVAndPerspectiveFactor(i.worldPos, i.pos, screen_uv, perspective_factor);

    const float2 screen_px = screen_uv * _ScreenParams.xy;
    const float ssao_theta = _SSAO_Noise.SampleLevel(point_repeat_s, screen_px * _SSAO_Noise_TexelSize.xy, 0) * TAU;
    const float2x2 ssao_rot = float2x2(
        cos(ssao_theta), -sin(ssao_theta),
        sin(ssao_theta),  cos(ssao_theta));

    const float frame = ((float) AudioLinkData(ALPASS_GENERALVU + int2(1, 0)).x);

    float ssao_occlusion = 0;
    const float ssao_eps = 1E-5;
    [loop]
    for (uint ii = 0; ii < _SSAO_Samples; ii++) {
      // Compute random vector in tangent space.
      // Get the index of the current pixels, on the range [0, screen_width] x
      // [0, screen_height].
      // Map that onto the noise texture's pixels. Add an offset for each
      // index.
      float2 noise_uv = (float2(ii % _ScreenParams.x, ii * (_ScreenParams.z - 1.0f))) * _SSAO_Noise_TexelSize.xy;
      float3 sample_point = _SSAO_Noise.SampleLevel(point_repeat_s, noise_uv, 0).rgb;
      // Use a low discrepancy sequence to transform each sample over time.
      //sample_point = frac(sample_point + PHI * frame);
      sample_point.xy = 2.0 * sample_point.xy - 1.0;
      sample_point.xy = mul(ssao_rot, sample_point.xy);

      // Remap to world space.
      sample_point = mul(sample_point, tangentToWorld);
      float scale = (ii * 1.0f) / _SSAO_Samples;
      sample_point *= lerp(0.1f, 1.0f, scale * scale) * _SSAO_Radius;

      sample_point += i.worldPos;

      float sample_depth = GetDepthOfWorldPos(sample_point);

      // Depth values we're working with indicate how far you have to go along
      // the view vector before you hit the object in question. Therefore, we
      // care when the sample is *closer* to us than the object.
      float occlusion_amount = saturate((fragment_depth - sample_depth) - _SSAO_Bias);

      ssao_occlusion += occlusion_amount;
    }

    //result.albedo.xyz *= saturate(1.0 - _SSAO_Strength * ssao_occlusion / _SSAO_Samples);
    result.albedo.xyz = saturate(1.0 - _SSAO_Strength * ssao_occlusion / _SSAO_Samples);
  }
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

  float3 gitter_emission = glitter_albedo.rgb * glitter_albedo.a * _Glitter_Emission;
#if defined(_EMISSION)
  result.emission += gitter_emission;
#else
  result.emission = gitter_emission;
#endif
#endif

  return result;
}

#endif

