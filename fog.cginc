#ifndef __FOG_INC
#define __FOG_INC

#include "cnlohr.cginc"
#include "interpolators.cginc"
#include "globals.cginc"

#if defined(_RAYMARCHED_FOG)

struct FogParams {
    float steps;
    float density;
    texture2D dithering_noise;
    texture3D density_noise;
    float4 density_noise_scale;
};

struct FogResult {
    float4 color;
};

float getRayLengthWorld()
{
  float2 screen_uv;
  float perspective_factor;
  {
    float3 full_vec_eye_to_geometry = i.worldPos - _WorldSpaceCameraPos;
    float3 world_dir = normalize(i.worldPos - _WorldSpaceCameraPos);
    float perspective_divide = 1.0 / i.pos.w;
    perspective_factor = length(full_vec_eye_to_geometry * perspective_divide);
    screen_uv = i.screenPos.xy * perspective_divide;
  }
  float eye_depth_world =
    GetLinearZFromZDepth_WorksWithMirrors(
        SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screen_uv),
        screen_uv) * perspective_factor;
}

FogResult raymarched_fog(v2f i, FogParams params)
{
    float3 ro = _WorldSpaceCameraPos;
    float3 rd = normalize(i.worldPos - ray_pos);


}

#endif  // _RAYMARCHED_FOG
#endif  // __FOG_INC
