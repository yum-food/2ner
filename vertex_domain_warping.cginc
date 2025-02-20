#ifndef __VERTEX_DOMAIN_WARPING_INC
#define __VERTEX_DOMAIN_WARPING_INC

#include "math.cginc"

float3 domainWarpVertexPosition(float3 vertex, float3 normal, float3 tangent,
    float3 binormal, float3 worldPos, float3 centerCamPos) {
  float3 worldNormal = UnityObjectToWorldNormal(normal);
  float3 worldTangent = UnityObjectToWorldDir(tangent);
  float3 worldBinormal = cross(worldNormal, worldTangent) * tangent.w * unity_WorldTransformParams.w;

  float3 worldPos = mul(unity_ObjectToWorld, vertex);
}

#endif  // __VERTEX_DOMAIN_WARPING_INC

