#ifndef __TESSELLATION_INC
#define __TESSELLATION_INC

#include "globals.cginc"
#include "interpolators.cginc"
#include "math.cginc"
#include "shatter_wave.cginc"

//ifex _Tessellation_Enabled==0

struct tess_factors {
  float edge[3] : SV_TessFactor;
  float inside : SV_InsideTessFactor;
};

tess_factors patch_constant(InputPatch<v2f, 3> patch) {
  tess_factors f;
#if defined(_TESSELLATION)
#if defined(_TESSELLATION_RANGE_FACTOR)
  float3 vec = getCenterCamPos() - patch[0].worldPos.xyz;
  float d2 = dot(vec, vec);
  float factor = lerp(
      _Tessellation_Range_Factor_Factor_Near,
      _Tessellation_Range_Factor_Factor_Far,
      smoothstep(
        _Tessellation_Range_Factor_Distance_Near,
        _Tessellation_Range_Factor_Distance_Far,
        d2));
#else
  float factor = _Tessellation_Factor;
#endif
#else
  float factor = 1;
#endif
  f.edge[0] = factor;
  f.edge[1] = factor;
  f.edge[2] = factor;
  f.inside = factor;
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

#if defined(_TESSELLATION) && defined(_SHATTER_WAVE)
#if defined(OUTLINE_PASS)
  shatterWaveVert(o.objPos.xyz, -o.normal, o.tangent);
#else
  shatterWaveVert(o.objPos.xyz, o.normal, o.tangent);
#endif
#endif

#if defined(_TESSELLATION) && (defined(_TESSELLATION_HEIGHTMAP_0) || defined(_TESSELLATION_HEIGHTMAP_1) || defined(_TESSELLATION_HEIGHTMAP_2) || defined(_TESSELLATION_HEIGHTMAP_3) || defined(_TESSELLATION_HEIGHTMAP_4) || defined(_TESSELLATION_HEIGHTMAP_5) || defined(_TESSELLATION_HEIGHTMAP_6) || defined(_TESSELLATION_HEIGHTMAP_7))
  float3 height = 0;
#if defined(_TESSELLATION_HEIGHTMAP_0)
  float3 heightmap_0_sample = _Tessellation_Heightmap_0.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_0_ST.xy, 0);
  height += heightmap_0_sample * _Tessellation_Heightmap_0_Scale + _Tessellation_Heightmap_0_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_1)
  float3 heightmap_1_sample = _Tessellation_Heightmap_1.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_1_ST.xy, 0);
  height += heightmap_1_sample * _Tessellation_Heightmap_1_Scale + _Tessellation_Heightmap_1_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_2)
  float3 heightmap_2_sample = _Tessellation_Heightmap_2.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_2_ST.xy, 0);
  height += heightmap_2_sample * _Tessellation_Heightmap_2_Scale + _Tessellation_Heightmap_2_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_3)
  float3 heightmap_3_sample = _Tessellation_Heightmap_3.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_3_ST.xy, 0);
  height += heightmap_3_sample * _Tessellation_Heightmap_3_Scale + _Tessellation_Heightmap_3_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_4)
  float3 heightmap_4_sample = _Tessellation_Heightmap_4.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_4_ST.xy, 0);
  height += heightmap_4_sample * _Tessellation_Heightmap_4_Scale + _Tessellation_Heightmap_4_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_5)
  float3 heightmap_5_sample = _Tessellation_Heightmap_5.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_5_ST.xy, 0);
  height += heightmap_5_sample * _Tessellation_Heightmap_5_Scale + _Tessellation_Heightmap_5_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_6)
  float3 heightmap_6_sample = _Tessellation_Heightmap_6.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_6_ST.xy, 0);
  height += heightmap_6_sample * _Tessellation_Heightmap_6_Scale + _Tessellation_Heightmap_6_Offset;
#endif
#if defined(_TESSELLATION_HEIGHTMAP_7)
  float3 heightmap_7_sample = _Tessellation_Heightmap_7.SampleLevel(bilinear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_7_ST.xy, 0);
  height += heightmap_7_sample * _Tessellation_Heightmap_7_Scale + _Tessellation_Heightmap_7_Offset;
#endif

#if defined(_TESSELLATION_HEIGHTMAP_WORLD_SPACE)
  o.objPos.xyz += mul(unity_WorldToObject, height).xyz;
#else
#if defined(OUTLINE_PASS) && defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
  float3 heightmap_direction = mul(transpose(-float3x3(o.normal, o.tangent, o.binormal)), _Tessellation_Heightmap_Direction_Control_Vector);
#elif defined(OUTLINE_PASS) && !defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
  float3 heightmap_direction = -o.normal;
#elif !defined(OUTLINE_PASS) && defined(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)
  float3 heightmap_direction = mul(transpose(float3x3(o.normal, o.tangent, o.binormal)), _Tessellation_Heightmap_Direction_Control_Vector);
#else
  float3 heightmap_direction = o.normal;
#endif
  o.objPos.xyz += heightmap_direction * height;
#endif

#endif  // _TESSELLATION_HEIGHTMAP

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

