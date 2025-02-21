#ifndef __2NER_INC
#define __2NER_INC

#include "UnityCG.cginc"
#include "UnityLightingCommon.cginc"

#include "features.cginc"
#include "globals.cginc"
#include "interpolators.cginc"
#include "matcaps.cginc"
#include "poi.cginc"
#include "yum_brdf.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

v2f vert(appdata v) {
#if defined(OUTLINE_PASS) && !defined(_OUTLINES)
  // The outline pass will be entirely elided when locked. This just lets us
  // hide outlines when not locked.
  return (v2f) (0.0/0.0);
#endif

  v2f o;

  UNITY_SETUP_INSTANCE_ID(v);
  UNITY_INITIALIZE_OUTPUT(v2f, o);
  UNITY_TRANSFER_INSTANCE_ID(v, o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#if defined(OUTLINE_PASS)
#if defined(_OUTLINE_MASK)
  float thickness = _Outline_Mask.SampleLevel(linear_repeat_s, v.uv01, 0);
#else
  float thickness = 1;
#endif
  v.vertex.xyz += _Outline_Width * v.normal * thickness;
  v.normal *= -1;
  v.tangent *= -1;
#endif  // OUTLINE_PASS

#if defined(_VERTEX_DOMAIN_WARPING)
  float3 basePos = v.vertex.xyz;
  float offset = sin(_Time[0] * _Vertex_Domain_Warping_Speed) *
      _Vertex_Domain_Warping_Temporal_Strength;
  v.vertex.xyz = domainWarp3(v.vertex,
      _Vertex_Domain_Warping_Spatial_Octaves,
      _Vertex_Domain_Warping_Spatial_Strength,
      _Vertex_Domain_Warping_Spatial_Scale,
      offset);
  float3 tangent_tmp = v.tangent.xyz;
  domainWarp3Normals(v.normal, tangent_tmp, basePos,
      _Vertex_Domain_Warping_Spatial_Octaves,
      _Vertex_Domain_Warping_Spatial_Strength,
      _Vertex_Domain_Warping_Spatial_Scale,
      offset);
  v.tangent.xyz = tangent_tmp;
#endif

  o.pos = UnityObjectToClipPos(v.vertex);
  o.uv01 = v.uv01;
  o.worldPos = mul(unity_ObjectToWorld, v.vertex);
  o.eyeVec.xyz = normalize(o.worldPos - _WorldSpaceCameraPos);

  // These are used to convert normals from tangent space to world space.
  o.normal = UnityObjectToWorldNormal(v.normal);
  o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
  o.binormal = cross(o.normal, o.tangent) * v.tangent.w *
    unity_WorldTransformParams.w;

  UNITY_TRANSFER_LIGHTING(o, v.uv1);
  UNITY_TRANSFER_FOG_COMBINED_WITH_EYE_VEC(o, o.pos);
#if defined(SHADOW_CASTER_PASS)
	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
#endif
  return o;
}

float4 frag(v2f i) : SV_Target {
  UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);
  UNITY_SETUP_INSTANCE_ID(i);
  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

  // Not necessarily normalized after interpolation
  i.normal = normalize(i.normal);

  YumPbr pbr = GetYumPbr(i);

  UNITY_BRANCH
  if (_Mode == 1) {
    clip(pbr.albedo.a - _Clip);
    pbr.albedo.a = 1;
  }

#if defined(FORWARD_BASE_PASS)
  applyMatcapsAndRimLighting(i, pbr);
#endif

#if defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS) || defined(OUTLINE_PASS)
  YumLighting l = GetYumLighting(i, pbr);

  float4 lit = YumBRDF(i, l, pbr);

#if defined(_EMISSION)
  lit.rgb += pbr.emission;
#endif

  UNITY_EXTRACT_FOG_FROM_EYE_VEC(i);
  UNITY_APPLY_FOG(_unity_fogCoord, lit.rgb);
  return lit;
#elif defined(SHADOW_CASTER_PASS)
  return 0;
#endif
}

#endif  // __2NER_INC
