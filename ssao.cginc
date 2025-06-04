#ifndef __SSAO_INC
#define __SSAO_INC

#include "audiolink.cginc"
#include "globals.cginc"
#include "interpolators.cginc"

#if defined(_SSAO)
float get_ssao(v2f i, float3x3 tangentToWorld, out float2 debug) {
  const float fragment_depth = GetDepthOfWorldPos(i.worldPos, debug);
  const float2 screen_px = (i.pos.xy + 0.5);
  const float2 screen_uv = (i.pos.xy + 0.5) / _ScreenParams.xy;
  const float ssao_theta = _SSAO_Noise.SampleLevel(point_repeat_s, screen_px * _SSAO_Noise_TexelSize.xy, 0) * TAU;
  const float2x2 ssao_rot = float2x2(
      cos(ssao_theta), -sin(ssao_theta),
      sin(ssao_theta),  cos(ssao_theta));

  const float frame = ((float) AudioLinkData(ALPASS_GENERALVU + int2(1, 0)).x);

  float ssao_occlusion = 0;
  const float ssao_eps = 1E-5;
  [loop]
  for (uint ii = 0; ii < _SSAO_Samples; ii++) {
    // Compute random vector in tangent space.
    // Get the index of the current pixels, on the range [0, screen_width] x
    // [0, screen_height].
    // Map that onto the noise texture's pixels. Add an offset for each
    // index.
    float2 noise_uv = (float2(ii % _ScreenParams.x, ii * (_ScreenParams.z - 1.0f))) * _SSAO_Noise_TexelSize.xy;
    float3 sample_point = _SSAO_Noise.SampleLevel(point_repeat_s, noise_uv, 0).rgb;
    // Use a low discrepancy sequence to transform each sample over time.
    //sample_point = frac(sample_point + PHI * frame);
    sample_point.xy = 2.0 * sample_point.xy - 1.0;
    sample_point.xy = mul(ssao_rot, sample_point.xy);

    // Remap to world space.
    sample_point = mul(sample_point, tangentToWorld);
    float scale = (ii * 1.0f) / _SSAO_Samples;
    sample_point *= lerp(0.1f, 1.0f, scale * scale) * _SSAO_Radius;

    sample_point += i.worldPos;

    float sample_depth = GetDepthOfWorldPos(sample_point, debug);

    // Depth values we're working with indicate how far you have to go along
    // the view vector before you hit the object in question. Therefore, we
    // care when the sample is *closer* to us than the object.
    float occlusion_amount = saturate((fragment_depth - sample_depth) - _SSAO_Bias);

    ssao_occlusion += occlusion_amount;
  }

  return saturate(1.0 - _SSAO_Strength * ssao_occlusion / _SSAO_Samples);
}
#endif

#endif  // __SSAO_INC

