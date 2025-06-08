#ifndef __VERTEX_DOMAIN_WARPING_INC
#define __VERTEX_DOMAIN_WARPING_INC

#include "audiolink.cginc"
#include "features.cginc"
#include "globals.cginc"
#include "math.cginc"

float3 domainWarpVertexPosition(float3 objPos) {
#if defined(_VERTEX_DOMAIN_WARPING)
  float speed = _Vertex_Domain_Warping_Speed;
  float scale = _Vertex_Domain_Warping_Scale;
  float strength = _Vertex_Domain_Warping_Strength;
  uint octaves = (uint) _Vertex_Domain_Warping_Octaves;

#if defined(_VERTEX_DOMAIN_WARPING_AUDIOLINK)
  [branch]
  if (AudioLinkIsAvailable()) {
    float vu = AudioLinkData(ALPASS_FILTEREDVU_INTENSITY + uint2(0, 0));
    strength += vu * _Vertex_Domain_Warping_Audiolink_VU_Strength_Factor;
    scale += vu * _Vertex_Domain_Warping_Audiolink_VU_Scale_Factor;
  }
#endif

  for (uint i = 0; i < octaves; i++) {
    float3 uv = objPos * scale + speed * _Time[0];
    float3 noise = _Vertex_Domain_Warping_Noise.SampleLevel(linear_repeat_s, uv, 0);
    objPos += (noise * 2 - 1) * strength;
  }
#endif  // _VERTEX_DOMAIN_WARPING
  return objPos;
}

#endif  // __VERTEX_DOMAIN_WARPING_INC

