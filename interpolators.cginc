#ifndef __INTERPOLATORS_INC
#define __INTERPOLATORS_INC

#include "AutoLight.cginc"

struct appdata {
  float4 vertex : POSITION;
  float2 uv : TEXCOORD0;
  float2 uv1 : TEXCOORD1;
  float3 normal : NORMAL;
  float4 tangent : TANGENT;

  UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f {
	float4 pos       : SV_POSITION;
	float2 uv        : TEXCOORD0;
	float3 worldPos  : TEXCOORD1;
	float3 normal    : TEXCOORD2;
	float3 tangent   : TEXCOORD3;
	float3 bitangent : TEXCOORD4;
  float4 eyeVec    : TEXCOORD5; // eyeVec.xyz | fogCoord
  UNITY_LIGHTING_COORDS(6,7)

  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

#endif  // __INTERPOLATORS_INC
