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
#endif

#if defined(_VERTEX_DOMAIN_WARPING)
float _Vertex_Domain_Warping_Spatial_Strength;
float _Vertex_Domain_Warping_Spatial_Scale;
float _Vertex_Domain_Warping_Spatial_Octaves;
float _Vertex_Domain_Warping_Speed;
float _Vertex_Domain_Warping_Temporal_Strength;
#endif  // _VERTEX_DOMAIN_WARPING

#endif  // __GLOBALS_INC
