#ifndef __INTERPOLATORS_INC
#define __INTERPOLATORS_INC

#include "AutoLight.cginc"

struct appdata {
  float4 vertex  : POSITION;
  float2 uv0    : TEXCOORD0;
  float2 uv1    : TEXCOORD1;
  float3 normal  : NORMAL;
  float4 tangent : TANGENT;

  UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f {
	float4 pos         : SV_POSITION;
	float4 uv01        : TEXCOORD0;
	float3 objPos      : TEXCOORD1;
	float3 worldPos    : TEXCOORD2;
	float3 normal      : TEXCOORD3;
	float3 tangent     : TEXCOORD4;
	float3 binormal    : TEXCOORD5;
  float4 eyeVec      : TEXCOORD6; // eyeVec.xyz | fogCoord
  UNITY_LIGHTING_COORDS(7,8)

  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

#endif  // __INTERPOLATORS_INC
