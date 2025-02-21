#ifndef __GLOBALS_INC
#define __GLOBALS_INC

#include "features.cginc"

SamplerState linear_repeat_s;

sampler2D _MainTex;
float4 _MainTex_ST;
fixed4 _Color;

sampler2D _BumpMap;
float4 _BumpMap_ST;
half _BumpScale;
float _BumpShadowHeightScale;
float _BumpShadowHardness;

#if defined(_EMISSION)
sampler2D _EmissionMap;
float4 _EmissionMap_ST;
float3 _EmissionColor;
#endif

#if defined(_AMBIENT_OCCLUSION)
sampler2D _OcclusionMap;
float _OcclusionStrength;
#endif

float _Shadow_Strength;

#if defined(_WRAPPED_LIGHTING)
float _Wrap_NoL_Diffuse_Strength;
float _Wrap_NoL_Specular_Strength;
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

#if defined(OUTLINE_PASS)
float4 _Outline_Color;
float _Outline_Width;
#if defined(_OUTLINE_MASK)
texture2D _Outline_Mask;
#endif
#endif

#define MATCAP_MODE_REPLACE     0
#define MATCAP_MODE_ADD         1
#define MATCAP_MODE_MULTIPLY    2
#define MATCAP_MODE_SUBTRACT    3
#define MATCAP_MODE_ADD_PRODUCT 4

#if defined(_MATCAP0)
texture2D _Matcap0;
uint _Matcap0_Mode;
float _Matcap0_Invert;
float _Matcap0_Strength;
#if defined(_MATCAP0_MASK)
texture2D _Matcap0_Mask;
#endif
#if defined(_MATCAP0_QUANTIZATION)
float _Matcap0_Quantization_Steps;
#endif
#endif

#if defined(_RIM_LIGHTING0)
uint _Rim_Lighting0_Mode;
float _Rim_Lighting0_Center;
float _Rim_Lighting0_Power;
float3 _Rim_Lighting0_Color;
float _Rim_Lighting0_Brightness;
#if defined(_RIM_LIGHTING0_MASK)
texture2D _Rim_Lighting0_Mask;
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
#if defined(_RIM_LIGHTING1_MASK)
texture2D _Rim_Lighting1_Mask;
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
#if defined(_RIM_LIGHTING2_MASK)
texture2D _Rim_Lighting2_Mask;
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
#if defined(_RIM_LIGHTING3_MASK)
texture2D _Rim_Lighting3_Mask;
#endif
#if defined(_RIM_LIGHTING3_ANGLE_LIMIT)
float2 _Rim_Lighting3_Angle_Limit_Target_Vector;
float _Rim_Lighting3_Angle_Limit_Power;
#endif
#if defined(_RIM_LIGHTING3_QUANTIZATION)
float _Rim_Lighting3_Quantization_Steps;
#endif
#endif

#if defined(_VERTEX_DOMAIN_WARPING)
float _Vertex_Domain_Warping_Spatial_Strength;
float _Vertex_Domain_Warping_Spatial_Scale;
float _Vertex_Domain_Warping_Spatial_Octaves;
float _Vertex_Domain_Warping_Speed;
float _Vertex_Domain_Warping_Temporal_Strength;
#endif  // _VERTEX_DOMAIN_WARPING

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

#endif  // __GLOBALS_INC
