#ifndef __GLOBALS_INC
#define __GLOBALS_INC

#include "features.cginc"

SamplerState linear_repeat_s;
SamplerState linear_clamp_s;

sampler2D _MainTex;
float4 _MainTex_ST;
fixed4 _Color;

sampler2D _BumpMap;
float4 _BumpMap_ST;
half _BumpScale;
float _BumpShadowHeightScale;
float _BumpShadowHardness;

float _VRChatMirrorMode;
float3 _VRChatMirrorCameraPos;

#if defined(_FACE_ME)
float _Face_Me_Enabled_Dynamic;
#endif

#if defined(_ALPHA_MULTIPLIER)
float _Alpha_Multiplier;
#endif

#if defined(_EMISSION)
sampler2D _EmissionMap;
float4 _EmissionMap_ST;
float3 _EmissionColor;
#endif

#if defined(_FALLBACK_CUBEMAP)
UNITY_DECLARE_TEXCUBE(_Fallback_Cubemap);
half4 _Fallback_Cubemap_HDR;
float _Fallback_Cubemap_Brightness;
float _Fallback_Cubemap_Force;
#endif

#if defined(_AMBIENT_OCCLUSION)
sampler2D _OcclusionMap;
float _OcclusionStrength;
#endif

#if defined(_DETAIL_MAPS)
texture2D _DetailMask;
sampler2D _DetailAlbedoMap;
float4 _DetailAlbedoMap_ST;
sampler2D _DetailNormalMap;
float4 _DetailNormalMap_ST;
float _DetailNormalMapScale;
#endif

float _Shadow_Strength;

#if defined(_WRAPPED_LIGHTING)
float _Wrap_NoL_Diffuse_Strength;
float _Wrap_NoL_Specular_Strength;
#endif

#if defined(_BRIGHTNESS_CONTROL)
float _Brightness_Multiplier;
#endif

#if defined(_MIN_BRIGHTNESS)
float _Min_Brightness;
#endif

#if defined(_QUANTIZE_NOL)
float _Quantize_NoL_Steps;
#endif

#if defined(_QUANTIZE_SPECULAR)
float _Quantize_Specular_Steps;
#endif

#if defined(_QUANTIZE_DIFFUSE)
float _Quantize_Diffuse_Steps;
#endif

float _Clip;
int _Mode;
float _Spherical_Harmonics;

float _reflectance;
float _specularAntiAliasingVariance;
float _specularAntiAliasingThreshold;

#if defined(_METALLICS)
float _Smoothness;
float _Metallic;
sampler2D _MetallicGlossMap;
float4 _MetallicGlossMap_ST;
#endif

#if defined(_CLEARCOAT)
float _Clearcoat_Strength;
float _Clearcoat_Roughness;
#endif

#if defined(OUTLINE_PASS)
float _Outlines_Enabled_Dynamic;
float4 _Outline_Color;
float _Outline_Width;
#if defined(_OUTLINE_MASK)
texture2D _Outline_Mask;
float _Outline_Mask_Invert;
#endif
#endif

#define MATCAP_MODE_REPLACE     0
#define MATCAP_MODE_ADD         1
#define MATCAP_MODE_MULTIPLY    2
#define MATCAP_MODE_SUBTRACT    3
#define MATCAP_MODE_ADD_PRODUCT 4

#define MATCAP_TARGET_ALBEDO     (1)
#define MATCAP_TARGET_DIFFUSE    (2)
#define MATCAP_TARGET_SPECULAR   (4)

#if defined(_MATCAP0)
texture2D _Matcap0;
uint _Matcap0_Mode;
uint _Matcap0_Target_Mask;
float _Matcap0_Invert;
float _Matcap0_Strength;
#if defined(_MATCAP0_MASK)
texture2D _Matcap0_Mask;
float4 _Matcap0_Mask_ST;
#endif
#if defined(_MATCAP0_QUANTIZATION)
float _Matcap0_Quantization_Steps;
#endif
#endif

#if defined(_MATCAP1)
texture2D _Matcap1;
uint _Matcap1_Mode;
uint _Matcap1_Target_Mask;
float _Matcap1_Invert;
float _Matcap1_Strength;
#if defined(_MATCAP1_MASK)
texture2D _Matcap1_Mask;
float4 _Matcap1_Mask_ST;
#endif
#if defined(_MATCAP1_QUANTIZATION)
float _Matcap1_Quantization_Steps;
#endif
#endif

#if defined(_RIM_LIGHTING0)
uint _Rim_Lighting0_Mode;
float _Rim_Lighting0_Center;
float _Rim_Lighting0_Power;
float3 _Rim_Lighting0_Color;
float _Rim_Lighting0_Brightness;
uint _Rim_Lighting0_Target_Mask;
#if defined(_RIM_LIGHTING0_MASK)
texture2D _Rim_Lighting0_Mask;
float4 _Rim_Lighting0_Mask_ST;
#endif
#if defined(_RIM_LIGHTING0_ANGLE_LIMIT)
float2 _Rim_Lighting0_Angle_Limit_Target_Vector;
float _Rim_Lighting0_Angle_Limit_Power;
#endif
#if defined(_RIM_LIGHTING0_QUANTIZATION)
float _Rim_Lighting0_Quantization_Steps;
#endif
#endif

#if defined(_RIM_LIGHTING1)
uint _Rim_Lighting1_Mode;
float _Rim_Lighting1_Center;
float _Rim_Lighting1_Power;
float3 _Rim_Lighting1_Color;
float _Rim_Lighting1_Brightness;
uint _Rim_Lighting1_Target_Mask;
#if defined(_RIM_LIGHTING1_MASK)
texture2D _Rim_Lighting1_Mask;
float4 _Rim_Lighting1_Mask_ST;
#endif
#if defined(_RIM_LIGHTING1_ANGLE_LIMIT)
float2 _Rim_Lighting1_Angle_Limit_Target_Vector;
float _Rim_Lighting1_Angle_Limit_Power;
#endif
#if defined(_RIM_LIGHTING1_QUANTIZATION)
float _Rim_Lighting1_Quantization_Steps;
#endif
#endif

#if defined(_RIM_LIGHTING2)
uint _Rim_Lighting2_Mode;
float _Rim_Lighting2_Center;
float _Rim_Lighting2_Power;
float3 _Rim_Lighting2_Color;
float _Rim_Lighting2_Brightness;
uint _Rim_Lighting2_Target_Mask;
#if defined(_RIM_LIGHTING2_MASK)
texture2D _Rim_Lighting2_Mask;
float4 _Rim_Lighting2_Mask_ST;
#endif
#if defined(_RIM_LIGHTING2_ANGLE_LIMIT)
float2 _Rim_Lighting2_Angle_Limit_Target_Vector;
float _Rim_Lighting2_Angle_Limit_Power;
#endif
#if defined(_RIM_LIGHTING2_QUANTIZATION)
float _Rim_Lighting2_Quantization_Steps;
#endif
#endif

#if defined(_RIM_LIGHTING3)
uint _Rim_Lighting3_Mode;
float _Rim_Lighting3_Center;
float _Rim_Lighting3_Power;
float3 _Rim_Lighting3_Color;
float _Rim_Lighting3_Brightness;
uint _Rim_Lighting3_Target_Mask;
#if defined(_RIM_LIGHTING3_MASK)
texture2D _Rim_Lighting3_Mask;
float4 _Rim_Lighting3_Mask_ST;
#endif
#if defined(_RIM_LIGHTING3_ANGLE_LIMIT)
float2 _Rim_Lighting3_Angle_Limit_Target_Vector;
float _Rim_Lighting3_Angle_Limit_Power;
#endif
#if defined(_RIM_LIGHTING3_QUANTIZATION)
float _Rim_Lighting3_Quantization_Steps;
#endif
#endif

#define DECAL_TILING_MODE_CLAMP 0
#define DECAL_TILING_MODE_TILE  1

#if defined(_DECAL0)
texture2D _Decal0_MainTex;
float4 _Decal0_MainTex_ST;
float4 _Decal0_Color;
float _Decal0_Opacity;
float _Decal0_Angle;
float _Decal0_Tiling_Mode;
#if defined(_DECAL0_NORMAL)
texture2D _Decal0_Normal;
float4 _Decal0_Normal_ST;
float _Decal0_Normal_Scale;
#endif
#if defined(_DECAL0_REFLECTIONS)
texture2D _Decal0_MetallicGlossMap;
float4 _Decal0_MetallicGlossMap_ST;
float _Decal0_Smoothness;
float _Decal0_Metallic;
#endif
#endif

#if defined(_VERTEX_DOMAIN_WARPING)
float _Vertex_Domain_Warping_Spatial_Strength;
float _Vertex_Domain_Warping_Spatial_Scale;
float _Vertex_Domain_Warping_Spatial_Octaves;
float _Vertex_Domain_Warping_Speed;
float _Vertex_Domain_Warping_Temporal_Strength;
#endif  // _VERTEX_DOMAIN_WARPING

#if defined(_UV_DOMAIN_WARPING)
float _UV_Domain_Warping_Spatial_Strength;
float _UV_Domain_Warping_Spatial_Scale;
float _UV_Domain_Warping_Spatial_Octaves;
#endif

#if defined(_EYE_EFFECT_00)
float _Gimmick_Eye_Effect_00_Edge_Length;
float3 _Gimmick_Eye_Effect_00_Period;
float3 _Gimmick_Eye_Effect_00_Count;
texture2D _Gimmick_Eye_Effect_00_Noise;
float _Gimmick_Eye_Effect_00_Domain_Warping_Octaves;
float _Gimmick_Eye_Effect_00_Domain_Warping_Scale;
float _Gimmick_Eye_Effect_00_Domain_Warping_Speed;
float _Gimmick_Eye_Effect_00_Domain_Warping_Strength;
#endif  // _EYE_EFFECT_00

#if defined(_SSFD)
float _SSFD_Scale;
float _SSFD_Max_Fwidth;
texture3D _SSFD_Noise;
float _SSFD_Size_Factor;
float _SSFD_Threshold;
#endif  // _SSFD

#if defined(_LTCGI)
float _LTCGI_Strength;
float4 _LTCGI_SpecularColor;
float4 _LTCGI_DiffuseColor;
#endif  // _LTCGI

#if defined(MASKED_STENCIL1_PASS)
texture2D _Masked_Stencil1_Mask;
#endif  // MASKED_STENCIL1_PASS

#if defined(MASKED_STENCIL2_PASS)
texture2D _Masked_Stencil2_Mask;
#endif  // MASKED_STENCIL2_PASS

#if defined(MASKED_STENCIL3_PASS)
texture2D _Masked_Stencil3_Mask;
#endif  // MASKED_STENCIL3_PASS

#if defined(MASKED_STENCIL4_PASS)
texture2D _Masked_Stencil4_Mask;
#endif  // MASKED_STENCIL4_PASS

#if defined(EXTRA_STENCIL_COLOR_PASS)
float4 _ExtraStencilColor;
#endif  // EXTRA_STENCIL_COLOR_PASS

#if defined(_FOCAL_LENGTH_CONTROL)
float _Focal_Length_Enabled_Dynamic;
float _Focal_Length_Multiplier;
#endif  // _FOCAL_LENGTH_CONTROL

#if defined(_GLITTER)
float4 _Glitter_Color;
float3 _Glitter_Emission;
float _Glitter_Layers;
float _Glitter_Grid_Size;
float _Glitter_Size;
float _Glitter_Major_Minor_Ratio;
float _Glitter_Angle_Randomization_Range;
float _Glitter_Center_Randomization_Range;
float _Glitter_Size_Randomization_Range;
float _Glitter_Existence_Chance;
#if defined(_GLITTER_ANGLE_LIMIT)
float _Glitter_Angle_Limit;
float _Glitter_Angle_Limit_Transition_Width;
#endif  // _GLITTER_ANGLE_LIMIT
#if defined(_GLITTER_MASK)
texture2D _Glitter_Mask;
#endif  // _GLITTER_MASK
#endif  // _GLITTER

#if defined(_MATERIAL_TYPE_CLOTH)
texture2D _Cloth_Mask;
float3 _Cloth_Sheen_Color;
float _Cloth_Direct_Multiplier;
float _Cloth_Indirect_Multiplier;
#if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
float3 _Cloth_Subsurface_Color;
#endif  // _MATERIAL_TYPE_CLOTH_SUBSURFACE
#endif  // _MATERIAL_TYPE_CLOTH

#endif  // __GLOBALS_INC
