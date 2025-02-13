#ifndef __GLOBALS_INC
#define __GLOBALS_INC

SamplerState linear_repeat_s;

sampler2D _MainTex;
float4 _MainTex_ST;
fixed4 _Color;

sampler2D _BumpMap;
half _BumpScale;
float _BumpShadowHeightScale;
float _BumpShadowHardness;

sampler2D _OcclusionMap;
float _OcclusionStrength;

float _Shadow_Strength;
//ifex _Wrap_NoL_Strength>0
float _Wrap_NoL_Diffuse_Strength;
float _Wrap_NoL_Specular_Strength;
//endex

float _Clip;
int _Mode;
float _Smoothness;
float _Metallic;
float _Spherical_Harmonics;

float _reflectance;
float _specularAntiAliasingVariance;
float _specularAntiAliasingThreshold;

#if defined(OUTLINE_PASS)
float4 _Outline_Color;
float _Outline_Width;
#if defined(_OUTLINE_MASK)
texture2D _Outline_Mask;
#endif
#endif

#endif  // __GLOBALS_INC
