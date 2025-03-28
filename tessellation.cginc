#ifndef __TESSELLATION_INC
#define __TESSELLATION_INC

#include "globals.cginc"
#include "interpolators.cginc"
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
  float d = length(getCenterCamPos() - patch[0].worldPos.xyz);
  float factor = lerp(
      _Tessellation_Range_Factor_Factor_Near,
      _Tessellation_Range_Factor_Factor_Far,
      smoothstep(
        _Tessellation_Range_Factor_Distance_Near,
        _Tessellation_Range_Factor_Distance_Far,
        d));
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
  v2f o;
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

#if defined(_TESSELLATION) && defined(_SHATTER_WAVE)
#if defined(OUTLINE_PASS)
  shatterWaveVert(o.objPos.xyz, -o.normal, o.tangent);
#else
  shatterWaveVert(o.objPos.xyz, o.normal, o.tangent);
#endif
#endif

#if defined(_TESSELLATION_HEIGHTMAP)
  float height = _Tessellation_Heightmap.SampleLevel(linear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_ST.xy, 0).r *
      _Tessellation_Heightmap_Scale +
      _Tessellation_Heightmap_Offset +
      _Tessellation_Heightmap_Scale * -0.5;
#if defined(OUTLINE_PASS)
  o.objPos.xyz += -o.normal * height;
#else
  o.objPos.xyz += o.normal * height;
#endif
#endif

  o.pos      = UnityObjectToClipPos(o.objPos);
  o.worldPos = mul(unity_ObjectToWorld, float4(o.objPos, 1.0)).xyz;
  o.eyeVec.xyz = normalize(o.worldPos - _WorldSpaceCameraPos);
  o.eyeVec.w = 1;

  // TODO what about UNITY_LIGHTING_COORDS(7,8) and instance id and shit?
  //UNITY_TRANSFER_LIGHTING(o, DOMAIN_INTERP(_unity_lightcoords));
  UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  return o;
}

//endex

#endif  // __TESSELLATION_INC

