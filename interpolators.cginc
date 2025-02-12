#ifndef __INTERPOLATORS_INC
#define __INTERPOLATORS_INC

#include "AutoLight.cginc"

struct appdata {
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
};

struct v2f {
	float2 uv : TEXCOORD0;
	float4 pos : SV_POSITION;
	float3 worldPos : TEXCOORD1;
	float3 normal : TEXCOORD2;
	float3 tangent : TEXCOORD3;
	float3 bitangent : TEXCOORD4;
	SHADOW_COORDS(5)
};

#endif  // __INTERPOLATORS_INC
