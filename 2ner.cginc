#ifndef __2NER_INC
#define __2NER_INC

#include "UnityCG.cginc"
#include "UnityLightingCommon.cginc"
#include "AutoLight.cginc"

#include "custom30.cginc"
#include "eyes.cginc"
#include "face_me.cginc"
#include "false_color_visualization.cginc"
#include "features.cginc"
#include "fog.cginc"
#include "globals.cginc"
#include "harnack_tracing.cginc"
#include "interpolators.cginc"
#include "letter_grid.cginc"
#include "matcaps.cginc"
#include "math.cginc"
#include "poi.cginc"
#include "shatter_wave.cginc"
#include "ssao.cginc"
#include "ssfd.cginc"
#include "tessellation.cginc"
#include "unigram_letter_grid.cginc"
#include "vertex_domain_warping.cginc"
#include "yum_brdf.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

v2f vert(appdata v) {
#if defined(OUTLINE_PASS) && !defined(_OUTLINES)
  // The outline pass will be entirely elided when locked. This just lets us
  // hide outlines when not locked.
  return (v2f) (0.0/0.0);
#endif
#if defined(MASKED_STENCIL1_PASS)
  float masked_stencil1_mask = _Masked_Stencil1_Mask.SampleLevel(linear_repeat_s, v.uv0, 0);
  [branch]
  if (masked_stencil1_mask < 0.5) {
    return (v2f) (0.0/0.0);
  }
#endif
#if defined(MASKED_STENCIL2_PASS)
  float masked_stencil2_mask = _Masked_Stencil2_Mask.SampleLevel(linear_repeat_s, v.uv0, 0);
  [branch]
  if (masked_stencil2_mask < 0.5) {
    return (v2f) (0.0/0.0);
  }
#endif
#if defined(MASKED_STENCIL3_PASS)
  float masked_stencil3_mask = _Masked_Stencil3_Mask.SampleLevel(linear_repeat_s, v.uv0, 0);
  [branch]
  if (masked_stencil3_mask < 0.5) {
    return (v2f) (0.0/0.0);
  }
#endif
#if defined(MASKED_STENCIL4_PASS)
  float masked_stencil4_mask = _Masked_Stencil4_Mask.SampleLevel(linear_repeat_s, v.uv0, 0);
  [branch]
  if (masked_stencil4_mask < 0.5) {
    return (v2f) (0.0/0.0);
  }
#endif
#if defined(EXTRA_STENCIL_COLOR_PASS) && !defined(_EXTRA_STENCIL_COLOR_PASS)
	return (v2f) (0.0/0.0);
#endif

  v2f o;

  UNITY_SETUP_INSTANCE_ID(v);
  UNITY_INITIALIZE_OUTPUT(v2f, o);
  UNITY_TRANSFER_INSTANCE_ID(v, o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#if defined(_SPHERIZE)
  {
    float3 tgt_normal = normalize(o.objPos.xyz);
    float3 tgt_tangent = normalize(float3(tgt_normal.y, -tgt_normal.x, 0));
    float3 tgt_pos = tgt_normal * _Spherize_Radius;
    v.normal = normalize(lerp(v.normal, tgt_normal, _Spherize_Strength));
    v.vertex.xyz = lerp(v.vertex.xyz, tgt_pos, _Spherize_Strength);
  }
#endif
#if !defined(_TESSELLATION) && defined(_SHATTER_WAVE)
  shatterWaveVert(v.vertex.xyz, v.normal, v.tangent);
#endif

#if defined(_VERTEX_DOMAIN_WARPING)
  v.vertex.xyz = domainWarpVertexPosition(v.vertex.xyz);
#endif

#if defined(OUTLINE_PASS)
  [branch]
  if (!_Outlines_Enabled_Dynamic) {
    return (v2f) (0.0/0.0);
  }
#if defined(_OUTLINE_MASK)
  float thickness = _Outline_Mask.SampleLevel(linear_repeat_s, v.uv0, 0);
  thickness = (_Outline_Mask_Invert == 0 ? thickness : 1 - thickness);
#else
  float thickness = 1;
#endif
  v.vertex.xyz += _Outline_Width * v.normal * thickness;
  v.normal *= -1;
  v.tangent *= -1;
#endif  // OUTLINE_PASS

#if defined(_FACE_ME)
  face_me(v);
#endif

#if defined(_FOCAL_LENGTH_CONTROL)
  [branch]
  if (_Focal_Length_Enabled_Dynamic) {
    float4 fl_worldPos_unscaled = mul(unity_ObjectToWorld, v.vertex);
    float4 fl_viewPos_unscaled = mul(UNITY_MATRIX_V, fl_worldPos_unscaled);

    float4 fl_objPos = float4(v.vertex.xyz * _Focal_Length_Multiplier, v.vertex.w);
    float4 fl_worldPos = mul(unity_ObjectToWorld, fl_objPos);
    float4 fl_viewPos = mul(UNITY_MATRIX_V, fl_worldPos);
    fl_viewPos.xy /= _Focal_Length_Multiplier;

    float2 fl_compensation = fl_viewPos_unscaled.xy - fl_viewPos.xy;
    fl_viewPos.xy += fl_compensation;

    o.pos = mul(UNITY_MATRIX_P, fl_viewPos);
  } else {
    o.pos = UnityObjectToClipPos(v.vertex);
  }
#else
  o.pos = UnityObjectToClipPos(v.vertex);
#endif

#if defined(_TESSELLATION)
  o.tpos = v.vertex;
#endif
  o.uv01.xy = v.uv0;
  o.uv01.zw = v.uv1;
  o.uv23.xy = v.uv2;
  o.uv23.zw = v.uv3;
#if defined(_MIRROR_UVS_IN_MIRROR)
  [branch]
  if (isInMirror()) {
    o.uv01.x = 1.0 - o.uv01.x;
    o.uv01.z = 1.0 - o.uv01.z;
    o.uv23.x = 1.0 - o.uv23.x;
    o.uv23.z = 1.0 - o.uv23.z;
  }
#endif
  o.worldPos = mul(unity_ObjectToWorld, v.vertex);
  o.objPos = v.vertex;
  o.eyeVec.xyz = o.worldPos - _WorldSpaceCameraPos;
  o.eyeVec.w = 1;

  // These are used to convert normals from tangent space to world space.
  o.normal = v.normal;
  o.tangent = v.tangent.xyz;
  o.binormal = cross(o.normal, o.tangent) * v.tangent.w;

  UNITY_TRANSFER_LIGHTING(o, v.uv0);
  UNITY_TRANSFER_FOG_COMBINED_WITH_EYE_VEC(o, o.pos);
#if defined(SHADOW_CASTER_PASS)
	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
#endif

#if defined(SHADOWS_SCREEN)
  TRANSFER_SHADOW(o);
#endif

  // Vertex color
  o.color = v.color;
  return o;
}

float4 frag(v2f i, uint facing : SV_IsFrontFace
#if defined(_HARNACK_TRACING) || defined(_SHATTER_WAVE) || defined(_VERTEX_DOMAIN_WARPING) || (defined(_CUSTOM30) && !defined(_DEPTH_PREPASS)) || defined(_RAYMARCHED_FOG)
  , out float depth : SV_DepthLessEqual
#endif
) : SV_Target {
  UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);
  UNITY_SETUP_INSTANCE_ID(i);
  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

  // Not necessarily normalized after interpolation
  i.normal = normalize(i.normal);

  i.normal *= facing ? 1 : -1;
  i.normal = UnityObjectToWorldNormal(i.normal);
  i.tangent = UnityObjectToWorldNormal(i.tangent);
  i.binormal = UnityObjectToWorldNormal(i.binormal);
  const float3x3 tangentToWorld = float3x3(i.tangent, i.binormal, i.normal);

#if defined(_RAYMARCHED_FOG) && defined(FORWARD_BASE_PASS)
  {
    FogParams fog_params = {
      _Raymarched_Fog_Steps,
      _Raymarched_Fog_Density,
      _Raymarched_Fog_Y_Cutoff,
      _Raymarched_Fog_Dithering_Noise,
      _Raymarched_Fog_Dithering_Noise_TexelSize,
      _Raymarched_Fog_Density_Noise,
      _Raymarched_Fog_Density_Noise_Scale,
      _Raymarched_Fog_Velocity.xyz,
      #if defined(_RAYMARCHED_FOG_DENSITY_EXPONENT)
      _Raymarched_Fog_Density_Exponent,
      #endif
      #if defined(_RAYMARCHED_FOG_HEIGHT_DENSITY)
      _Raymarched_Fog_Height_Density_Min,
      _Raymarched_Fog_Height_Density_Max,
      _Raymarched_Fog_Height_Density_Power,
      #endif
    };
    FogResult fog_result = raymarched_fog(i, fog_params);
    depth = fog_result.depth;
    return fog_result.color;
  }
#endif

#if defined(_SHATTER_WAVE) || defined(_TESSELLATION_HEIGHTMAP)
  calcNormalInScreenSpace(i.normal, i.objPos);
#endif

#if defined(_SHATTER_WAVE) || defined(_VERTEX_DOMAIN_WARPING) || defined(_TESSELLATION_HEIGHTMAP)
  {
    [branch]
    if (
        false
#if defined(_SHATTER_WAVE)
        || any(_Shatter_Wave_Amplitude > 1E-4)
#endif
#if defined(_VERTEX_DOMAIN_WARPING)
        || _Vertex_Domain_Warping_Octaves > 0.1
#endif
#if defined(_TESSELLATION_HEIGHTMAP)
        || _Tessellation_Heightmap_Scale > 1E-4
#endif
    ) {
      float4 clip_pos = UnityObjectToClipPos(i.objPos);
      depth = clip_pos.z / clip_pos.w;
    } else {
      // Perspective division takes place before the fragment shader, so we
      // don't have to divide again.
      depth = i.pos.z;
    }
  }
#endif

#if defined(_EYE_EFFECT_00)
  EyeEffectOutput eye_effect_00 = EyeEffect_00(i);
  i.uv01.xy = eye_effect_00.uv;
#endif

  float ssao = 1;
#if defined(_SSAO)
	float2 debug;
	ssao = get_ssao(i, tangentToWorld, debug);
#endif

#if defined(_CUSTOM30) && defined(FORWARD_BASE_PASS) || (!defined(_DEPTH_PREPASS) && defined(SHADOW_CASTER_PASS))
#if defined(_CUSTOM30_BASICCUBE)
  Custom30Output basic_cube_output = BasicCube(i);
  i.pos = UnityObjectToClipPos(basic_cube_output.objPos);
  i.normal = basic_cube_output.normal;
#if !defined(_DEPTH_PREPASS)
  depth = basic_cube_output.depth;
#endif
#endif

#if defined(_CUSTOM30_BASICWEDGE)
  Custom30Output basic_wedge_output = BasicWedge(i);
  i.pos = UnityObjectToClipPos(basic_wedge_output.objPos);
  i.normal = basic_wedge_output.normal;
#if !defined(_DEPTH_PREPASS)
  depth = basic_wedge_output.depth;
#endif
#endif
#endif  // FORWARD_BASE_PASS

#if defined(_CUSTOM30_BASICPLATFORM)
  Custom30Output basic_platform_output = BasicPlatform(i);
  i.pos = UnityObjectToClipPos(basic_platform_output.objPos);
  i.normal = basic_platform_output.normal;
#if !defined(_DEPTH_PREPASS)
  depth = basic_platform_output.depth;
#endif
#endif

  YumPbr pbr = GetYumPbr(i, tangentToWorld);
	pbr.ao *= ssao;

#if defined(_HARNACK_TRACING)
  HarnackTracingOutput harnack_output = HarnackTracing(i);
  pbr.albedo = float4(1, 1, 1, 0.2);
  pbr.smoothness = 0.95;
  pbr.roughness_perceptual = 0.05;
  pbr.roughness = pbr.roughness_perceptual * pbr.roughness_perceptual;
  pbr.metallic = 0;
#endif

#if defined(_SSFD)
  float ssfd_mask = ssfd(i.uv01.xy, _SSFD_Scale, _SSFD_Max_Fwidth, 0, _SSFD_Noise);
  pbr.albedo *= (ssfd_mask > _SSFD_Threshold);
#endif

#if defined(OUTLINE_PASS)
  pbr.smoothness = 0;
  pbr.roughness = 1;
  pbr.roughness_perceptual = 1;
  pbr.metallic = 0;
#endif

#if defined(_EYE_EFFECT_00)
  pbr.normal = eye_effect_00.normal;
#endif

#if defined(_LETTER_GRID)
  LetterGridOutput letter_grid_output = LetterGrid(i);
  pbr.albedo.rgb = lerp(pbr.albedo.rgb, letter_grid_output.albedo, letter_grid_output.albedo.a);
  pbr.metallic = lerp(pbr.metallic, letter_grid_output.metallic, letter_grid_output.albedo.a);
  pbr.roughness = lerp(pbr.roughness, letter_grid_output.roughness, letter_grid_output.albedo.a);
#endif

#if defined(_UNIGRAM_LETTER_GRID)
  UnigramLetterGridOutput unigram_letter_grid_output = UnigramLetterGrid(i, facing);
  pbr.albedo.rgb = lerp(pbr.albedo.rgb, unigram_letter_grid_output.albedo,
      unigram_letter_grid_output.albedo.a);
  pbr.metallic = lerp(pbr.metallic, unigram_letter_grid_output.metallic,
      unigram_letter_grid_output.albedo.a);
  pbr.roughness = lerp(pbr.roughness, unigram_letter_grid_output.roughness,
      unigram_letter_grid_output.albedo.a);
#endif

  [branch]
  if (_Mode == 1) {
    clip(pbr.albedo.a - _Clip);
    pbr.albedo.a = 1;
  }

#if defined(EXTRA_STENCIL_COLOR_PASS) && defined(_EXTRA_STENCIL_COLOR_PASS)
  pbr.albedo = _ExtraStencilColor;
#endif

#if defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS) || defined(OUTLINE_PASS) || defined(EXTRA_STENCIL_COLOR_PASS)
  YumLighting l = GetYumLighting(i, pbr);

#if defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS)
  applyMatcapsAndRimLighting(i, pbr, l);
  l.diffuse = max(0, l.diffuse);
  l.specular = max(0, l.specular);
#endif

  pbr.albedo.rgb = visualizeInFalseColor(pbr.albedo.rgb);

  float4 lit = YumBRDF(i, l, pbr);

  lit.rgb += LightVolumeSpecular(pbr.albedo, pbr.smoothness, pbr.metallic,
      pbr.normal, l.view_dir, l.L00, l.L01r, l.L01g, l.L01b);

#if defined(_HARNACK_TRACING)
  pbr.albedo = harnack_output.color;
  pbr.smoothness = 0;
  pbr.roughness = 1;
  pbr.roughness_perceptual = 1;
  pbr.metallic = 0;
  pbr.normal = harnack_output.normal;
  l.NoL = saturate(dot(pbr.normal, l.dir));
  l.NoL_wrapped_s = l.NoL;
  l.NoL_wrapped_d = l.NoL;
  float4 harnack_lit = YumBRDF(i, l, pbr);
  //lit = alphaBlend(harnack_lit, lit);
  lit = harnack_lit;
  {
    float4 clip_pos = mul(UNITY_MATRIX_VP, float4(harnack_output.worldPos, 1.0));
    depth = clip_pos.z / clip_pos.w;
  }
#endif

#if defined(_EMISSION) || (defined(_GLITTER) && defined(FORWARD_BASE_PASS)) || defined(OUTLINE_PASS)
  lit.rgb += pbr.emission;
#endif
#if defined(_LETTER_GRID)
  lit.rgb += letter_grid_output.emission * letter_grid_output.albedo.a;
#endif
#if defined(_UNIGRAM_LETTER_GRID)
  lit.rgb += unigram_letter_grid_output.emission * unigram_letter_grid_output.albedo.a;
#endif

  UNITY_EXTRACT_FOG_FROM_EYE_VEC(i);
  UNITY_APPLY_FOG(_unity_fogCoord, lit.rgb);

  return lit;
#elif defined(SHADOW_CASTER_PASS) || defined(MASKED_STENCIL1_PASS) || defined(MASKED_STENCIL2_PASS) || defined(MASKED_STENCIL3_PASS) || defined(MASKED_STENCIL4_PASS) || defined(DEPTH_PREPASS)
  return 0;
#endif
}

#endif  // __2NER_INC
