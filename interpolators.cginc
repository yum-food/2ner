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
	float3 normal      : TEXCOORD3;
	float4 tangent     : TEXCOORD4;
  float4 vertexLight : TEXCOORD5; // vertexLight.xyz | furLayer
  UNITY_LIGHTING_COORDS(6,7)

#if defined(V2F_ORIG_POS)
  float3 orig_pos : TEXCOORD8;
#endif

#if defined(V2F_COLOR)
  float4 color       : TEXCOORD9;
#endif

  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// Fragment shader common data. f2f = fragment 2 fragment
struct f2f {
  float3 worldPos;
  float3 binormal;
  float3 eyeVec;
  float3 viewDir;
  float3x3 tbn;
};

#endif  // __INTERPOLATORS_INC
