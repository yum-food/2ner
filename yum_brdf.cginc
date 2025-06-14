#ifndef __YUM_BRDF_INC
#define __YUM_BRDF_INC

#include "UnityCG.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityLightingCommon.cginc"

#include "filamented.cginc"
#include "math.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

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

float3 specularLobe(YumPbr pbr, float f0,
    float3 h, float LoH, float NoH, float NoV, float NoL)
{
#if defined(_MATERIAL_TYPE_CLOTH)
  float D = D_Charlie(pbr.roughness, NoH);
  float V = V_Cloth(NoV, NoL);
  float3 F = _Cloth_Sheen_Color;
  return (D * V) * F;
#else
  // Fresnel
  const float3 F = F_Schlick(f0, LoH);
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
  const float f90 = 0.5 + 2 * pbr.roughness * LoH * LoH;

#if defined(_MATERIAL_TYPE_CLOTH)
  // Cloth specific BRDF
  float3 direct_cloth;
  {
    // Cloth diffuse BRDF - apply proper energy conservation
    // Use a proper diffuse BRDF term instead of raw albedo
    float3 Fd = pbr.albedo / PI;
    Fd *= light.attenuation;

    #if defined(_MATERIAL_TYPE_CLOTH_SUBSURFACE)
      // Energy conservative wrap diffuse for subsurface scattering
      float wrap_diffuse = saturate((NoL + 0.5) / 2.25);
      Fd *= wrap_diffuse;
      // Apply subsurface color
      Fd *= saturate(_Cloth_Subsurface_Color + NoL);
    #endif

    // Cloth specular BRDF
    float3 Fr = specularLobe(pbr, 0.04, h, LoH, NoH, NoV, NoL_wrapped_s);

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
    // Typical values for different materials listed here:
    //   https://google.github.io/filament/Filament.html#toc4.8.3.2
    // TODO expose an enum for different types of materials
    const float reflectance = computeDielectricF0(_reflectance);
    // f0 = amount of light reflected back when viewing surface at a right angle
    // Change to match the design document
    const float3 f0 = lerp(reflectance, pbr.albedo, pbr.metallic);
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 E = specularDFG(dfg, f0);
    const float3 energy_compensation = energyCompensation(dfg, f0);

    float3 Fd = pbr.albedo / PI;
    Fd *= (1.0 - pbr.metallic) * light.attenuation * pbr.ao;
    float3 Fr = specularLobe(pbr, f0, h, LoH, NoH, NoV, NoL_wrapped_s) * pbr.ao * PI;

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
    const float reflectance = computeDielectricF0(_reflectance);
    const float3 f0 = reflectance * (1.0 - pbr.metallic) + pbr.albedo * pbr.metallic;
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 E = specularDFG(dfg, f0);
    const float3 energy_compensation = energyCompensation(dfg, f0);

    // Compute specular ambient occlusion
    float diffuseAO = pbr.ao;
    float specularAO = computeSpecularAO(NoV, diffuseAO, pbr.roughness);
    float3 specularSingleBounceAO = singleBounceAO(specularAO) * energy_compensation;

    float3 Fd = pbr.albedo * light.diffuse * (1.0 - E) * (1.0 - pbr.metallic) * pbr.ao * light.attenuation;
    float3 Fr = E * light.specular * specularSingleBounceAO;

    indirect_standard = Fr + Fd;
  }

  // Apply lightmap-derived directional light for metallic surfaces
  float3 derivedLightContribution = 0;
#if defined(_LIGHTMAP_SPECULAR) && defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
  if (light.derivedLight.directionality > 0.001) {
    // Calculate lighting vectors for derived light
    const float3 h_derived = normalize(light.view_dir + light.derivedLight.direction);
    const float LoH_derived = saturate(dot(light.derivedLight.direction, h_derived));
    const float NoH_derived = saturate(dot(pbr.normal, h_derived));
    const float NoL_derived = light.derivedLight.NoL;
    
    // Apply specular contribution from lightmap (similar to Filament's approach)
    const float reflectance = computeDielectricF0(_reflectance);
    const float3 f0 = lerp(reflectance, pbr.albedo, pbr.metallic);
    
    // Calculate specular lobe for the derived light
    float3 Fr_derived = specularLobe(pbr, f0, h_derived, LoH_derived, NoH_derived, NoV, NoL_derived) * PI;
    
    // Apply AO and energy compensation
    float specularAO = computeSpecularAO(NoV, pbr.ao, pbr.roughness);
    const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
    const float3 energy_compensation = energyCompensation(dfg, f0);
    
    // The derived light contribution is weighted by metallic value
    // This ensures metallic surfaces get shadowing from lightmaps via specular
    derivedLightContribution = Fr_derived * light.derivedLight.color * 
                              light.derivedLight.directionality * 
                              specularAO * energy_compensation * NoL_derived;
    
    // For dielectrics, reduce the diffuse contribution to avoid double-counting
    indirect_standard *= (1.0 - light.derivedLight.directionality * (1.0 - pbr.metallic));
  }
#endif

#if defined(_MATERIAL_TYPE_CLOTH)
  float cloth_mask = _Cloth_Mask.Sample(linear_repeat_s, i.uv01.xy);
  float3 direct = lerp(direct_standard, direct_cloth, cloth_mask);
  float3 indirect = lerp(indirect_standard, indirect_cloth, cloth_mask);
#else
  float3 direct = direct_standard;
  float3 indirect = indirect_standard;
#endif

  return float4(direct + indirect + derivedLightContribution, pbr.albedo.a);
}

#endif  // __YUM_BRDF_INC
