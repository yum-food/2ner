#ifndef __CUSTOM30_INC
#define __CUSTOM30_INC

#include "globals.cginc"
#include "math.cginc"
#include "pema99.cginc"
#include "quilez.cginc"
#include "interpolators.cginc"

#if defined(_CUSTOM30)

#if defined(_DEPTH_PREPASS)
#define CUSTOM30_MAX_STEPS 10
#else
#define CUSTOM30_MAX_STEPS 30
#endif
#define SQRT_2     1.414213562
#define RCP_SQRT_2 0.707106781

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
  float c = RCP_SQRT_2;
  float s = RCP_SQRT_2;
  pp_xy = float2(c * p.x - s * p.y, s * p.x + c * p.y);
  d = max(d, distance_from_box(float3(pp_xy, p.z), box_size));

  pp_xz = float2(c * p.x - s * p.z, s * p.x + c * p.z);
  d = max(d, distance_from_box(float3(pp_xz, p.y), box_size));

  pp_yz = float2(c * p.y - s * p.z, s * p.y + c * p.z);
  d = max(d, distance_from_box(float3(pp_yz, p.x), box_size));

  return d;
}

float distance_from_hex_comb(
    float3 p,
    float3 period,
    float hex_sc,
    float zoff,
    float count) {
  float3 p_hex = cart_to_hex(p.xy);

  float half_period = period * 0.5;
  float3 which = abs(floor((p_hex + half_period) / period));
  p_hex = glsl_mod(p_hex + half_period, period) - half_period;

  p.xy = hex_to_cart(p_hex);

  float hex_d = distance_from_hex_prism(p -
      float3(0, 0, zoff), hex_sc);
  hex_d = any(which > count) ? 1E9 : hex_d;
  return hex_d;
}

float distance_from_hex_grid(
    float3 p,
    float2 period,
    float hex_sc,
    float zoff,
    float count) {
  float half_period = period * 0.5;
  float2 which = abs(floor((p.xy + half_period) / period));
  p.xy = glsl_mod(p.xy + half_period, period) - half_period;

  float hex_d = distance_from_hex_prism(p -
      float3(0, 0, zoff), hex_sc);
  hex_d = any(which > count) ? 1E9 : hex_d;
  hex_d = any(which % 2 == 0) ? 1E9 : hex_d;
  return hex_d;
}

#if defined(_CUSTOM30_BASICCUBE)
float BasicCube_map(float3 p) {
  float box_d = distance_from_box_frame(p, .995, .15);
  float core_dim = 0.95;
  float core_d = distance_from_box(p, core_dim);
  float d = min(box_d, core_d);

#if defined(_CUSTOM30_BASICCUBE_CHAMFER)
  d = cut_with_box(p, d, 1.3);
#endif

  // High rate of change = small size on screen = fade out grip.
  float scale = length(fwidth(p));

#if defined(_CUSTOM30_BASICCUBE_HEX_GRIP)
  float hex_grip_scale = scale * 10;
  [branch]
  if (hex_grip_scale < 1) {
    float period = 0.1;
    float hex_sc = period * 0.2;
    float count = 13;

    float zoff = core_dim - (hex_sc * 0.2) - hex_grip_scale * hex_sc;

    float3 pp = abs(p);
    pp = pp.z > pp.x && pp.z > pp.y ? pp.xyz : pp;
    pp = pp.y > pp.x && pp.y > pp.z ? pp.zxy : pp;
    pp = pp.x > pp.y && pp.x > pp.z ? pp.yzx : pp;

    float hex_d = distance_from_hex_comb(pp, period, hex_sc, zoff, count);
    hex_d = any(pp.xy > 0.85) ? 1E9 : hex_d;
    d = min(d, hex_d);
  }
#endif

#if defined(_CUSTOM30_BASICCUBE_HEX_BOLTS)
  float hex_bolt_scale = scale * 1;
  [branch]
  if (hex_bolt_scale < 1) {
    float period = 0.83;
    float hex_sc = period * 0.1;
    float count = 3;

    float zoff = core_dim - hex_sc * hex_bolt_scale;

    float3 pp = abs(p);
    pp = pp.z > pp.x && pp.z > pp.y ? pp.xyz : pp;
    pp = pp.y > pp.x && pp.y > pp.z ? pp.zxy : pp;
    pp = pp.x > pp.y && pp.x > pp.z ? pp.yzx : pp;
    d = min(d, distance_from_hex_grid(pp, period, hex_sc, zoff, count));
  }
#endif

  return d;
}

float3 BasicCube_normal(float3 p) {
  float epsilon = 5E-3;
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

  ro -= rd * _Custom30_ro_Offset;

  float d;
  float d_acc = 0;
  float epsilon = 1E-3;
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
#if !defined(_DEPTH_PREPASS)
  clip(epsilon - d);
#endif
  float3 objPos = ro + rd * d_acc;
  o.objPos = objPos;
  // Transform from SDF space back to object space
  float3 objSpacePos = objPos + (i.objPos + frag_to_origin);
  float4 clipPos = UnityObjectToClipPos(objSpacePos);
  o.depth = clipPos.z / clipPos.w;

  float3 sdfNormal = BasicCube_normal(objPos) * float3(-1, 1, 1);
  o.normal = UnityObjectToWorldNormal(sdfNormal);

  return o;
}
#endif

#if defined(_CUSTOM30_BASICWEDGE)
float BasicWedge_map(float3 p) {
  float box_d = distance_from_box(p, float3(1, 1, 1));
  float cut_plane_d = distance_from_plane(p - float3(0, 0, 0), -normalize(float3(1, 0, 1)), 0);

  float d = op_sub(box_d, cut_plane_d);

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
#if !defined(_DEPTH_PREPASS)
  clip(epsilon - d);
#endif
  float3 objPos = ro + rd * d_acc;
  o.objPos = objPos;
  // Transform from SDF space back to object space
  float3 objSpacePos = objPos + (i.objPos + frag_to_origin);
  float4 clipPos = UnityObjectToClipPos(objSpacePos);
  o.depth = clipPos.z / clipPos.w;

  float3 sdfNormal = BasicWedge_normal(objPos) * float3(-1, 1, 1);
  o.normal = UnityObjectToWorldNormal(sdfNormal);

  return o;
}
#endif

#if defined(_CUSTOM30_BASICPLATFORM)
float BasicPlatform_map(float3 p) {
  #if defined(_CUSTOM30_BASICPLATFORM_Y_ALIGNED)
    p.xy = p.yx;
  #endif

  float3 platform_size = _Custom30_BasicPlatform_Size;
  float box_d = distance_from_box_frame(p, platform_size, _Custom30_BasicPlatform_Frame_D);
  float core_d = distance_from_box(p, platform_size - _Custom30_BasicPlatform_Core_D);
  float d = min(box_d, core_d);

#if defined(_CUSTOM30_BASICPLATFORM_CHAMFER)
  {
    float3 pp = p;
    pp.yz = float2(RCP_SQRT_2 * p.y - RCP_SQRT_2 * p.z, RCP_SQRT_2 * p.y + RCP_SQRT_2 * p.z);
    float c = _Custom30_BasicPlatform_Chamfer_Size.x;
    d = max(d, distance_from_box(pp, float3(1.0, c, c)));
  }
  {
    float3 pp = p;
    pp.xz = float2(RCP_SQRT_2 * p.x - RCP_SQRT_2 * p.z, RCP_SQRT_2 * p.x + RCP_SQRT_2 * p.z);
    float c = _Custom30_BasicPlatform_Chamfer_Size.y;
    d = max(d, distance_from_box(pp, float3(c, 1.0, c)));
  }
  {
    float3 pp = p;
    pp.xy = float2(RCP_SQRT_2 * p.x - RCP_SQRT_2 * p.y, RCP_SQRT_2 * p.x + RCP_SQRT_2 * p.y);
    float c = _Custom30_BasicPlatform_Chamfer_Size.z;
    d = max(d, distance_from_box(pp, float3(c, c, 1.0)));
  }
#endif

  return d;
}

float3 BasicPlatform_normal(float3 p) {
  float epsilon = 1E-3;
  float center_d = BasicPlatform_map(p);
  float3 n = float3(
    BasicPlatform_map(p + float3(epsilon, 0, 0)) - center_d,
    BasicPlatform_map(p + float3(0, epsilon, 0)) - center_d,
    BasicPlatform_map(p + float3(0, 0, epsilon)) - center_d);
  return normalize(n);
}

Custom30Output BasicPlatform(v2f i) {
  float3 objSpaceCameraPos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1.0));

  float3 frag_to_origin = GetFragToOrigin(i);

  float3 ro = -frag_to_origin;
  float3 rd = normalize(i.objPos - objSpaceCameraPos);

  float d;
  float d_acc = 0;
  float epsilon = 5E-3;
  // Max distance for platform bounding sphere
  float max_d = length(float3(1.0, 0.4, 0.2)) * 2.0f;
  [loop]
  for (uint ii = 0; ii < CUSTOM30_MAX_STEPS; ++ii) {
    float3 p = ro + rd * d_acc;
    d = BasicPlatform_map(p);
    d_acc += d;
    if (d < epsilon) break;
    if (d_acc > max_d) break;
  }

  Custom30Output o;
#if !defined(_DEPTH_PREPASS)
  clip(epsilon - d);
#endif
  float3 objPos = ro + rd * d_acc;
  o.objPos = objPos;
  // Transform from SDF space back to object space
  float3 objSpacePos = objPos + (i.objPos + frag_to_origin);
  float4 clipPos = UnityObjectToClipPos(objSpacePos);
  o.depth = clipPos.z / clipPos.w;
  
  float3 sdfNormal = BasicPlatform_normal(objPos) * float3(-1, 1, 1);
  o.normal = UnityObjectToWorldNormal(sdfNormal);
  
  return o;
}
#endif

#endif  // _CUSTOM30
#endif  // __CUSTOM30_INC
