#ifndef __TEXTURE_UTILS_INC
#define __TEXTURE_UTILS_INC

#include "interpolators.cginc"

float2 get_uv_by_channel(v2f i, uint which_channel) {
  [forcecase]
  switch (which_channel) {
    case 0:
      return i.uv01.xy;
      break;
    case 1:
      return i.uv01.zw;
      break;
    default:
      return 0;
      break;
  }
}

#define UV_SCOFF(i, tex_st, which_channel) get_uv_by_channel(i, round(which_channel)) * (tex_st).xy + (tex_st).zw

#endif  // __TEXTURE_UTILS_INC

