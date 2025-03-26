#ifndef __SHATTER_WAVE_INC
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
#define __SHATTER_WAVE_INC

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

  float4 wave_t = fmod(_Time[0] * _Shatter_Wave_Speed + _Shatter_Wave_Time_Offset * _Shatter_Wave_Period, _Shatter_Wave_Period) - _Shatter_Wave_Period * 0.5;

  float4 wave_center = wave_t;
  float4 offset;
  for (uint i = 0; i < 4; i++) {
    offset[i] = exp(-length(objPos_proj[i] - wave_center[i] * wave_axes[i]) * _Shatter_Wave_Power[i]) * _Shatter_Wave_Amplitude[i];
    objPos += objNormal * offset[i];
  }
}

void shatterWaveFrag(inout float3 normal, float3 objPos) {
  normal = normalize(cross(ddy(objPos), ddx(objPos)));
}

#endif  // _SHATTER_WAVE

#endif  // __SHATTER_WAVE_INC
