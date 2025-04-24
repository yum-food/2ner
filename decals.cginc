#ifndef __DECALS
#define __DECALS

#include "features.cginc"
#include "globals.cginc"
#include "math.cginc"
#include "texture_utils.cginc"

// Struct to hold all decal parameters
struct DecalParams {
    float4 color;
    float opacity;
    float angle;
    float uv_channel;
    float4 mainTex_ST;
    int tiling_mode;
    int alpha_blend_mode;
    Texture2D mainTex;
    bool sdf_enabled;
    bool sdf_invert;
    float sdf_threshold;
    bool mask_enabled;
    Texture2D mask;
    bool normal_enabled;
    Texture2D normalTex;
    float normal_scale;
    bool reflections_enabled;
    Texture2D metallicGlossMap;
    float metallic_value;
    float smoothness_value;
    Texture2D cmyk_warping_planes_noise;
    float cmyk_warping_planes_strength;
    float cmyk_warping_planes_scale;
    float cmyk_warping_planes_speed;
};

// Macro to initialize decal parameters
#define INIT_DECAL_PARAMS(params, prefix) \
    params.color = prefix##Color; \
    params.opacity = prefix##Opacity; \
    params.angle = prefix##Angle; \
    params.uv_channel = prefix##UV_Channel; \
    params.mainTex_ST = prefix##MainTex_ST; \
    params.tiling_mode = prefix##Tiling_Mode; \
    params.alpha_blend_mode = prefix##Alpha_Blend_Mode; \
    params.mainTex = prefix##MainTex; \
    params.sdf_enabled = prefix##SDF_Enabled; \
    params.sdf_invert = prefix##SDF_Invert; \
    params.sdf_threshold = prefix##SDF_Threshold; \
    params.mask_enabled = prefix##Mask_Enabled; \
    params.mask = prefix##Mask; \
    params.normal_enabled = prefix##Normal_Enabled; \
    params.normalTex = prefix##Normal; \
    params.normal_scale = prefix##Normal_Scale; \
    params.reflections_enabled = prefix##Reflections_Enabled; \
    params.metallicGlossMap = prefix##MetallicGlossMap; \
    params.metallic_value = prefix##Metallic; \
    params.smoothness_value = prefix##Smoothness; \
    params.cmyk_warping_planes_noise = prefix##CMYK_Warping_Planes_Noise; \
    params.cmyk_warping_planes_strength = prefix##CMYK_Warping_Planes_Strength; \
    params.cmyk_warping_planes_scale = prefix##CMYK_Warping_Planes_Scale; \
    params.cmyk_warping_planes_speed = prefix##CMYK_Warping_Planes_Speed;

float4 getDecalColor(DecalParams params, float2 uv) {
    float4 sdf_sample = params.mainTex.SampleLevel(linear_repeat_s, uv, 0);
    float sd = sdf_sample.r;
    sd = params.sdf_invert ? 1 - sd : sd;
    sd = (sd > params.sdf_threshold ? 1 : 0);
    return params.color * sd;
}

float4 getCmykWarpingPlanesColor(DecalParams params, float2 uv) {
    float4 noise = params.cmyk_warping_planes_noise.SampleLevel(linear_repeat_s, uv, 0);

    float amplitude = params.cmyk_warping_planes_strength;
    float frequency = params.cmyk_warping_planes_scale;

    // Process pairs of planes in each loop.
    float4 warped_uv[2] = {float4(uv, uv), float4(uv, uv)};
    [loop]
    for (uint jj = 0; jj < 2; jj++) {
        float2 speed_direction = float2(
          jj % 2 == 0 ?  1 : -1,
          jj / 2 == 0 ?  1 : -1);
        float2 time_offset = speed_direction * _Time.y * params.cmyk_warping_planes_speed;
        {
            float2 noise_uv = warped_uv[jj] * frequency + time_offset;
            float4 noise = params.cmyk_warping_planes_noise.SampleLevel(trilinear_repeat_s, noise_uv, 0);
            noise = (noise * 2.0 - 1.0);
            warped_uv[jj].xy += noise.xy * amplitude;
            warped_uv[jj].zw += noise.zw * amplitude;
        }
    }

    float4 decal_color0 = getDecalColor(params, warped_uv[0].xy);
    float4 decal_color1 = getDecalColor(params, warped_uv[0].zw);
    float4 decal_color2 = getDecalColor(params, warped_uv[1].xy);
    float4 decal_color3 = getDecalColor(params, warped_uv[1].zw);

    float4 final_cmyk = float4(
        rgbToCmyk_C(decal_color0.rgb),
        rgbToCmyk_M(decal_color1.rgb),
        rgbToCmyk_Y(decal_color2.rgb),
        rgbToCmyk_K(decal_color3.rgb));

    float3 final_rgb = saturate(cmykToRgb(final_cmyk));
    return float4(final_rgb, decal_color0.a + decal_color1.a + decal_color2.a + decal_color3.a);
}

#define APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, params)          \
    float2x2 decal_rot = float2x2(                                                                  \
        cos(params.angle * TAU), -sin(params.angle * TAU),                                          \
        sin(params.angle * TAU), cos(params.angle * TAU)                                            \
    );                                                                                              \
                                                                                                    \
    float2 raw_decal_uv = get_uv_by_channel(i, params.uv_channel);                                  \
    float2 decal_uv = raw_decal_uv;                                                                 \
    decal_uv = decal_uv * params.mainTex_ST.xy + params.mainTex_ST.zw;                              \
    decal_uv = mul(decal_rot, decal_uv - 0.5) + 0.5;                                                \
    decal_uv = (params.tiling_mode == DECAL_TILING_MODE_CLAMP ? saturate(decal_uv) : decal_uv);

#define APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, params)  \
    float4 decal_albedo = getCmykWarpingPlanesColor(params, decal_uv);

#define APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, params) \
    float4 decal_albedo = getDecalColor(params, decal_uv);

#define APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, params)          \
    float4 decal_albedo;                                                                            \
    {                                                                                               \
        decal_albedo = params.mainTex.Sample(linear_repeat_s, decal_uv);                            \
        decal_albedo *= params.color;                                                               \
    }

#define APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, params)         \
    {                                                                                               \
        float eps = 1e-4;                                                                           \
        float2 uv_clamped = step(eps, decal_uv) * step(decal_uv, 1 - eps);                          \
        decal_albedo.a *= uv_clamped.x * uv_clamped.y;                                              \
    }

#define APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, params) {}

#define APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, params)          \
    float decal_mask = params.mask.SampleLevel(linear_repeat_s, raw_decal_uv, 0);                           \
    decal_albedo.a *= decal_mask;

#define APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, params)         \
    float decal_mask = 1;

#define APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, params)   \
    decal_albedo.a = lerp(0, decal_albedo.a, params.opacity);                                       \
    albedo = alphaBlend(albedo, decal_albedo);

#define APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, params)       \
    albedo = lerp(albedo, decal_albedo, decal_mask * params.opacity);

#define APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, params)        \
    float3 decal_normal = UnpackScaleNormal(                                                        \
            params.normalTex.Sample(linear_repeat_s, decal_uv),                                     \
            params.normal_scale * decal_albedo.a * params.opacity);                                 \
    normal_tangent = blendNormalsHill12(normal_tangent, decal_normal);
    //normal_tangent = lerp(normal_tangent, decal_normal, decal_albedo.a * params.opacity);

#define APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, params) {}

#define APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, params)   \
    float4 metallic_gloss = params.metallicGlossMap.Sample(linear_repeat_s, decal_uv);              \
    metallic = lerp(metallic, metallic_gloss.r * params.metallic_value, decal_albedo.a);            \
    smoothness = lerp(smoothness, metallic_gloss.a * params.smoothness_value, decal_albedo.a);

#define APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, params) {}

void applyDecals(in v2f i, inout float4 albedo, inout float3 normal_tangent, inout float metallic, inout float smoothness) {
    DecalParams decal;
    #if defined(_DECAL0)
    {
        INIT_DECAL_PARAMS(decal, _Decal0_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL0_SDF) && defined(_DECAL0_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL0_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL0_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL0_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL0_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL0_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL0_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL0
    #if defined(_DECAL1)
    {
        INIT_DECAL_PARAMS(decal, _Decal1_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL1_SDF) && defined(_DECAL1_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL1_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL1_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL1_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL1_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL1_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL1_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL1
    #if defined(_DECAL2)
    {
        INIT_DECAL_PARAMS(decal, _Decal2_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL2_SDF) && defined(_DECAL2_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL2_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL2_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL2_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL2_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL2_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL2_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL2
    #if defined(_DECAL3)
    {
        INIT_DECAL_PARAMS(decal, _Decal3_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL3_SDF) && defined(_DECAL3_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL3_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL3_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL3_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL3_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL3_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL3_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL3
}

#endif  // __DECALS
