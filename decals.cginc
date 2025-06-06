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
    bool sdf_invert;
    float sdf_threshold;
    Texture2D mask;
    Texture2D normalTex;
    float normal_scale;
    Texture2D metallicGlossMap;
    float metallic_value;
    float smoothness_value;
    Texture2D domain_warping_noise;
    float domain_warping_octaves;
    float domain_warping_strength;
    float domain_warping_scale;
    float domain_warping_speed;
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
    params.sdf_invert = prefix##SDF_Invert; \
    params.sdf_threshold = prefix##SDF_Threshold; \
    params.mask = prefix##Mask; \
    params.normalTex = prefix##Normal; \
    params.normal_scale = prefix##Normal_Scale; \
    params.metallicGlossMap = prefix##MetallicGlossMap; \
    params.metallic_value = prefix##Metallic; \
    params.smoothness_value = prefix##Smoothness; \
    params.domain_warping_noise = prefix##Domain_Warping_Noise; \
    params.domain_warping_octaves = prefix##Domain_Warping_Octaves; \
    params.domain_warping_strength = prefix##Domain_Warping_Strength; \
    params.domain_warping_scale = prefix##Domain_Warping_Scale; \
    params.domain_warping_speed = prefix##Domain_Warping_Speed; \
    params.cmyk_warping_planes_noise = prefix##CMYK_Warping_Planes_Noise; \
    params.cmyk_warping_planes_strength = prefix##CMYK_Warping_Planes_Strength; \
    params.cmyk_warping_planes_scale = prefix##CMYK_Warping_Planes_Scale; \
    params.cmyk_warping_planes_speed = prefix##CMYK_Warping_Planes_Speed;

float2 applyDomainWarping(DecalParams params, float2 uv) {
    float2 warped_uv = uv;
    float amplitude = 1.0;
    float frequency = params.domain_warping_scale;
    float2 total_offset = float2(0.0, 0.0);

    float2 time_vec = float2(-0.83, 0.97) * _Time.y * params.domain_warping_speed;

    [loop]
    for (uint ii = 0; ii < params.domain_warping_octaves; ii++) {
        float2 noise_uv = warped_uv * frequency + time_vec * frequency;
        float2 noise_sample = params.domain_warping_noise.SampleLevel(trilinear_repeat_s, noise_uv, 0);
        float2 noise_offset = (noise_sample.xy * 2.0 - 1.0);
        total_offset += noise_offset * amplitude;
        frequency *= 2.0;
        amplitude *= 0.5;
    }

    warped_uv = uv + total_offset * params.domain_warping_strength;
    return warped_uv;
}

float4 getDecalColor(DecalParams params, float2 uv) {
    float4 sdf_sample = params.mainTex.SampleLevel(linear_repeat_s, uv, 0);
    float sd = sdf_sample.r;
    sd = params.sdf_invert ? 1 - sd : sd;
    // The fwidth+smoothstep anti-aliases the glyph outline. See
    // "Noise is Beautiful" by Gustavson around page 34 for an
    // explanation of this trick.
#if 1
    float step_wd = fwidth(sd) * 0.5;
    sd = smoothstep(params.sdf_threshold - step_wd, params.sdf_threshold + step_wd, sd);
#else
    sd = step(params.sdf_threshold, sd);
#endif
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

    float4 plane_alphas = float4(
        decal_color0.a,
        decal_color1.a,
        decal_color2.a,
        decal_color3.a
    );

    float4 final_cmyk = plane_alphas;
    float3 final_rgb = saturate(cmykToRgb(final_cmyk));
    float eps = 1E-5;
    final_rgb = lerp(
        final_rgb,
        params.color.rgb,
        all(plane_alphas>eps)
    );

    return float4(final_rgb, saturate(decal_color0.a + decal_color1.a + decal_color2.a + decal_color3.a));
}

#define APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, params)          \
    float2x2 decal_rot = float2x2(                                                                  \
        cos(params.angle * TAU), -sin(params.angle * TAU),                                          \
        sin(params.angle * TAU), cos(params.angle * TAU)                                            \
    );                                                                                              \
                                                                                                    \
    float2 raw_decal_uv = get_uv_by_channel(i, params.uv_channel);                                  \
    float2 decal_uv = raw_decal_uv;                                                                 \
    decal_uv = ((decal_uv - 0.5) - params.mainTex_ST.zw) * params.mainTex_ST.xy + 0.5;              \
    decal_uv = mul(decal_rot, decal_uv - 0.5) + 0.5;                                                \
    decal_uv = (params.tiling_mode == DECAL_TILING_MODE_CLAMP ? saturate(decal_uv) : decal_uv);

#define APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, params) \
    decal_uv = applyDomainWarping(params, decal_uv);

#define APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, params) {}

#define APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, params)  \
    float4 decal_albedo = getCmykWarpingPlanesColor(params, decal_uv);

#define APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, params) \
    float4 decal_albedo = getDecalColor(params, decal_uv);

#define APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, params)          \
    float4 decal_albedo;                                                                            \
    {                                                                                               \
        decal_albedo = params.mainTex.Sample(trilinear_repeat_s, decal_uv);                            \
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
            params.normalTex.Sample(trilinear_repeat_s, decal_uv),                                     \
            params.normal_scale * decal_albedo.a * params.opacity);                                 \
    normal_tangent = blendNormalsHill12(normal_tangent, decal_normal);
    //normal_tangent = lerp(normal_tangent, decal_normal, decal_albedo.a * params.opacity);

#define APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, params) {}

#define APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, params)   \
    float4 metallic_gloss = params.metallicGlossMap.Sample(trilinear_repeat_s, decal_uv);              \
    metallic = lerp(metallic, metallic_gloss.r * params.metallic_value, decal_albedo.a);            \
    smoothness = lerp(smoothness, metallic_gloss.a * params.smoothness_value, decal_albedo.a);

#define APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, params) {}

void applyDecals(in v2f i, inout float4 albedo, inout float3 normal_tangent, inout float metallic, inout float smoothness) {
    DecalParams decal;
    #if defined(_DECAL0)
    {
        INIT_DECAL_PARAMS(decal, _Decal0_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL0_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
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
        #if defined(_DECAL1_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
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
        #if defined(_DECAL2_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
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
        #if defined(_DECAL3_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
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
    #if defined(_DECAL4)
    {
        INIT_DECAL_PARAMS(decal, _Decal4_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL4_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL4_SDF) && defined(_DECAL4_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL4_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL4_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL4_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL4_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL4_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL4_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL4
    #if defined(_DECAL5)
    {
        INIT_DECAL_PARAMS(decal, _Decal5_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL5_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL5_SDF) && defined(_DECAL5_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL5_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL5_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL5_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL5_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL5_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL5_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL5
    #if defined(_DECAL6)
    {
        INIT_DECAL_PARAMS(decal, _Decal6_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL6_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL6_SDF) && defined(_DECAL6_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL6_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL6_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL6_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL6_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL6_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL6_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL6
    #if defined(_DECAL7)
    {
        INIT_DECAL_PARAMS(decal, _Decal7_);
        APPLY_DECAL_SEC00_GENERIC(i, albedo, normal_tangent, metallic, smoothness, decal);
        #if defined(_DECAL7_DOMAIN_WARPING)
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC00B_DOMAIN_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL7_SDF) && defined(_DECAL7_CMYK_WARPING_PLANES)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #elif defined(_DECAL7_SDF)
        APPLY_DECAL_SEC01_SDF_ON_WARPING_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC01_SDF_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL7_TILING_MODE)
        APPLY_DECAL_SEC02_CLAMP_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC02_CLAMP_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL7_MASK)
        APPLY_DECAL_SEC03_MASK_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC03_MASK_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL7_REPLACE_ALPHA)
        APPLY_DECAL_SEC04_BLEND_MODE_REPLACE(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC04_BLEND_MODE_ALPHA_BLEND(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL7_NORMAL)
        APPLY_DECAL_SEC05_NORMAL_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC05_NORMAL_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
        #if defined(_DECAL7_REFLECTIONS)
        APPLY_DECAL_SEC06_REFLECTIONS_ON(i, albedo, normal_tangent, metallic, smoothness, decal);
        #else
        APPLY_DECAL_SEC06_REFLECTIONS_OFF(i, albedo, normal_tangent, metallic, smoothness, decal);
        #endif
    }
    #endif  // _DECAL7
}

#endif  // __DECALS
