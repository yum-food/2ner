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
  
  float4 projDots = mul(wave_axes, objPos);
  // Equivalent code:
  // float4 projDots = float4(
  //   dot(objPos, wave_axis0),
  //   dot(objPos, wave_axis1),
  //   dot(objPos, wave_axis2),
  //   dot(objPos, wave_axis3)
  // );
  
  float4x3 objPos_proj = float4x3(
    projDots.x * wave_axis0,
    projDots.y * wave_axis1,
    projDots.z * wave_axis2,
    projDots.w * wave_axis3
  );

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

  float4 distance_signed = float4(
    dot(objPos_proj[0] - wave_center.x * wave_axes[0], wave_axes[0]),
    dot(objPos_proj[1] - wave_center.y * wave_axes[1], wave_axes[1]),
    dot(objPos_proj[2] - wave_center.z * wave_axes[2], wave_axes[2]),
    dot(objPos_proj[3] - wave_center.w * wave_axes[3], wave_axes[3])
  );

#if defined(_SHATTER_WAVE_ROTATION)
  float4 thetas = clamp(distance_signed * _Shatter_Wave_Rotation_Strength, -1, 1) * TAU;
  [unroll]
  for (uint i = 0; i < 4; i++) {
    objPos = rotate_vector(objPos, get_quaternion(wave_axes[i], thetas[i]));
  }
#endif

  float4 offset = exp(-abs(distance_signed) * _Shatter_Wave_Power) * _Shatter_Wave_Amplitude;
  objPos += objNormal * (offset.x + offset.y + offset.z + offset.w);
}

void shatterWaveFrag(inout float3 normal, float3 objPos) {
  normal = normalize(cross(ddy(objPos), ddx(objPos)));
}

#endif  // _SHATTER_WAVE

#endif  // __SHATTER_WAVE_INC
