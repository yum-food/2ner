#ifndef __TESSELLATION_INC
#define __TESSELLATION_INC

#include "globals.cginc"
#include "interpolators.cginc"
#include "math.cginc"
#include "shatter_wave.cginc"
#include "trochoid.cginc"

//ifex _Tessellation_Enabled==0

struct tess_factors {
  float edge[3] : SV_TessFactor;
  float inside : SV_InsideTessFactor;
};

bool cullPatch(float4 p0, float4 p1, float4 p2, float bias) {
  return
    (p0.x < -p0.w - bias && p1.x < -p1.w - bias && p2.x < -p2.w - bias) ||
    (p0.x > p0.w + bias && p1.x > p1.w + bias && p2.x > p2.w + bias) ||
    (p0.y < -p0.w - bias && p1.y < -p1.w - bias && p2.y < -p2.w - bias) ||
    (p0.y > p0.w + bias && p1.y > p1.w + bias && p2.y > p2.w + bias) ||
    (p0.z < -p0.w - bias && p1.z < -p1.w - bias && p2.z < -p2.w - bias) ||
    (p0.z > p0.w + bias && p1.z > p1.w + bias && p2.z > p2.w + bias);
}

#if defined(_TESSELLATION_HEIGHTMAP_0) || defined(_TESSELLATION_HEIGHTMAP_1) || defined(_TESSELLATION_HEIGHTMAP_2) || defined(_TESSELLATION_HEIGHTMAP_3) || defined(_TESSELLATION_HEIGHTMAP_4) || defined(_TESSELLATION_HEIGHTMAP_5) || defined(_TESSELLATION_HEIGHTMAP_6) || defined(_TESSELLATION_HEIGHTMAP_7)
#define _TESSELLATION_HEIGHTMAP
#endif

float4 applyHeightmap(float4 objPos, float2 uv, float3 normal, float3 tangent, float3 binormal) {
#if defined(_TESSELLATION) && defined(_TESSELLATION_HEIGHTMAP)
  float3 height = 0;
#if defined(_TESSELLATION_HEIGHTMAP_0)
  float3 heightmap_0_sample = _Tessellation_Heightmap_0.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_0_ST.xy, 0);
  height += heightmap_0_sample * _Tessellation_Heightmap_0_Scale + _Tessellation_Heightmap_0_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_1)
  float3 heightmap_1_sample = _Tessellation_Heightmap_1.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_1_ST.xy, 0);
  height += heightmap_1_sample * _Tessellation_Heightmap_1_Scale + _Tessellation_Heightmap_1_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_2)
  float3 heightmap_2_sample = _Tessellation_Heightmap_2.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_2_ST.xy, 0);
  height += heightmap_2_sample * _Tessellation_Heightmap_2_Scale + _Tessellation_Heightmap_2_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_3)
  float3 heightmap_3_sample = _Tessellation_Heightmap_3.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_3_ST.xy, 0);
  height += heightmap_3_sample * _Tessellation_Heightmap_3_Scale + _Tessellation_Heightmap_3_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_4)
  float3 heightmap_4_sample = _Tessellation_Heightmap_4.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_4_ST.xy, 0);
  height += heightmap_4_sample * _Tessellation_Heightmap_4_Scale + _Tessellation_Heightmap_4_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_5)
  float3 heightmap_5_sample = _Tessellation_Heightmap_5.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_5_ST.xy, 0);
  height += heightmap_5_sample * _Tessellation_Heightmap_5_Scale + _Tessellation_Heightmap_5_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_6)
  float3 heightmap_6_sample = _Tessellation_Heightmap_6.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_6_ST.xy, 0);
  height += heightmap_6_sample * _Tessellation_Heightmap_6_Scale + _Tessellation_Heightmap_6_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_7)
  float3 heightmap_7_sample = _Tessellation_Heightmap_7.SampleLevel(bilinear_repeat_s,
      uv * _Tessellation_Heightmap_7_ST.xy, 0);
  height += heightmap_7_sample * _Tessellation_Heightmap_7_Scale + _Tessellation_Heightmap_7_Offset;
#endif

#if defined(_TESSELLATION_HEIGHTMAP_WORLD_SPACE)
  objPos.xyz += mul(unity_WorldToObject, height).xyz;
#else
#if defined(OUTLINE_PASS) && defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
  float3 heightmap_direction = mul(transpose(-float3x3(normal, tangent, binormal)), _Tessellation_Heightmap_Direction_Control_Vector);
#elif defined(OUTLINE_PASS) && !defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
  float3 heightmap_direction = -normal;
#elif !defined(OUTLINE_PASS) && defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
  float3 heightmap_direction = mul(transpose(float3x3(normal, tangent, binormal)), _Tessellation_Heightmap_Direction_Control_Vector);
#else
  float3 heightmap_direction = normal;
#endif
  objPos.xyz += heightmap_direction * height;
#endif
#endif  // _TESSELLATION_HEIGHTMAP
  return objPos;
}

tess_factors patch_constant(InputPatch<v2f, 3> patch) {
  tess_factors f;

#if defined(_TESSELLATION)
  float4 p0 = patch[0].pos;
  float4 p1 = patch[1].pos;
  float4 p2 = patch[2].pos;

  [branch]
  if (cullPatch(p0, p1, p2, _Tessellation_Frustum_Culling_Bias)) {
    f.edge[0] = 1;
    f.edge[1] = 1;
    f.edge[2] = 1;
    f.inside = 1;
    return f;
  }

  // https://catlikecoding.com/unity/tutorials/advanced-rendering/tessellation/
  float2 p0_clip = p0.xy / p0.w;
  float2 p1_clip = p1.xy / p1.w;
  float2 p2_clip = p2.xy / p2.w;

  float l01 = distance(p0_clip, p1_clip);
  float l12 = distance(p1_clip, p2_clip);
  float l20 = distance(p2_clip, p0_clip);

  float edgeLength = _Tessellation_Factor;

  f.edge[2] = l01 * edgeLength;
  f.edge[0] = l12 * edgeLength;
  f.edge[1] = l20 * edgeLength;

  f.inside = (f.edge[0] + f.edge[1] + f.edge[2]) * 0.333333f;
#else
  f.edge[0] = 1;
  f.edge[1] = 1;
  f.edge[2] = 1;
  f.inside = 1;
#endif

  return f;
}

[UNITY_domain("tri")]
[UNITY_outputcontrolpoints(3)]
[UNITY_outputtopology("triangle_cw")]
[UNITY_partitioning("fractional_odd")]
[UNITY_patchconstantfunc("patch_constant")]
v2f hull(
    InputPatch<v2f, 3> patch,
    uint id : SV_OutputControlPointID)
{
  return patch[id];
}

[UNITY_domain("tri")]
v2f domain(
    tess_factors factors,
    OutputPatch<v2f, 3> patch,
    float3 baryc : SV_DomainLocation)
{
  v2f o = (v2f) 0;
#define DOMAIN_INTERP(fieldName) \
  patch[0].fieldName * baryc.x + \
  patch[1].fieldName * baryc.y + \
  patch[2].fieldName * baryc.z
#if defined(_TESSELLATION)
  o.objPos   = DOMAIN_INTERP(tpos);
#else
  o.objPos   = DOMAIN_INTERP(objPos);
#endif
  o.normal   = DOMAIN_INTERP(normal);
  o.tangent  = DOMAIN_INTERP(tangent);
  o.binormal = DOMAIN_INTERP(binormal);
  o.uv01     = DOMAIN_INTERP(uv01);
  o.uv23     = DOMAIN_INTERP(uv23);
  o.color     = DOMAIN_INTERP(color);
  o.vertexLight     = DOMAIN_INTERP(vertexLight);
#if defined(_TROCHOID)
  o.orig_pos = DOMAIN_INTERP(orig_pos);
#endif

#if defined(_TESSELLATION) && defined(_TROCHOID)
  o.objPos.xyz = trochoid_map(o.orig_pos.xyz);
#endif

#if defined(_TESSELLATION) && defined(_SHATTER_WAVE)
#if defined(OUTLINE_PASS)
  shatterWaveVert(o.objPos.xyz, -o.normal, o.tangent);
#else
  shatterWaveVert(o.objPos.xyz, o.normal, o.tangent);
#endif
#endif

  o.objPos = applyHeightmap(o.objPos, o.uv01.xy, o.normal, o.tangent, o.binormal);

  o.pos      = UnityObjectToClipPos(o.objPos);
  o.worldPos = mul(unity_ObjectToWorld, o.objPos).xyz;
  o.eyeVec.xyz = o.worldPos - _WorldSpaceCameraPos;
  o.eyeVec.w = 1;

  //UNITY_TRANSFER_LIGHTING(o, v);
  UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#if defined(SHADOW_CASTER_PASS)
	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
#endif
  return o;
}

//endex

#endif  // __TESSELLATION_INC

