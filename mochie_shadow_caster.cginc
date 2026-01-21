#include "UnityCG.cginc"

#include "custom30.cginc"
#include "features.cginc"
#include "interpolators.cginc"

v2f vert(appdata v)
{

#if !defined(_CAST_SHADOWS)
  return (v2f) (0.0/0.0);
#endif
#if defined(_RAYMARCHED_FOG)
  return (v2f) (0.0/0.0);
#endif
  v2f o = (v2f)0;
  UNITY_SETUP_INSTANCE_ID(v);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
  o.uv01.xy = v.uv0;
  o.uv01.zw = v.uv1;
  o.uv23.xy = v.uv2;
  o.uv23.zw = v.uv3;
  o.objPos = v.vertex;
#if defined(V2F_COLOR)
  o.color = v.color;
#endif
  return o;
}

float4 frag (v2f i) : SV_Target
{
  UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

#if defined(_DEPTH_PREPASS)
  return 0;
#endif

#if defined(_CUSTOM30)
  Custom30Output c30_out = (Custom30Output)0;
#if defined(_CUSTOM30_BASICCUBE)
  c30_out = BasicCube(i);
#elif defined(_CUSTOM30_BASICWEDGE)
  c30_out = BasicWedge(i);
#elif defined(_CUSTOM30_BASICPLATFORM)
  c30_out = BasicPlatform(i);
#elif defined(_CUSTOM30_RAINBOW)
  c30_out = Rainbow(i);
#endif

  i.pos = UnityObjectToClipPos(c30_out.objPos);
#endif

  return 0;
}

