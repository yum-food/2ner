#ifndef __YUM_LIGHTING_INC
#define __YUM_LIGHTING_INC

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityLightingCommon.cginc"

#include "features.cginc"
#include "LightVolumes.cginc"
#include "poi.cginc"
#include "yum_pbr.cginc"

// fucking kill me
#ifndef __LTCGI_INC
#define __LTCGI_INC

#include "features.cginc"

#if defined(_LTCGI)
struct ltcgi_acc {
  float3 diffuse;
  float3 specular;
};

#include "Third_Party/at.pimaker.ltcgi/Shaders/LTCGI_structs.cginc"

void ltcgi_cb_diffuse(inout ltcgi_acc acc, in ltcgi_output output);
void ltcgi_cb_specular(inout ltcgi_acc acc, in ltcgi_output output);

#define LTCGI_V2_CUSTOM_INPUT ltcgi_acc
#define LTCGI_V2_DIFFUSE_CALLBACK ltcgi_cb_diffuse
#define LTCGI_V2_SPECULAR_CALLBACK ltcgi_cb_specular

#include "Third_Party/at.pimaker.ltcgi/Shaders/LTCGI.cginc"
void ltcgi_cb_diffuse(inout ltcgi_acc acc, in ltcgi_output output) {
	acc.diffuse += output.intensity * output.color * _LTCGI_DiffuseColor;
}
void ltcgi_cb_specular(inout ltcgi_acc acc, in ltcgi_output output) {
	acc.specular += output.intensity * output.color * _LTCGI_SpecularColor;
}
#endif  // _LTCGI

#endif  // __LTCGI_INC

struct YumLighting {
	float3 view_dir;
	float3 dir;
	float3 direct;
	float3 diffuse;
  float diffuse_luminance;
  float3 specular;
	float NoL;
#if defined(_WRAPPED_LIGHTING)
	float NoL_wrapped_s;  // specular
	float NoL_wrapped_d;  // diffuse
#endif
  float attenuation;
  float3 L00;
  float3 L01r;
  float3 L01g;
  float3 L01b;
  float occlusion;
  Light derivedLight;
};

float getShadowAttenuation(v2f i)
{
	float attenuation;
	// This whole block is yoinked from AutoLight.cginc. I needed a way to
	// control shadow strength so I had to duplicate the code.
#if defined(DIRECTIONAL_COOKIE)
	DECLARE_LIGHT_COORD(i, i.worldPos);
	float shadow = UNITY_SHADOW_ATTENUATION(i, i.worldPos);
	attenuation = tex2D(_LightTexture0, lightCoord).w;
#elif defined(POINT_COOKIE)
	DECLARE_LIGHT_COORD(i, i.worldPos);
	float shadow = UNITY_SHADOW_ATTENUATION(i, i.worldPos);
	attenuation = tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).r *
		texCUBE(_LightTexture0, lightCoord).w;
#elif defined(DIRECTIONAL)
	float shadow = UNITY_SHADOW_ATTENUATION(i, i.worldPos);
	attenuation = 1;
#elif defined(SPOT)
	DECLARE_LIGHT_COORD(i, i.worldPos);
	float shadow = UNITY_SHADOW_ATTENUATION(i, i.worldPos);
	attenuation = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) *
    UnitySpotAttenuate(lightCoord.xyz);
#elif defined(POINT)
	unityShadowCoord3 lightCoord =
    mul(unity_WorldToLight, unityShadowCoord4(i.worldPos, 1)).xyz;
	float shadow = UNITY_SHADOW_ATTENUATION(i, i.worldPos);
	attenuation = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;
#else
	float shadow = 1;
	attenuation = 1;
#endif
	attenuation *= lerp(1, shadow, _Shadow_Strength);
	return attenuation;
}

float3 getDirectLightDirection(v2f i) {
#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
	return normalize((_WorldSpaceLightPos0 - i.worldPos).xyz);
#else
	return _WorldSpaceLightPos0;
#endif
}

float GetLodRoughness(float roughness) {
	return roughness * (1.7 - 0.7 * roughness);
}

float3 getIndirectSpecular(v2f i, YumPbr pbr, float3 view_dir, float diffuse_luminance) {
  float roughness = GetLodRoughness(pbr.roughness_perceptual);
	float3 reflect_dir = reflect(-view_dir, pbr.normal);

  UnityGIInput data;
  data.worldPos = i.worldPos;
  data.worldViewDir = view_dir;
  data.probeHDR[0] = unity_SpecCube0_HDR;
  data.probeHDR[1] = unity_SpecCube1_HDR;
#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
  data.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
#endif
#ifdef UNITY_SPECCUBE_BOX_PROJECTION
  data.boxMax[0] = unity_SpecCube0_BoxMax;
  data.probePosition[0] = unity_SpecCube0_ProbePosition;
  data.boxMax[1] = unity_SpecCube1_BoxMax;
  data.boxMin[1] = unity_SpecCube1_BoxMin;
  data.probePosition[1] = unity_SpecCube1_ProbePosition;
#endif

  const float3 env_refl = UnityGI_prefilteredRadiance(data, roughness, reflect_dir);

#if defined(_FALLBACK_CUBEMAP)
  // Check if there's no valid scene cubemap
  float3 canned_refl = env_refl;
  if (!SceneHasReflections() || _Fallback_Cubemap_Force) {
    // Set up data for fallback sampling similar to Unity's system
    half3 reflectVector = reflect(-view_dir, pbr.normal);
    
    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
      reflectVector = BoxProjectedCubemapDirection(reflectVector, data.worldPos, /*probe_position=*/0, /*box_min=*/-1, /*box_max=*/1);
    #endif

    half mip = roughness * UNITY_SPECCUBE_LOD_STEPS;
    float4 envSample = UNITY_SAMPLE_TEXCUBE_LOD(_Fallback_Cubemap, reflectVector, mip);
    canned_refl = DecodeHDR(envSample, _Fallback_Cubemap_HDR) * _Fallback_Cubemap_Brightness * diffuse_luminance;
  }
#endif

#if defined(_FALLBACK_CUBEMAP_LIMIT_METALLIC)
  return lerp(env_refl, canned_refl, pbr.metallic);
#elif defined(_FALLBACK_CUBEMAP)
  return canned_refl;
#else
  return env_refl;
#endif
}

float3 yumSH9(float4 n, float3 worldPos, inout YumLighting light) {
#if defined(YUM_SH9_STANDARD)
  // Unity gives us the first three bands (L0-L2) of SH coefficients as follows:
  //   unity_SHA*.w:   L0 coefficients
  //   unity_SHA*.xyz: L1 coefficients
  //   unity_SHB*:     first four of the L2 coefficients
  //   unity_SHC:      last L2 coefficient

  // Parse out coefficients into a simpler but less efficient format.
  float3 L00  = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
  float3 L1_1 = float3(unity_SHAr.x, unity_SHAg.x, unity_SHAb.x);
  float3 L10  = float3(unity_SHAr.y, unity_SHAg.y, unity_SHAb.y);
  float3 L11  = float3(unity_SHAr.z, unity_SHAg.z, unity_SHAb.z);
  float3 L2_2 = float3(unity_SHBr.x, unity_SHBg.x, unity_SHBb.x);
  float3 L2_1 = float3(unity_SHBr.y, unity_SHBg.y, unity_SHBb.y);
  float3 L20  = float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z);
  float3 L21  = float3(unity_SHBr.w, unity_SHBg.w, unity_SHBb.w);
  float3 L22  = unity_SHC;

  // Equation 13 from "An Efficient Representation for Irradiance Environment
  // Maps" by Ramamoorthi and Hanrahan. Note that the order of some
  // coefficients is different, and normalization constants have been
  // premultiplied by Unity.
  float3 L0 = L00;
  float3 L1 = L1_1 * n.x + L10 * n.y + L11 * n.z;
  float3 L2 =
    L2_2 * n.x * n.y +
    L2_1 * n.y * n.z +
    L20  * n.z * n.z +
    L21 * n.x * n.z +
    L22 * (n.x * n.x - n.y * n.y);

  light.L00 = L00;
  light.L01r = unity_SHAr.xyz;
  light.L01g = unity_SHAg.xyz;
  light.L01b = unity_SHAb.xyz;

  return L0 + L1 + L2;
#elif 1
  // Light volumes. We omit the L01 contribution since flat shading looks
  // better on avatars.
  LightVolumeSH(worldPos, light.L00, light.L01r, light.L01g, light.L01b);
  return LightVolumeEvaluate(n.xyz, light.L00,
      _UdonLightVolumeEnabled ? light.L01r : 0,
      _UdonLightVolumeEnabled ? light.L01g : 0,
      _UdonLightVolumeEnabled ? light.L01b : 0);
#else
  // On non-photorealistic avatars, simply using the diffuse component looks
  // better. *shruge*
  float3 L00  = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);

  light.L00 = L00;
  light.L01r = unity_SHAr.xyz;
  light.L01g = unity_SHAg.xyz;
  light.L01b = unity_SHAb.xyz;

  return L00;
#endif
}

float3 SubtractMainLightWithRealtimeAttenuationFromLightmap(float3 lightmap, float attenuation, float4 bakedColorTex, float3 normalWorld) {
    float3 shadowColor = unity_ShadowColor.rgb;
    float shadowStrength = _LightShadowData.x;

    // Calculate estimated light contribution that should be shadowed
    float ndotl = saturate(dot(normalWorld, _WorldSpaceLightPos0.xyz));
    float3 estimatedLightContributionMaskedByInverseOfShadow = ndotl * (1.0 - attenuation) * _LightColor0.rgb;
    float3 subtractedLightmap = lightmap - estimatedLightContributionMaskedByInverseOfShadow;

    // Apply shadow color and strength
    float3 realtimeShadow = max(subtractedLightmap, shadowColor);
    realtimeShadow = lerp(realtimeShadow, lightmap, shadowStrength);

    // Pick darkest color
    return min(lightmap, realtimeShadow);
}

YumLighting GetYumLighting(v2f i, YumPbr pbr) {
	YumLighting light = (YumLighting) 0;

  // normalize has no visibile impact in test scene
  light.view_dir = -normalize(i.eyeVec.xyz);

  light.dir = getDirectLightDirection(i);

	light.direct = _LightColor0.rgb;
	
	// Calculate attenuation first, before diffuse lighting
#if defined(LIGHTMAP_ON)
  light.attenuation = 1;
#else
  light.attenuation = getShadowAttenuation(i);
#endif

	float3 tangentNormal = mul(pbr.normal, transpose(float3x3(i.tangent, i.binormal, i.normal)));
	float3x3 tangentToWorld = float3x3(i.tangent, i.binormal, i.normal);

	light.diffuse = UnityGI_Irradiance(
			pbr.normal,           // worldNormal
			i.worldPos,           // worldPos  
			float4(i.uv01.zw, 0, 0),               // lightmapUV (xy = uv0, zw = uv1)
			float3(0,0,0),        // ambient (will be calculated internally)
			light.attenuation,    // attenuation
			tangentNormal,        // tangentNormal
			tangentToWorld,       // tangentToWorld
			#if defined(USING_BAKERY_VERTEXLMSH)
					// You'll need to add these to your v2f if using Bakery vertex SH
					i.bakeryVertexSH,
			#elif defined(USING_BAKERY_VERTEXLMDIR)
					// You'll need to add this to your v2f if using Bakery vertex directional
					i.bakeryVertexDir,
			#endif
			light.occlusion,            // out occlusion
			light.derivedLight          // out Light
	);

#if defined(_MIN_BRIGHTNESS)
  light.diffuse = max(_Min_Brightness, light.diffuse);
#endif

  light.diffuse_luminance = luminance(light.diffuse);
  light.specular = getIndirectSpecular(i, pbr, light.view_dir, light.diffuse_luminance);

#if defined(_LTCGI)
  ltcgi_acc acc = (ltcgi_acc) 0;
  LTCGI_Contribution(
      acc,
      i.worldPos,
      pbr.normal,
      light.view_dir,
      pbr.roughness_perceptual,
      0);
  light.diffuse += acc.diffuse * _LTCGI_Strength;
  light.specular += acc.specular * _LTCGI_Strength;
#endif

#if defined(_QUANTIZE_SPECULAR)
  float specular_luminance = luminance(light.specular);
  light.specular = light.specular * floor(specular_luminance * _Quantize_Specular_Steps) / _Quantize_Specular_Steps;
#endif
#if defined(_QUANTIZE_DIFFUSE)
  light.diffuse = light.diffuse * floor(light.diffuse_luminance * _Quantize_Diffuse_Steps) / _Quantize_Diffuse_Steps;
  light.diffuse_luminance = luminance(light.diffuse);
#endif

#if defined(_BRIGHTNESS_CONTROL)
  light.direct *= _Brightness_Multiplier;
  light.diffuse *= _Brightness_Multiplier;
  light.specular *= _Brightness_Multiplier;
#endif

  light.NoL = dot(pbr.normal, light.dir);
#if defined(_QUANTIZE_NOL)
  light.NoL = floor(light.NoL * _Quantize_NoL_Steps) / _Quantize_NoL_Steps;
#endif
#if defined(_WRAPPED_LIGHTING)
  light.NoL_wrapped_s = saturate(wrapNoL(light.NoL, _Wrap_NoL_Specular_Strength));
  light.NoL_wrapped_d = saturate(wrapNoL(light.NoL, _Wrap_NoL_Diffuse_Strength));
#endif
  light.NoL = saturate(light.NoL);

	return light;
}

#endif  // __YUM_LIGHTING_INC

