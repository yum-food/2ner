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

float3 specularLobe(YumPbr pbr, float3 f0,
    float3 h, float LoH, float NoH, float NoV, float NoL)
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
  // Normal distribution function
  float D = D_GGX(pbr.roughness, NoH, h);
  // Geometric shadowing
  float V = V_SmithGGXCorrelated_Fast(pbr.roughness, NoV, NoL);
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

float4 YumBRDF(v2f i, const YumLighting light, YumPbr pbr) {
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

#if defined(_MATERIAL_TYPE_CLOTH)
  // Cloth specific BRDF
  float3 direct_cloth;
  {
    // Cloth diffuse BRDF - use Fd_Lambert and multiply by PI to match Unity intensities
    float3 Fd = pbr.albedo * Fd_Lambert() * PI;
    Fd *= light.attenuation;

    #if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
      // Energy conservative wrap diffuse for subsurface scattering
      float wrap_diffuse = saturate((NoL + 0.5) / 2.25);
      Fd *= wrap_diffuse;
      // Apply subsurface color
      Fd *= saturate(_Cloth_Subsurface_Color + NoL);
    #endif

    // Cloth specular BRDF - multiply by PI to match Unity intensities
    float3 Fr = specularLobe(pbr, float3(0.04, 0.04, 0.04), h, LoH, NoH, NoV, NoL_wrapped_s) * PI * light.attenuation;

    #if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
      // No need to multiply by NoL when using subsurface scattering
      direct_cloth = (Fd + Fr * NoL) * light.direct * _Cloth_Direct_Multiplier;
    #else
      direct_cloth = (Fd + Fr) * NoL * light.direct * _Cloth_Direct_Multiplier;
    #endif
  }
#endif

  float3 direct_standard;
  {
    const float dielectric_f0 = computeDielectricF0(_reflectance);
    const float3 f0 = lerp(dielectric_f0, pbr.albedo, pbr.metallic);
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 E = specularDFG(dfg, f0);
    const float3 energy_compensation = energyCompensation(dfg, f0);

    // Compute proper diffuse color with metallic blending
    float3 diffuseColor = computeDiffuseColor(pbr.albedo, pbr.metallic);
    
    // Fd_Burley already includes 1/PI, so multiply by PI to match Unity intensities
    float3 Fd = diffuseColor * Fd_Burley(pbr.roughness, NoV, NoL, LoH) * PI;
    Fd *= light.attenuation * pbr.ao;
    
    // Multiply by PI to match Unity intensities (same as Filament's implementation)
    float3 Fr = specularLobe(pbr, f0, h, LoH, NoH, NoV, NoL_wrapped_s) * PI * light.attenuation;

    // Apply energy compensation to specular term
    float3 color = Fd * NoL_wrapped_d + Fr * energy_compensation * NoL_wrapped_s;
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

  float3 indirect_standard;
  {
    const float dielectric_f0 = computeDielectricF0(_reflectance);
    const float3 f0 = lerp(dielectric_f0, pbr.albedo, pbr.metallic);
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 E = specularDFG(dfg, f0);
    const float3 energy_compensation = energyCompensation(dfg, f0);

    // Compute specular ambient occlusion
    float diffuseAO = pbr.ao;
    float specularAO = computeSpecularAO(NoV, diffuseAO * light.occlusion, pbr.roughness);
    float3 specularSingleBounceAO = singleBounceAO(specularAO) * energy_compensation;

    // Use proper diffuse color calculation
    float3 diffuseColor = computeDiffuseColor(pbr.albedo, pbr.metallic);
    float3 Fd = diffuseColor * light.diffuse * (1.0 - E) * pbr.ao;
    
    float3 Fr = E * light.specular * specularSingleBounceAO;

    indirect_standard = Fr + Fd;
  }

#if defined(_MATERIAL_TYPE_CLOTH)
  float cloth_mask = _Cloth_Mask.Sample(linear_repeat_s, i.uv01.xy);
  float3 direct = lerp(direct_standard, direct_cloth, cloth_mask);
  float3 indirect = lerp(indirect_standard, indirect_cloth, cloth_mask);
#else
  float3 direct = direct_standard;
  float3 indirect = indirect_standard;
#endif

  return float4(direct + indirect, pbr.albedo.a);
}

#endif  // __YUM_BRDF_INC
