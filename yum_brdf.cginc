#ifndef __YUM_BRDF_INC
#define __YUM_BRDF_INC

#include "UnityCG.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityLightingCommon.cginc"

#include "filamented.cginc"
#include "math.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

// Define Filament quality levels for proper f90 calculation
#ifndef FILAMENT_QUALITY
#define FILAMENT_QUALITY_LOW 0
#define FILAMENT_QUALITY_NORMAL 1
#define FILAMENT_QUALITY_HIGH 2
#define FILAMENT_QUALITY FILAMENT_QUALITY_NORMAL
#endif

#if defined(_MATERIAL_TYPE_CLOTH)
float D_Charlie(float roughness, float NoH) {
  // Estevez and Kulla 2017, "Production Friendly Microfacet Sheen BRDF"
  float invAlpha = 1.0 / roughness;
  float cos2h = NoH * NoH;
  float sin2h = max(1.0 - cos2h, 0.0078125); // 2^(-14/2), so sin2h^2 > 0 in fp16
  return (2.0 + invAlpha) * pow(sin2h, invAlpha * 0.5) / (2.0 * PI);
}
#endif

// Cloth visibility term from Neubelt and Pettineo
float V_Cloth(float NoV, float NoL) {
  return 1.0 / (4.0 * (NoL + NoV - NoL * NoV));
}

float3 specularLobe(v2f i, f2f f, YumPbr pbr, YumLighting light,
    float3 f0, float3 h, float LoH, float NoH, float NoV, float NoL)
{
#if defined(_MATERIAL_TYPE_CLOTH)
  float D = D_Charlie(pbr.roughness, NoH);
  float V = V_Cloth(NoV, NoL);
  float3 F = _Cloth_Sheen_Color;
  return (D * V) * F;
#else
  // Use Filament's proper f90 calculation for better energy conservation
#if FILAMENT_QUALITY == FILAMENT_QUALITY_LOW
  const float3 F = F_Schlick(f0, LoH); // f90 = 1.0
#else
  float f90 = saturate(dot(f0, (50.0 * 0.33)));
  const float3 F = F_Schlick(f0, f90, LoH);
#endif

#if defined(_ANISOTROPY)
  float anisotropy = _Anisotropy_Strength;
  // Walter et al. 2007, "Microfacet Models for Refraction through Rough Surfaces"
  float3 b = pbr.binormal;
  float3 t = i.tangent.xyz;
  float at = max(pbr.roughness * (1.0 + anisotropy), 0.001);
  float ab = max(pbr.roughness * (1.0 - anisotropy), 0.001);
  float D = D_GGX_Anisotropic(at, ab, NoH, h, t, b);
  float ToV = dot(t, light.view_dir);
  float BoV = dot(b, light.view_dir);
  float ToL = dot(t, light.dir);
  float BoL = dot(b, light.dir);
  float V = V_SmithGGXCorrelated_Anisotropic(at, ab,
      ToV, BoV, ToL, BoL, NoV, NoL);
#else
  float D = D_GGX(pbr.roughness, NoH, h);
  float V = V_SmithGGXCorrelated_Fast(pbr.roughness, NoV, NoL);
#endif
  return (D * V) * F;
#endif
}

float computeDielectricF0(float reflectance) {
  return 0.16 * reflectance * reflectance;
}

float3 computeDiffuseColor(float3 baseColor, float metallic) {
  return baseColor * (1.0 - metallic);
}

float computeSpecularAO(float NoV, float visibility, float roughness) {
  // Lagarde and de Rousiers 2014, "Moving Frostbite to PBR"
  return saturate(pow(NoV + visibility, exp2(-16.0 * roughness - 1.0)) - 1.0 + visibility);
}

float singleBounceAO(float visibility) {
  return visibility; // Simplified version
}

float4 YumBRDF(v2f i, f2f f, const YumLighting light, YumPbr pbr) {
  const float3 h = normalize(light.view_dir + light.dir);
  const float LoH = saturate(dot(light.dir, h));
  const float NoL = light.NoL;
#if defined(_WRAPPED_LIGHTING)
  const float NoL_wrapped_s = light.NoL_wrapped_s;
  const float NoL_wrapped_d = light.NoL_wrapped_d;
#else
  const float NoL_wrapped_s = light.NoL;
  const float NoL_wrapped_d = light.NoL;
#endif
  const float NoV = max(1E-4, dot(pbr.normal, light.view_dir));
  const float NoH = saturate(dot(pbr.normal, h));
  const float VoL = saturate(dot(light.view_dir, light.dir));

#if defined(_CLEARCOAT) && (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS))
  // Clearcoat uses geometric normal (not perturbed by normal maps)
#if defined(_CLEARCOAT_GEOMETRIC_NORMALS)
  const float3 cc_normal = normalize(i.normal);
#else
  const float3 cc_normal = pbr.normal;
#endif
  const float NoH_cc = saturate(dot(cc_normal, h));
  const float NoL_cc = saturate(dot(cc_normal, light.dir));
  const float NoV_cc = max(1E-4, dot(cc_normal, light.view_dir));
  const float cc_mask = _Clearcoat_Mask.SampleLevel(linear_repeat_s, i.uv01.xy, 0);
#endif

#if defined(_MATERIAL_TYPE_CLOTH)
  // Cloth specific BRDF
  float3 direct_cloth;
  {
    // Cloth diffuse BRDF - use Fd_Lambert and multiply by PI to match Unity intensities
    float3 Fd = pbr.albedo * Fd_Lambert() * PI;
    Fd *= light.attenuation;

    #if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
      // Energy conservative wrap diffuse for subsurface scattering
      Fd *= NoL_wrapped_d;
      // Apply subsurface color
      Fd *= saturate(_Cloth_Subsurface_Color + NoL_wrapped_d);
    #endif

    // Cloth specular BRDF - multiply by PI to match Unity intensities
    float3 Fr = specularLobe(i, f, pbr, light, float3(0.04, 0.04, 0.04), h, LoH, NoH, NoV, NoL_wrapped_s) * PI * light.attenuation;

    #if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
      // No need to multiply by NoL when using subsurface scattering
      direct_cloth = (Fd + Fr * NoL_wrapped_s) * light.direct * _Cloth_Direct_Multiplier;
    #else
      direct_cloth = (Fd + Fr) * NoL_wrapped_d * light.direct * _Cloth_Direct_Multiplier;
    #endif
  }
#endif

  float3 direct_standard;
  {
    float remainder = 1.0f;

#if defined(_CLEARCOAT) && (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS))
    float cc_f0 = 0.04f;
    float cc_roughness = _Clearcoat_Roughness * _Clearcoat_Roughness; // Convert perceptual to linear

    float Fcc = F_Schlick(cc_f0, LoH).x * cc_mask * _Clearcoat_Strength;
    float Dcc = D_GGX(cc_roughness, NoH_cc, h);
    float Vcc = V_SmithGGXCorrelated_Fast(cc_roughness, NoV_cc, NoL_cc);

    float3 direct_specular_cc = Dcc * Vcc * Fcc * light.direct * NoL_cc * PI * light.attenuation;
    direct_specular_cc = max(0, direct_specular_cc);

    // Energy conservation: reduce base layer contribution by clearcoat Fresnel
    remainder -= Fcc;
    remainder = max(0, remainder);
#endif

    const float dielectric_f0 = computeDielectricF0(_reflectance);
    const float3 f0 = lerp(dielectric_f0, pbr.albedo, pbr.metallic);
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 E = specularDFG(dfg, f0);
    const float3 energy_compensation = energyCompensation(dfg, f0);

    // Compute proper diffuse color with metallic blending
    float3 diffuseColor = computeDiffuseColor(pbr.albedo, pbr.metallic);

    // Fd_Burley already includes 1/PI, so multiply by PI to match Unity intensities
    float3 Fd = diffuseColor * Fd_Burley(pbr.roughness, NoV, NoL_wrapped_d, LoH) * PI;
    Fd *= light.attenuation * pbr.ao * remainder;

    // Multiply by PI to match Unity intensities (same as Filament's implementation)
    float3 Fr = specularLobe(i, f, pbr, light, f0, h, LoH, NoH, NoV, NoL_wrapped_s) * PI * light.attenuation * remainder;

    // Apply energy compensation to specular term
    float3 color = Fd * NoL_wrapped_d + Fr * energy_compensation * NoL_wrapped_s;
#if defined(_CLEARCOAT) && (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS))
    color += direct_specular_cc;
#endif
    direct_standard = color * light.direct;
  }

#if defined(_MATERIAL_TYPE_CLOTH)
  float3 indirect_cloth;
  {
    // Simple indirect lighting for cloth
    // Add additional corrective term to account for the fact that vrchat map
    // makers suck shit and don't use enough reflection probes.
    float3 Fr = _Cloth_Sheen_Color * light.specular * light.diffuse_luminance;
    float3 Fd = pbr.albedo * light.diffuse * pbr.ao;

    #if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
      // Apply subsurface color to indirect diffuse
      Fd *= _Cloth_Subsurface_Color;
    #endif

    indirect_cloth = (Fr + Fd) * _Cloth_Indirect_Multiplier;
  }
#endif

  float3 indirect_standard = 0;
  {
    float remainder = 1.0f;

#if defined(_CLEARCOAT) && (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS))
    // Clearcoat indirect specular
    float cc_f0 = 0.04f;
    float cc_roughness_perceptual = _Clearcoat_Roughness;

    // Sample environment for clearcoat reflection using geometric normal
#if defined(_CLEARCOAT_GEOMETRIC_NORMALS)
    float3 cc_reflect_dir = reflect(-light.view_dir, normalize(i.normal));
#else
    float3 cc_reflect_dir = reflect(-light.view_dir, cc_normal);
#endif

    UnityGIInput cc_data;
    cc_data.worldPos = f.worldPos;
    cc_data.worldViewDir = light.view_dir;
    cc_data.probeHDR[0] = unity_SpecCube0_HDR;
    cc_data.probeHDR[1] = unity_SpecCube1_HDR;
#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    cc_data.boxMin[0] = unity_SpecCube0_BoxMin;
#endif
#ifdef UNITY_SPECCUBE_BOX_PROJECTION
    cc_data.boxMax[0] = unity_SpecCube0_BoxMax;
    cc_data.probePosition[0] = unity_SpecCube0_ProbePosition;
    cc_data.boxMax[1] = unity_SpecCube1_BoxMax;
    cc_data.boxMin[1] = unity_SpecCube1_BoxMin;
    cc_data.probePosition[1] = unity_SpecCube1_ProbePosition;
#endif

    float3 cc_env_refl = UnityGI_prefilteredRadiance(cc_data, cc_roughness_perceptual, cc_reflect_dir);
#if defined(_FALLBACK_CUBEMAP)
  if (!SceneHasReflections() || _Fallback_Cubemap_Force) {
    // Set up data for fallback sampling similar to Unity's system

    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
      cc_reflect_dir = BoxProjectedCubemapDirection(cc_reflect_dir, f.worldPos, /*probe_position=*/0, /*box_min=*/-1, /*box_max=*/1);
    #endif

    half mip = cc_roughness_perceptual * UNITY_SPECCUBE_LOD_STEPS;
    float4 envSample = UNITY_SAMPLE_TEXCUBE_LOD(_Fallback_Cubemap, cc_reflect_dir, mip);
    cc_env_refl = DecodeHDR(envSample, _Fallback_Cubemap_HDR) * _Fallback_Cubemap_Brightness * light.diffuse_luminance;
  }
#endif

#if defined(_BRIGHTNESS_CONTROL)
    cc_env_refl *= _Brightness_Multiplier;
#endif

    // Clearcoat Fresnel for view angle
    float Fcc = F_Schlick(cc_f0, NoV_cc).x * cc_mask * _Clearcoat_Strength;
    float3 indirect_specular_cc = Fcc * cc_env_refl;

    // Energy conservation
    indirect_standard += indirect_specular_cc;
    remainder = saturate(remainder - Fcc);
#endif

    const float dielectric_f0 = computeDielectricF0(_reflectance);
    const float3 f0 = lerp(dielectric_f0, pbr.albedo, pbr.metallic);
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 E = specularDFG(dfg, f0);

    const float3 energy_compensation = energyCompensation(dfg, f0);
    float diffuseAO = pbr.ao;
    float3 diffuseColor = computeDiffuseColor(pbr.albedo, pbr.metallic);
    float3 Fd = diffuseColor * light.diffuse * (1.0 - E) * pbr.ao * remainder;

    float3 Fr = E * light.specular * remainder;

    indirect_standard += Fr + Fd;
  }

#if defined(_MATERIAL_TYPE_CLOTH)
  float cloth_mask = _Cloth_Mask.Sample(linear_repeat_s, i.uv01.xy);
  float3 direct = lerp(direct_standard, direct_cloth, cloth_mask);
  float3 indirect = lerp(indirect_standard, indirect_cloth, cloth_mask);
#else
  float3 direct = direct_standard;
  float3 indirect = indirect_standard;
#endif

  float4 lit = float4(direct + indirect, pbr.albedo.a);

  float3 lv_specular = 0;
  [branch]
  if (_UdonLightVolumeEnabled) {
    float3 lv_specular = LightVolumeSpecular(pbr.albedo, pbr.smoothness, pbr.metallic,
        pbr.normal, light.view_dir, light.L00, light.L01r, light.L01g, light.L01b);
    lit.rgb += lv_specular;

#if defined(_CLEARCOAT) && (defined(FORWARD_BASE_PASS) || defined(FORWARD_ADD_PASS))
    float Fcc = F_Schlick(0.04f, NoV_cc) * cc_mask * _Clearcoat_Strength;
    lit.rgb += lv_specular * Fcc;
#endif
  }

  return lit;
}

#endif  // __YUM_BRDF_INC
