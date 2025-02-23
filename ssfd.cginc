#ifndef __SSFD_INC
#define __SSFD_INC

#include "globals.cginc"

float ssfd(float2 uv, float scale, float max_fwidth, float2 uv_offset, texture3D noise)
{
  //float uv_fw = fwidth(uv.x) + fwidth(uv.y);
  // Original paper uses SVD instead of fwidth.
  float2x2 M = float2x2(ddx(uv), ddy(uv));
  float2x2 MtM = mul(transpose(M), M);
  float trace = MtM[0][0] + MtM[1][1];
  float det = determinant(MtM);
  // Calculate eigenvalues using quadratic formula.
  float tmp = sqrt(trace * trace - 4 * det);
  float e1 = (trace + tmp) * 0.5;
  float e2 = (trace - tmp) * 0.5;
  float2 singular_values = sqrt(float2(e1, e2));
  // Logic from original paper: the smaller eigenvalue corresponds to the
  // largest amount of stretching, so we use it to determine when to
  // subdivide.
  float uv_fw = singular_values.y;
  uv_fw *= scale;

  uint width, height, depth;
  noise.GetDimensions(width, height, depth);
  float bayer_res = sqrt(depth);

  // Suppose max_fwidth is 1.
  // uv_fw is 16. That means UV is changing a lot per pixel. That means we want to shrink the scale of the UV.
  // Factor is 16.
  // log_2(factor) is 4.
  // Divide original by 16.
  float fw_factor = uv_fw / max_fwidth;
  // log_b(x) = log_a(x) / log_a(b)
  float fractal_level = log2(fw_factor) / log2(bayer_res);
  float fractal_level_floor = floor(fractal_level);
  float fractal_remainder = fractal_level - fractal_level_floor;

  uv *= pow(bayer_res, -fractal_level_floor);
  uv += uv_offset * pow(bayer_res, -fractal_level_floor);

  float n_layers = depth;
  float not_used_lo = 1/(n_layers*2);
  float not_used_hi = 1 - not_used_lo;

  float uvw = (not_used_hi - not_used_lo) * (1 - fractal_remainder) + not_used_lo;

  float3 uv_3d = float3(uv, uvw);

  float dither = noise.SampleLevel(linear_repeat_s, uv_3d, 0);

  return dither;
}

#endif  // __SSFD_INC

