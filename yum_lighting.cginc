#ifndef __YUM_LIGHTING_INC
#define __YUM_LIGHTING_INC

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityLightingCommon.cginc"
#include "UnityStandardCoreMinimal.cginc"

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

  attenuation *= shadow;

  GetBakedAttenuation(attenuation, i.uv01.zw, i.worldPos);

	attenuation = lerp(1, attenuation, _Shadow_Strength);
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
  LightVolumeSH(worldPos, light.L00, light.L01r, light.L01g, light.L01b);
#if defined(_SPHERICAL_HARMONICS_L1)
  return LightVolumeEvaluate(n.xyz, light.L00, light.L01r, light.L01g, light.L01b);
#else
  return LightVolumeEvaluate(n.xyz, light.L00, 0, 0, 0);
#endif
}

float4 getIndirectDiffuse(v2f i, float4 vertexLightColor,
    inout YumLighting light) {
  float4 diffuse = vertexLightColor;
#if defined(FORWARD_BASE_PASS)
#if defined(LIGHTMAP_ON)
  diffuse.xyz = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv01.zw));
#else
  diffuse.xyz += max(0, yumSH9(float4(i.normal, 0), i.worldPos, light));
#endif
#endif
  return diffuse;
}

YumLighting GetYumLighting(v2f i, YumPbr pbr) {
	YumLighting light = (YumLighting) 0;

  // normalize has no visibile impact in test scene
  light.view_dir = -normalize(i.eyeVec.xyz);

  light.dir = getDirectLightDirection(i);

	light.direct = _LightColor0.rgb;
	
	// Calculate attenuation first, before diffuse lighting
  light.attenuation = getShadowAttenuation(i);

	float3 tangentNormal = mul(pbr.normal, transpose(float3x3(i.tangent, i.binormal, i.normal)));
	float3x3 tangentToWorld = float3x3(i.tangent, i.binormal, i.normal);

	// Use Bakery-aware irradiance function
#if defined(LIGHTMAP_ON)
	light.diffuse = BakeryGI_Irradiance(
			pbr.normal,           // worldNormal
			i.worldPos,           // worldPos
			float4(i.uv01.zw, 0, 0),               // lightmapUV (xy = uv0, zw = uv1)
			float3(0,0,0),        // ambient (will be calculated internally)
			light.attenuation,    // attenuation
			tangentNormal,        // tangentNormal
			tangentToWorld,       // tangentToWorld
			light.occlusion,            // out occlusion
			light.derivedLight          // out Light
	);
#if defined(_GRAYSCALE_LIGHTMAPS)
  light.diffuse.gb = light.diffuse.r;
#endif
#else
  light.diffuse = getIndirectDiffuse(i, 0, light);
  light.occlusion = 1;
#endif

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

