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
  {
    // Frustum culling - don't tessellate if the patch is outside the viewport
    // (xy) or behind the camera (w). We approximate this by checking the
    // un-transformed and maximally transformed locations. Technically we could
    // miss an intersection in the middle, but I haven't noticed any visible
    // popping with this approach.
#if defined(_TESSELLATION_HEIGHTMAP)
    float max_displacement = _Tessellation_Heightmap_Scale * 0.5 + _Tessellation_Heightmap_Offset;
#else
    float max_displacement = 0;
#endif
    float3 p0d = patch[0].objPos.xyz + patch[0].normal.xyz * max_displacement;
    float3 p1d = patch[1].objPos.xyz + patch[1].normal.xyz * max_displacement;
    float3 p2d = patch[2].objPos.xyz + patch[2].normal.xyz * max_displacement;
    float4 p0_clipPos = UnityObjectToClipPos(patch[0].objPos.xyz);
    float4 p1_clipPos = UnityObjectToClipPos(patch[1].objPos.xyz);
    float4 p2_clipPos = UnityObjectToClipPos(patch[2].objPos.xyz);
    float4 p0d_clipPos = UnityObjectToClipPos(p0d);
    float4 p1d_clipPos = UnityObjectToClipPos(p1d);
    float4 p2d_clipPos = UnityObjectToClipPos(p2d);
    float3 p0_ndc = p0_clipPos.xyz / p0_clipPos.w;
    float3 p1_ndc = p1_clipPos.xyz / p1_clipPos.w;
    float3 p2_ndc = p2_clipPos.xyz / p2_clipPos.w;
    float3 p0d_ndc = p0d_clipPos.xyz / p0d_clipPos.w;
    float3 p1d_ndc = p1d_clipPos.xyz / p1d_clipPos.w;
    float3 p2d_ndc = p2d_clipPos.xyz / p2d_clipPos.w;

    bool on_screen =
        (p0_ndc.x > -1 && p0_ndc.x < 1 && p0_ndc.y > -1 && p0_ndc.y < 1 && p0_clipPos.w > 0) ||
        (p1_ndc.x > -1 && p1_ndc.x < 1 && p1_ndc.y > -1 && p1_ndc.y < 1 && p1_clipPos.w > 0) ||
        (p2_ndc.x > -1 && p2_ndc.x < 1 && p2_ndc.y > -1 && p2_ndc.y < 1 && p2_clipPos.w > 0) ||
        (p0d_ndc.x > -1 && p0d_ndc.x < 1 && p0d_ndc.y > -1 && p0d_ndc.y < 1 && p0d_clipPos.w > 0) ||
        (p1d_ndc.x > -1 && p1d_ndc.x < 1 && p1d_ndc.y > -1 && p1d_ndc.y < 1 && p1d_clipPos.w > 0) ||
        (p2d_ndc.x > -1 && p2d_ndc.x < 1 && p2d_ndc.y > -1 && p2d_ndc.y < 1 && p2d_clipPos.w > 0);
    factor = lerp(1, factor, on_screen);
  }
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

#if defined(_TESSELLATION_HEIGHTMAP)
#if 1
  float raw_noise = _Tessellation_Heightmap.SampleLevel(linear_repeat_s,
      o.uv01.xy * _Tessellation_Heightmap_ST.xy, 0).r;
  float height = raw_noise *
      _Tessellation_Heightmap_Scale +
      _Tessellation_Heightmap_Offset +
      _Tessellation_Heightmap_Scale * -0.5;
#else
  // For whatever reason, it seems like the texture read is initially
  // returning a small number when the mesh spawns in VRC. A procedural noise
  // works around the issue.
  float height = rand2(o.uv01.xy) * _Tessellation_Heightmap_Scale +
      _Tessellation_Heightmap_Offset +
      _Tessellation_Heightmap_Scale * -0.5;
#endif
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

  o.pos      = UnityObjectToClipPos(o.objPos);
  o.worldPos = mul(unity_ObjectToWorld, o.objPos).xyz;
  o.eyeVec.xyz = o.worldPos - _WorldSpaceCameraPos;
  o.eyeVec.w = 1;

  // TODO what about UNITY_LIGHTING_COORDS(7,8) and instance id and shit?
  //UNITY_TRANSFER_LIGHTING(o, DOMAIN_INTERP(_unity_lightcoords));
  UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  return o;
}

//endex

#endif  // __TESSELLATION_INC

