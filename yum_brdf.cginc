#ifndef __YUM_BRDF_INC
#define __YUM_BRDF_INC

#include "UnityCG.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityLightingCommon.cginc"

#include "filamented.cginc"
#include "math.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

// See "Physically Based Shading at Disney" by Burley et. al.
// This is from page 14.
// From that paper, we have:
//  * theta_v (aka arccos(NoV)): angle between view and normal
//  * theta_h (aka arccos(NoH)): angle between normal and half vector
//  * theta_l (aka arccos(NoL)): angle between light and normal
//  * theta_d (aka arccos(LoH)): angle between light and half vector
float DisneyDiffuse(float roughness,
    float LoH, float NoL, float NoV, float f90) {
  const float f_d =
    (1 + (f90 - 1) * pow5(1 - NoL)) *
    (1 + (f90 - 1) * pow5(1 - NoV));
  return f_d;
}

float3 diffuseLobe(float3 albedo, float roughness, float LoH, float NoL,
    float NoV, float f90)
{
  return albedo * DisneyDiffuse(roughness, LoH, NoL, NoV, f90);
}

float3 specularLobe(YumPbr pbr, float f0,
    float3 h, float LoH, float NoH, float NoV, float NoL)
{
  const float3 F = F_Schlick(f0, LoH);

  // Normal distribution function
  float D = D_GGX(pbr.roughness, NoH, h);
  // Geometric shadowing
  float V = V_SmithGGXCorrelated_Fast(pbr.roughness, NoV, NoL);

  return (D * V) * F * PI;
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

  // Typical values for different materials listed here:
  //   https://google.github.io/filament/Filament.html#toc4.8.3.2
  // TODO expose an enum for different types of materials
  const float reflectance = _reflectance;
  // f0 = amount of light reflected back when viewing surface at a right angle
  // I think the way that f0 is calculated in the comment below is correct, but
  // the other way is how filamented works, so I'm going with that for now.
  //const float3 f0 = lerp(0.16 * reflectance * reflectance, pbr.albedo, pbr.metallic);
  const float3 f0 = reflectance * (1.0 - pbr.metallic) + pbr.albedo * pbr.metallic;
  const float3 dfg = PrefilteredDFG_LUT(pbr.roughness_perceptual, NoV);
  const float3 E = specularDFG(dfg, f0);
  const float3 energy_compensation = energyCompensation(dfg, f0);

  float3 direct;
  {
    float3 Fd = diffuseLobe(pbr.albedo, pbr.roughness_perceptual, LoH, NoL,
        NoV, f90);
    Fd *= (1.0 - pbr.metallic) * light.attenuation;
    float3 Fr = specularLobe(pbr, f0, h, LoH, NoH, NoV, NoL_wrapped_s);
    float3 color = Fd * NoL_wrapped_d + Fr * energy_compensation * NoL_wrapped_s;

    direct = color * light.direct;
  }

  float3 indirect;
  {
    float3 Fr = E * light.specular * energy_compensation;
    float3 Fd = pbr.albedo * light.diffuse * (1.0 - E) * (1.0 - pbr.metallic) * pbr.ao;
    indirect = Fr + Fd;
  }

  return float4(direct + indirect, pbr.albedo.a);
}

#endif  // __YUM_BRDF_INC
