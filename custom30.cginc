#ifndef __CUSTOM30_INC
#define __CUSTOM30_INC

#include "globals.cginc"
#include "quilez.cginc"
#include "interpolators.cginc"

#if defined(_CUSTOM30)

#define CUSTOM30_MAX_STEPS 30

struct Custom30Output {
  float3 objPos;
  float3 normal;
  float depth;
};

float3 GetFragToOrigin(v2f i) {
  // Vector from fragment to origin
  return float3(-1, 1, 1) * (i.color * 2.0f - 1.0f) / i.color.a;
}

float cut_with_box(float3 p, float d, float3 box_size) {
  float2 pp_xy = p.xy;
  float2 pp_xz = p.xz;
  float2 pp_yz = p.yz;

  // Rotate by 45 degrees
  float c = 0.70710678;
  float s = 0.70710678;
  pp_xy = float2(c * p.x - s * p.y, s * p.x + c * p.y);
  d = max(d, distance_from_box(float3(pp_xy, p.z), box_size));

  pp_xz = float2(c * p.x - s * p.z, s * p.x + c * p.z);
  d = max(d, distance_from_box(float3(pp_xz, p.y), box_size));

  pp_yz = float2(c * p.y - s * p.z, s * p.y + c * p.z);
  d = max(d, distance_from_box(float3(pp_yz, p.x), box_size));

  return d;
}

#if defined(_CUSTOM30_BASICCUBE)
float BasicCube_map(float3 p) {
  float box_d = distance_from_box_frame(p, .995, .15);
  float core_d = distance_from_box(p, 0.95);
  float d = min(box_d, core_d);

  d = cut_with_box(p, d, 1.3);

  return d;
}

float3 BasicCube_normal(float3 p) {
  float epsilon = 1E-3;
  float center_d = BasicCube_map(p);
  float3 n = float3(
    BasicCube_map(p + float3(epsilon, 0, 0)) - center_d,
    BasicCube_map(p + float3(0, epsilon, 0)) - center_d,
    BasicCube_map(p + float3(0, 0, epsilon)) - center_d);
  return normalize(n);
}

Custom30Output BasicCube(v2f i) {
  float3 objSpaceCameraPos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0));

  float3 frag_to_origin = GetFragToOrigin(i);

  float3 ro = -frag_to_origin;
  float3 rd = normalize(i.objPos - objSpaceCameraPos);

  float d;
  float d_acc = 0;
  float epsilon = 5E-3;
  // 1.73... = sqrt(3)
  // our cube has an edge length of 2, so mult by 2
  float max_d = 1.73205081f * 2.0f;
  [loop]
  for (uint ii = 0; ii < CUSTOM30_MAX_STEPS; ++ii) {
    float3 p = ro + rd * d_acc;
    d = BasicCube_map(p);
    d_acc += d;
    if (d < epsilon) break;
    if (d_acc > max_d) break;
  }

  Custom30Output o;
  clip(epsilon - d);
  float3 objPos = ro + rd * d_acc;
  o.objPos = objPos;
  // Transform from SDF space back to object space
  float3 objSpacePos = objPos + (i.objPos + frag_to_origin);
  float4 clipPos = UnityObjectToClipPos(objSpacePos);
  o.depth = clipPos.z / clipPos.w;
  o.normal = BasicCube_normal(objPos);
  return o;
}
#endif

#if defined(_CUSTOM30_BASICWEDGE)
float BasicWedge_map(float3 p) {
  float box_d = distance_from_box(p, float3(1, 1, 1));
  float cut_plane_d = distance_from_plane(p - float3(0, 0, 0), -normalize(float3(1, 0, 1)), 0);

  float d = op_sub(box_d, cut_plane_d);
  //d = cut_with_box(p, d, 1.3);
  return d;
}

float3 BasicWedge_normal(float3 p) {
  float epsilon = 1E-3;
  float center_d = BasicWedge_map(p);
  float3 n = float3(
    BasicWedge_map(p + float3(epsilon, 0, 0)) - center_d,
    BasicWedge_map(p + float3(0, epsilon, 0)) - center_d,
    BasicWedge_map(p + float3(0, 0, epsilon)) - center_d);
  return normalize(n);
}

Custom30Output BasicWedge(v2f i) {
  float3 objSpaceCameraPos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0));

  float3 frag_to_origin = GetFragToOrigin(i);

  float3 ro = -frag_to_origin;
  float3 rd = normalize(i.objPos - objSpaceCameraPos);

  float d;
  float d_acc = 0;
  float epsilon = 5E-3;
  // 1.73... = sqrt(3)
  // our cube has an edge length of 2, so mult by 2
  float max_d = 1.73205081f * 2.0f;
  [loop]
  for (uint ii = 0; ii < CUSTOM30_MAX_STEPS; ++ii) {
    float3 p = ro + rd * d_acc;
    d = BasicWedge_map(p);
    d_acc += d;
    if (d < epsilon) break;
    if (d_acc > max_d) break;
  }

  Custom30Output o;
  clip(epsilon - d);
  float3 objPos = ro + rd * d_acc;
  o.objPos = objPos;
  // Transform from SDF space back to object space
  float3 objSpacePos = objPos + (i.objPos + frag_to_origin);
  float4 clipPos = UnityObjectToClipPos(objSpacePos);
  o.depth = clipPos.z / clipPos.w;
  o.normal = BasicWedge_normal(objPos);
  return o;
}
#endif

#endif  // _CUSTOM30
#endif  // __CUSTOM30_INC
