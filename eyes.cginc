#ifndef __EYES_INC
#define __EYES_INC

#include "globals.cginc"
#include "interpolators.cginc"
#include "math.cginc"
#include "oklab.cginc"
#include "quilez.cginc"

#if defined(_EYE_EFFECT_00)

struct EyeEffectOutput {
  float4 albedo;
  float3 emission;
  float3 normal;
  float3 worldPos;
  float4 fog;
  float2 uv;
  float metallic;
  float roughness;
};

float eye_effect_00_map(float3 p)
{
  float edge = _Gimmick_Eye_Effect_00_Edge_Length;
  float thickness = edge*10;
  return distance_from_round_box(p - float3(0, thickness*.99, 0), float3(edge, thickness, edge), edge * .1);
}

float3 eye_effect_00_nudge_p(float3 p, float3 which)
{
  float noise = _Gimmick_Eye_Effect_00_Noise.SampleLevel(linear_repeat_s, which.xz * _Gimmick_Eye_Effect_00_Period.xz * .005 + _Time[0] * .05, 0);
  return p - float3(0, noise * .01, 0);
}

float eye_effect_00_map_dr(
    float3 p,
    float3 period,
    float3 count,
    out float3 which
    )
{
  which = floor(p / period);
  // Direction to nearest neighboring cell.
  float3 min_d = p - period * which;
  float3 o = sign(min_d);

  float d = 1E9;
  float3 which_tmp = which;
  for (uint xi = 0; xi < 1; xi++)
  for (uint zi = 0; zi < 1; zi++)
  {
    float3 rid = which + float3(xi, 0, zi) * o;
    rid = clamp(rid, ceil(-(count)*0.5), floor((count-1)*0.5));
    float3 r = p - period * rid;
    r = eye_effect_00_nudge_p(r, rid);
    float cur_d = eye_effect_00_map(r);
    which_tmp = cur_d < d ? rid : which_tmp;
    d = min(d, cur_d);
  }

  which = which_tmp;
  return d;
}

float3 eye_effect_00_calc_normal(float3 p)
{
  float3 small_step = float3(1E-5, 0.0, 0.0);
  float3 which;
  float center = eye_effect_00_map_dr(p, _Gimmick_Eye_Effect_00_Period.xyz, _Gimmick_Eye_Effect_00_Count.xyz, which);
  return normalize(float3(
    eye_effect_00_map_dr(p + small_step.xyz, _Gimmick_Eye_Effect_00_Period.xyz, _Gimmick_Eye_Effect_00_Count.xyz, which) - center,
    eye_effect_00_map_dr(p + small_step.zxy, _Gimmick_Eye_Effect_00_Period.xyz, _Gimmick_Eye_Effect_00_Count.xyz, which) - center,
    eye_effect_00_map_dr(p + small_step.yzx, _Gimmick_Eye_Effect_00_Period.xyz, _Gimmick_Eye_Effect_00_Count.xyz, which) - center
  ));
}

// derived from downstairs_02.cginc effect 02
EyeEffectOutput EyeEffect_00(inout v2f i)
{
  float3 camera_position = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
  float3 ro = i.objPos;
  float3 rd = normalize(i.objPos - camera_position);

  float2 warping_speed_vector = normalize(float2(97, 101));
  for (uint ii = 0; ii < _Gimmick_Eye_Effect_00_Domain_Warping_Octaves; ii++)
  {
      float2 noise = _Gimmick_Eye_Effect_00_Noise.SampleLevel(linear_repeat_s, ro.xz * _Gimmick_Eye_Effect_00_Domain_Warping_Scale + _Time[0] * _Gimmick_Eye_Effect_00_Domain_Warping_Speed * warping_speed_vector, 0) * 2 - 1;
      ro.xz += noise * _Gimmick_Eye_Effect_00_Domain_Warping_Strength;
  }

  #define eye_effect_00_MARCH_STEPS 1
  float total_distance_traveled = 0.0;
  const float MINIMUM_HIT_DISTANCE = 1E-4;
  const float MAXIMUM_TRACE_DISTANCE = 1E-1;
  float distance_to_closest;
  float3 which;
  [loop]
  for (uint ii = 0; ii < eye_effect_00_MARCH_STEPS; ii++)
  {
    float3 current_position = ro + total_distance_traveled * rd;
    distance_to_closest = eye_effect_00_map_dr(current_position, _Gimmick_Eye_Effect_00_Period.xyz, _Gimmick_Eye_Effect_00_Count.xyz, which);
    total_distance_traveled += distance_to_closest;
    if (distance_to_closest < MINIMUM_HIT_DISTANCE || 
        total_distance_traveled > MAXIMUM_TRACE_DISTANCE) {
      break;
    }
  }

  bool hit = distance_to_closest < MINIMUM_HIT_DISTANCE;
  float3 final_position = ro + total_distance_traveled * rd;
  float3 normal = hit ? UnityObjectToWorldNormal(eye_effect_00_calc_normal(final_position)) : i.normal;

  float3 color = hit ? 1 : 0;

  EyeEffectOutput o;
  o.albedo = float4(color, hit);
  o.emission = o.albedo;
  o.fog = 0;
  o.normal = normal;
  o.metallic = 0;
  o.roughness = 0;
  // Depth gets all fucked up unless we use i.objPos instead of ro, which is domain warped.
  o.worldPos = mul(unity_ObjectToWorld, float4(i.objPos + rd * total_distance_traveled, 1));
  o.uv = ((which.xz + _Gimmick_Eye_Effect_00_Count.xz * .5) / _Gimmick_Eye_Effect_00_Count.xz) * float2(1, -1);
  return o;
}

#endif  // _EYE_EFFECT_00

#endif  // __EYES_INC


