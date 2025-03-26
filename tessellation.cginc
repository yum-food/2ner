#ifndef __TESSELLATION_INC
#define __TESSELLATION_INC

#include "globals.cginc"
#include "interpolators.cginc"

//ifex _Tessellation_Enabled==0

struct tess_factors {
  float edge[3] : SV_TessFactor;
  float inside : SV_InsideTessFactor;
};

tess_factors patch_constant(InputPatch<v2f, 3> patch) {
  tess_factors f;
#if defined(_TESSELLATION)
  f.edge[0] = _Tessellation_Edge_Factors[0];
  f.edge[1] = _Tessellation_Edge_Factors[1];
  f.edge[2] = _Tessellation_Edge_Factors[2];
  f.inside = _Tessellation_Inside_Factor;
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
  v2f o;
#define DOMAIN_INTERP(fieldName) \
  patch[0].fieldName * baryc.x + \
  patch[1].fieldName * baryc.y + \
  patch[2].fieldName * baryc.z
  o.pos      = DOMAIN_INTERP(pos);
  o.uv01     = DOMAIN_INTERP(uv01);
  o.objPos   = DOMAIN_INTERP(pos);
  o.worldPos = DOMAIN_INTERP(worldPos);
  o.normal   = DOMAIN_INTERP(normal);
  o.tangent  = DOMAIN_INTERP(tangent);
  o.binormal = DOMAIN_INTERP(binormal);
  o.eyeVec   = DOMAIN_INTERP(eyeVec);

  // TODO what about UNITY_LIGHTING_COORDS(7,8) and instance id and shit?
  return o;
}


//endex

#endif  // __TESSELLATION_INC

