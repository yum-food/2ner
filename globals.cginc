#ifndef __GLOBALS_INC
#define __GLOBALS_INC

sampler2D _MainTex;
float4 _MainTex_ST;
fixed4 _Color;

sampler2D _BumpMap;
float _BumpScale;

sampler2D _OcclusionMap;
float _OcclusionStrength;

float _Clip;
int _Mode;
float _Smoothness;
float _Metallic;
float _Spherical_Harmonics;

float _reflectance;
float _specularAntiAliasingVariance;
float _specularAntiAliasingThreshold;

#endif  // __GLOBALS_INC
