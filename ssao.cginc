#ifndef __SSAO_INC
#define __SSAO_INC

#include "audiolink.cginc"
#include "globals.cginc"
#include "interpolators.cginc"

#if defined(_SSAO)
float get_ssao(v2f i, f2f f, out float2 debug) {
  float3 objPos = mul(unity_WorldToObject, float4(i.worldPos, 1));
  float4 clipPos = UnityObjectToClipPos(objPos);
  float4 screenPos = ComputeScreenPos(clipPos);
  const float2 screen_uv = screenPos.xy / screenPos.w;
  const float2 screen_px = screen_uv * _ScreenParams.xy;

  const float fragment_depth = GetDepthOfWorldPos(i.worldPos, debug);
  const float3 noise = _SSAO_Noise.SampleLevel(point_repeat_s, screen_px * _SSAO_Noise_TexelSize.xy, 0);
  float ssao_theta = noise.x;
  const float frame = ((float) AudioLinkData(ALPASS_GENERALVU + int2(1, 0)).x);
  ssao_theta += frame * PHI;
  ssao_theta *= TAU;
  const float2x2 ssao_rot = float2x2(
      cos(ssao_theta), -sin(ssao_theta),
      sin(ssao_theta),  cos(ssao_theta));

  [branch]
  if (round(_SSAO_Samples) < 1) {
    return 1;
  }

  float ssao_occlusion = 0;
  const float ssao_eps = 1E-5;
  [loop]
  for (uint ii = 0; ii < round(_SSAO_Samples); ii++) {
    // Compute random vector in tangent space.
    // Get the index of the current pixels, on the range [0, screen_width] x
    // [0, screen_height].
    // Map that onto the noise texture's pixels. Add an offset for each
    // index.
    float2 noise_uv = (float2(ii % _ScreenParams.x, ii * (_ScreenParams.z - 1.0f))) * _SSAO_Noise_TexelSize.xy;
#if 1
    float3 sample_point = _SSAO_Noise.SampleLevel(point_repeat_s, noise_uv, 0).rgb;
#else
    float3 sample_point = frac(noise + PHI * ii);
#endif
    sample_point.xy = 2.0 * sample_point.xy - 1.0;
    sample_point.xy = mul(ssao_rot, sample_point.xy);

    // Remap to world space.
    sample_point = mul(sample_point, f.tbn);
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

