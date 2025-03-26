#ifndef __SHATTER_WAVE_INC
#define __SHATTER_WAVE_INC

#include "globals.cginc"
#include "math.cginc"

#if defined(_SHATTER_WAVE)

void shatterWaveVert(inout float3 objPos, float3 objNormal, float3 objTangent) {
  // Keyframes:
  // 1. At rest
  // 2. At peak, rotated PI radians along objTangent axis
  // 3. At rest, rotated TAU radians along objTangent axis
  float a = _Shatter_Wave_Amplitude;
  float l = _Shatter_Wave_Wavelength;
  float v = _Shatter_Wave_Speed;
  float T = _Shatter_Wave_Period;
  float3 wave_axis = normalize(_Shatter_Wave_Direction);

  // Imagine a wave propagating along `wave_axis`.
  float wave_t = fmod(_Time[0] * _Shatter_Wave_Speed, _Shatter_Wave_Period) - _Shatter_Wave_Period * 0.5;
  float wave_center = wave_t;
  float3 objPos_proj = dot(objPos, wave_axis) * normalize(wave_axis);
  float offset = exp(-length(objPos_proj - wave_center * wave_axis) * _Shatter_Wave_Power) * _Shatter_Wave_Amplitude;
  objPos += objNormal * offset;

  float phase = (wave_t / _Shatter_Wave_Period) + 0.5;
}

void shatterWaveFrag(inout float3 normal, float3 objPos) {
  normal = normalize(cross(ddy(objPos), ddx(objPos)));
}

#endif  // _SHATTER_WAVE

#endif  // __SHATTER_WAVE_INC
