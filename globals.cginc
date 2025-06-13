#ifndef __GLOBALS_INC
#define __GLOBALS_INC

#include "features.cginc"

#if defined(_SSAO) || defined(_RAYMARCHED_FOG)
UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
float4 _CameraDepthTexture_TexelSize;
#endif

SamplerState point_repeat_s;
SamplerState linear_repeat_s;
SamplerState bilinear_repeat_s;
SamplerState linear_clamp_s;
SamplerState trilinear_repeat_s;

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
float _Outline_Emission;
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

#define DECAL_ALPHA_BLEND_MODE_ALPHA_BLEND 0
#define DECAL_ALPHA_BLEND_MODE_REPLACE 1

#define DECLARE_DECAL_VARIABLES(n) \
texture2D _Decal##n##_MainTex; \
float4 _Decal##n##_MainTex_ST; \
float4 _Decal##n##_Color; \
float _Decal##n##_Opacity; \
float _Decal##n##_Angle; \
float _Decal##n##_UV_Channel; \
float _Decal##n##_Tiling_Mode; \
float _Decal##n##_Alpha_Blend_Mode; \
float _Decal##n##_Normal_Enabled; \
texture2D _Decal##n##_Normal; \
float4 _Decal##n##_Normal_ST; \
float _Decal##n##_Normal_Scale; \
\
float _Decal##n##_Reflections_Enabled; \
texture2D _Decal##n##_MetallicGlossMap; \
float4 _Decal##n##_MetallicGlossMap_ST; \
float _Decal##n##_Smoothness; \
float _Decal##n##_Metallic; \
\
float _Decal##n##_SDF_Enabled; \
float _Decal##n##_SDF_Threshold; \
float _Decal##n##_SDF_Invert; \
float _Decal##n##_SDF_Softness; \
float _Decal##n##_SDF_Px_Range; \
\
float _Decal##n##_Mask_Enabled; \
texture2D _Decal##n##_Mask; \
float4 _Decal##n##_Mask_ST; \
\
texture2D _Decal##n##_CMYK_Warping_Planes_Noise; \
float _Decal##n##_CMYK_Warping_Planes_Strength; \
float _Decal##n##_CMYK_Warping_Planes_Scale; \
float _Decal##n##_CMYK_Warping_Planes_Speed; \
\
texture2D _Decal##n##_Domain_Warping_Noise; \
float _Decal##n##_Domain_Warping_Octaves; \
float _Decal##n##_Domain_Warping_Strength; \
float _Decal##n##_Domain_Warping_Scale; \
float _Decal##n##_Domain_Warping_Speed;
#if defined(_DECAL0)
DECLARE_DECAL_VARIABLES(0)
#endif
#if defined(_DECAL1)
DECLARE_DECAL_VARIABLES(1)
#endif
#if defined(_DECAL2)
DECLARE_DECAL_VARIABLES(2)
#endif
#if defined(_DECAL3)
DECLARE_DECAL_VARIABLES(3)
#endif
#if defined(_DECAL4)
DECLARE_DECAL_VARIABLES(4)
#endif
#if defined(_DECAL5)
DECLARE_DECAL_VARIABLES(5)
#endif
#if defined(_DECAL6)
DECLARE_DECAL_VARIABLES(6)
#endif
#if defined(_DECAL7)
DECLARE_DECAL_VARIABLES(7)
#endif

#if defined(_VERTEX_DOMAIN_WARPING)
texture3D _Vertex_Domain_Warping_Noise;
float _Vertex_Domain_Warping_Strength;
float _Vertex_Domain_Warping_Scale;
float _Vertex_Domain_Warping_Octaves;
float _Vertex_Domain_Warping_Speed;
#endif  // _VERTEX_DOMAIN_WARPING

#if defined(_VERTEX_DOMAIN_WARPING_AUDIOLINK)
float _Vertex_Domain_Warping_Audiolink_VU_Strength_Factor;
float _Vertex_Domain_Warping_Audiolink_VU_Scale_Factor;
#endif  // _VERTEX_DOMAIN_WARPING_AUDIOLINK

#if defined(_UV_DOMAIN_WARPING)
texture2D _UV_Domain_Warping_Noise;
float _UV_Domain_Warping_Spatial_Strength;
float _UV_Domain_Warping_Spatial_Scale;
float _UV_Domain_Warping_Spatial_Octaves;
float _UV_Domain_Warping_Spatial_Speed;
float2 _UV_Domain_Warping_Spatial_Direction;
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

#if defined(_HARNACK_TRACING_GYROID)
float _Harnack_Tracing_Gyroid_Speed;
float _Harnack_Tracing_Gyroid_Scale;
#endif  // _HARNACK_TRACING_GYROID

#if defined(_FALSE_COLOR_VISUALIZATION)
float _False_Color_Visualization_Luminance;
float _False_Color_Visualization_Luminance_Bounded;
#endif  // _FALSE_COLOR_VISUALIZATION

#if defined(_LETTER_GRID)
texture2D _Letter_Grid_Texture;
float4 _Letter_Grid_Texture_TexelSize;
float _Letter_Grid_Tex_Res_X;
float _Letter_Grid_Tex_Res_Y;
float _Letter_Grid_Res_X;
float _Letter_Grid_Res_Y;
float4 _Letter_Grid_Data_Row_0;
float4 _Letter_Grid_Data_Row_1;
float4 _Letter_Grid_Data_Row_2;
float4 _Letter_Grid_Data_Row_3;
float4 _Letter_Grid_UV_Scale_Offset;
float _Letter_Grid_Padding;
float4 _Letter_Grid_Color;
float _Letter_Grid_Metallic;
float _Letter_Grid_Roughness;
float _Letter_Grid_Emission;
texture2D _Letter_Grid_Mask;
float _Letter_Grid_Global_Offset;
float _Letter_Grid_Screen_Px_Range;
float _Letter_Grid_Min_Screen_Px_Range;
float _Letter_Grid_Blurriness;
float _Letter_Grid_Alpha_Threshold;
#endif  // _LETTER_GRID

#if defined(_SHATTER_WAVE)
float4 _Shatter_Wave_Amplitude;
float4 _Shatter_Wave_Wavelength;
float4 _Shatter_Wave_Speed;
float4 _Shatter_Wave_Period;
float4 _Shatter_Wave_Time_Offset;
float4 _Shatter_Wave_Power;
float3 _Shatter_Wave_Direction0;
float3 _Shatter_Wave_Direction1;
float3 _Shatter_Wave_Direction2;
float3 _Shatter_Wave_Direction3;
#endif  // _SHATTER_WAVE

#if defined(_SHATTER_WAVE_AUDIOLINK)
float4 _Shatter_Wave_Chronotensity_Weights0;
float4 _Shatter_Wave_Chronotensity_Weights1;
float4 _Shatter_Wave_Chronotensity_Weights2;
float4 _Shatter_Wave_Chronotensity_Weights3;
float4 _Shatter_Wave_Chronotensity_Time_Factor;
#endif  // _SHATTER_WAVE_AUDIOLINK

#if defined(_SHATTER_WAVE_ROTATION)
float4 _Shatter_Wave_Rotation_Strength;
#endif  // _SHATTER_WAVE_ROTATION

#if defined(_TESSELLATION)
float _Tessellation_Factor;
#endif  // _TESSELLATION

#if defined(_TESSELLATION_HEIGHTMAP)
texture2D _Tessellation_Heightmap;
float4 _Tessellation_Heightmap_ST;
float _Tessellation_Heightmap_Scale;
float _Tessellation_Heightmap_Offset;
#endif  // _TESSELLATION_HEIGHTMAP

#if defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
float3 _Tessellation_Heightmap_Direction_Control_Vector;
#endif  // _TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL

#if defined(_TESSELLATION_RANGE_FACTOR)
float _Tessellation_Range_Factor_Distance_Near;
float _Tessellation_Range_Factor_Factor_Near;
float _Tessellation_Range_Factor_Distance_Far;
float _Tessellation_Range_Factor_Factor_Far;
#endif  // _TESSELLATION_RANGE_FACTOR

#if defined(_SPHERIZE)
float _Spherize_Radius;
float _Spherize_Strength;
#endif  // _SPHERIZE

#if defined(_3D_SDF)
texture3D _3D_SDF_Texture;
float4 _3D_SDF_ST;
float _3D_SDF_UV_Channel;
float4 _3D_SDF_Thresholds;
float4 _3D_SDF_Color_0;
float4 _3D_SDF_Color_1;
float4 _3D_SDF_Color_2;
float4 _3D_SDF_Color_3;
float _3D_SDF_Z;
float _3D_SDF_Z_Speed;
#endif  // _3D_SDF

#if defined(_CUSTOM30)
float _Custom30_ro_Offset;
float _Custom30_Quaternion_UV_Channel_0;
float _Custom30_Quaternion_UV_Channel_1;
#endif

#if defined(_CUSTOM30_BASICPLATFORM)
float3 _Custom30_BasicPlatform_Size;
float _Custom30_BasicPlatform_Frame_D;
float _Custom30_BasicPlatform_Core_D;
#endif  // _CUSTOM30_BASICPLATFORM

#if defined(_CUSTOM30_BASICPLATFORM_CHAMFER)
float3 _Custom30_BasicPlatform_Chamfer_Size;
#endif  // _CUSTOM30_BASICPLATFORM_CHAMFER

#if defined(_SSAO)
float _SSAO_Radius;
float _SSAO_Samples;
float _SSAO_Strength;
texture2D _SSAO_Noise;
float4 _SSAO_Noise_TexelSize;
float _SSAO_Bias;
#endif  // _SSAO

#if defined(_RAYMARCHED_FOG)
float3 _Raymarched_Fog_Color;
float _Raymarched_Fog_Steps;
float _Raymarched_Fog_Density;
texture2D _Raymarched_Fog_Dithering_Noise;
float4 _Raymarched_Fog_Dithering_Noise_TexelSize;
texture3D _Raymarched_Fog_Density_Noise;
float4 _Raymarched_Fog_Density_Noise_Scale;
float _Raymarched_Fog_Y_Cutoff;
float3 _Raymarched_Fog_Velocity;
#if defined(_RAYMARCHED_FOG_DENSITY_EXPONENT)
float _Raymarched_Fog_Density_Exponent;
#endif
#if defined(_RAYMARCHED_FOG_HEIGHT_DENSITY)
float _Raymarched_Fog_Height_Density_Start;
float _Raymarched_Fog_Height_Density_Half_Life;
#endif
#if defined(_CUSTOM30_FOG_HEIGHT_DENSITY_MINIMUM)
float _Custom30_Fog_Height_Density_Minimum;
#endif
#if defined(_RAYMARCHED_FOG_EMITTER_TEXTURE)
texture2D _Raymarched_Fog_Emitter_Texture;
float4 _Raymarched_Fog_Emitter_Texture_TexelSize;
float3 _Raymarched_Fog_Emitter_Texture_World_Pos;
float3 _Raymarched_Fog_Emitter_Texture_World_Normal;
float3 _Raymarched_Fog_Emitter_Texture_World_Tangent;
float2 _Raymarched_Fog_Emitter_Texture_World_Scale;
#endif
#endif  // _RAYMARCHED_FOG

#endif  // __GLOBALS_INC
