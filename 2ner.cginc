#ifndef __2NER_INC
#define __2NER_INC

#include "UnityCG.cginc"
#include "UnityLightingCommon.cginc"

#include "globals.cginc"
#include "interpolators.cginc"
#include "poi.cginc"
#include "yum_brdf.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

v2f vert (appdata v) {
  v2f o;

  o.pos = UnityObjectToClipPos(v.vertex);
  o.uv = TRANSFORM_TEX(v.uv, _MainTex);
  o.worldPos = mul(unity_ObjectToWorld, v.vertex);

  // Calculate TBN matrix
  o.normal = UnityObjectToWorldNormal(v.normal);
  o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
  o.bitangent = cross(o.normal, o.tangent) * v.tangent.w;

  return o;
}

float4 frag (v2f i) : SV_Target {
  YumPbr pbr = GetYumPbr(i);

  UNITY_BRANCH
    if (_Mode == 1) {
      clip(pbr.albedo.a - _Clip);
    }

  YumLighting l = GetYumLighting(i, pbr);

  float4 lit = YumBRDF(i, l, pbr);

  return lit;
}

#endif  // __2NER_INC
