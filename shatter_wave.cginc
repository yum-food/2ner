#ifndef __SHATTER_WAVE_INC
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
#define __SHATTER_WAVE_INC

#include "audiolink.cginc"
#include "globals.cginc"
#include "math.cginc"

#if defined(_SHATTER_WAVE)

void shatterWaveVert(inout float3 objPos, float3 objNormal, float3 objTangent) {
  float3 wave_axis0 = normalize(_Shatter_Wave_Direction0);
  float3 wave_axis1 = normalize(_Shatter_Wave_Direction1);
  float3 wave_axis2 = normalize(_Shatter_Wave_Direction2);
  float3 wave_axis3 = normalize(_Shatter_Wave_Direction3);
  float4x3 wave_axes = float4x3(wave_axis0, wave_axis1, wave_axis2, wave_axis3);
  float4x3 objPos_proj;
  objPos_proj[0] = dot(objPos, wave_axis0) * normalize(wave_axis0);
  objPos_proj[1] = dot(objPos, wave_axis1) * normalize(wave_axis1);
  objPos_proj[2] = dot(objPos, wave_axis2) * normalize(wave_axis2);
  objPos_proj[3] = dot(objPos, wave_axis3) * normalize(wave_axis3);

#if defined(_SHATTER_WAVE_AUDIOLINK)
  float4 wave_t;
  [branch]
  if (AudioLinkIsAvailable()) {
    const uint chrono_time_scale_i = 1000 * 1000;
    const float chrono_time_scale_f = 1000 * 1000;
    float4x4 chrono_t;
    float4x4 weights = float4x4(
      // Weights are per band. .x is wave0, .y is wave1, etc.
      _Shatter_Wave_Chronotensity_Weights0,
      _Shatter_Wave_Chronotensity_Weights1,
      _Shatter_Wave_Chronotensity_Weights2,
      _Shatter_Wave_Chronotensity_Weights3);
    [unroll]
    for (uint band = 0; band < 4; ++band)
    {
      uint chrono_raw = AudioLinkDecodeDataAsUInt(ALPASS_CHRONOTENSITY + uint2(2, band));
      float chrono_normalized = chrono_raw / chrono_time_scale_f;
      chrono_t[band] = weights[band] * chrono_normalized;
    }
    float4 chrono_t4;
    [unroll]
    for (uint wave = 0; wave < 4; ++wave)
    {
      chrono_t4[wave] = chrono_t[0][wave];
      chrono_t4[wave] += chrono_t[1][wave];
      chrono_t4[wave] += chrono_t[2][wave];
      chrono_t4[wave] += chrono_t[3][wave];
    }
    wave_t = chrono_t4 * _Shatter_Wave_Chronotensity_Time_Factor;
    wave_t = fmod(
        wave_t +
        _Shatter_Wave_Time_Offset * _Shatter_Wave_Period -
        _Time[0] * _Shatter_Wave_Speed * .3,
      _Shatter_Wave_Period) - _Shatter_Wave_Period * 0.5;
  }
#else
  float4 wave_t = _Time[0] * _Shatter_Wave_Speed;
  wave_t = fmod(wave_t + _Shatter_Wave_Time_Offset * _Shatter_Wave_Period, _Shatter_Wave_Period) - _Shatter_Wave_Period * 0.5;
#endif

  float4 wave_center = wave_t;

  // TODO calculate signed distance from wave center
  float4 distance_signed;
  for (uint i = 0; i < 4; i++) {
    float3 dist_to_center = objPos_proj[i] - wave_center[i] * wave_axes[i];
    distance_signed[i] = dot(dist_to_center, wave_axes[i]);
  }

#if defined(_SHATTER_WAVE_ROTATION)
  float4 thetas = clamp(distance_signed * _Shatter_Wave_Rotation_Strength, -1, 1) * TAU;
  for (uint i = 0; i < 4; i++) {
    objPos = rotate_vector(objPos, get_quaternion(wave_axes[i], thetas[i]));
  }
#endif

  float4 offset = exp(-abs(distance_signed) * _Shatter_Wave_Power) * _Shatter_Wave_Amplitude;
  objPos += objNormal * offset[0];
  objPos += objNormal * offset[1];
  objPos += objNormal * offset[2];
  objPos += objNormal * offset[3];
}

void shatterWaveFrag(inout float3 normal, float3 objPos) {
  normal = normalize(cross(ddy(objPos), ddx(objPos)));
}

#endif  // _SHATTER_WAVE

#endif  // __SHATTER_WAVE_INC
