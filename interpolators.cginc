#ifndef __INTERPOLATORS_INC
#define __INTERPOLATORS_INC

#include "AutoLight.cginc"

struct appdata {
  float4 vertex   : POSITION;
  float2 uv0      : TEXCOORD0;
  float2 uv1      : TEXCOORD1;
  float2 uv2      : TEXCOORD2;
  float2 uv3      : TEXCOORD3;
  float3 normal   : NORMAL;
  float4 tangent  : TANGENT;
  float4 color    : COLOR;  // vertex color

  UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f {
#if defined(_TESSELLATION)
	float4 tpos         : INTERNALTESSPOS;
#endif
  linear noperspective centroid float4 pos         : SV_POSITION;
	float4 uv01        : TEXCOORD0;
	float4 uv23        : TEXCOORD1;  // just one more uv slot bro please
	float4 objPos      : TEXCOORD2;
	float3 worldPos    : TEXCOORD3;
	float3 normal      : TEXCOORD4;
	float3 tangent     : TEXCOORD5;
	float3 binormal    : TEXCOORD6;
  float4 eyeVec      : TEXCOORD7; // eyeVec.xyz | fogCoord
  float4 color       : TEXCOORD8;
  float3 vertexLight : TEXCOORD9;
  UNITY_LIGHTING_COORDS(10,11)

#if defined(_TROCHOID)
  float3 orig_pos : TEXCOORD12;
#endif

  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

#endif  // __INTERPOLATORS_INC
