#ifndef __YUM_LIGHTING_INC
#define __YUM_LIGHTING_INC

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityLightingCommon.cginc"

#include "features.cginc"
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
  float3 specular;
	float NoL;
#if defined(_WRAPPED_LIGHTING)
	float NoL_wrapped_s;  // specular
	float NoL_wrapped_d;  // diffuse
#endif
  float attenuation;
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

float3 getIndirectSpecular(v2f i, YumPbr pbr, float3 view_dir) {
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

#if defined(_FALLBACK_CUBEMAP)
  // Check if there's no valid scene cubemap
  if (!SceneHasReflections() || _Fallback_Cubemap_Force) {
    // Set up data for fallback sampling similar to Unity's system
    half3 reflectVector = reflect(-view_dir, pbr.normal);
    
    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
      reflectVector = BoxProjectedCubemapDirection(reflectVector, data.worldPos, /*probe_position=*/0, /*box_min=*/-1, /*box_max=*/1);
    #endif

    half mip = roughness * UNITY_SPECCUBE_LOD_STEPS;
    float4 envSample = UNITY_SAMPLE_TEXCUBE_LOD(_Fallback_Cubemap, reflectVector, mip);
    return DecodeHDR(envSample, _Fallback_Cubemap_HDR) * _Fallback_Cubemap_Brightness;
  }
#endif

  return UnityGI_prefilteredRadiance(data, roughness, reflect_dir);
}

float4 getIndirectDiffuse(v2f i, float4 vertexLightColor) {
	float4 diffuse = vertexLightColor;
#if defined(FORWARD_BASE_PASS)
#if defined(LIGHTMAP_ON)
	diffuse.xyz = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv2));
#else
	diffuse.xyz += max(0, BetterSH9(float4(0, 0, 0, 1)));
#endif
#endif
	return diffuse;
}

YumLighting GetYumLighting(v2f i, YumPbr pbr) {
	YumLighting light;

  // normalize has no visibile impact in test scene
  light.view_dir = -i.eyeVec.xyz;

#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
	light.dir = normalize((_WorldSpaceLightPos0 - i.worldPos).xyz);
#else
	light.dir = _WorldSpaceLightPos0;
#endif

	light.direct = _LightColor0.rgb;
	// TODO filament's spherical harmonics look nicer than this.
	// See FilamentLightIndirect.cginc::UnityGI_Irradiance in filamented.
  //ifex _Spherical_Harmonics==0
	light.diffuse = max(0, BetterSH9(float4(i.normal, 1)));
  //endex
  //ifex _Spherical_Harmonics==1
	light.diffuse = max(0, BetterSH9(float4(0, 0, 0, 1)));
  //endex
#if defined(_MIN_BRIGHTNESS)
  light.diffuse = max(_Min_Brightness, light.diffuse);
#endif

  light.specular = getIndirectSpecular(i, pbr, light.view_dir);

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
  float specular_luminance = dot(light.specular, float3(0.2126, 0.7152, 0.0722));  // convert to luminance
  light.specular = light.specular * floor(specular_luminance * _Quantize_Specular_Steps) / _Quantize_Specular_Steps;
#endif
#if defined(_QUANTIZE_DIFFUSE)
  float diffuse_luminance = dot(light.diffuse, float3(0.2126, 0.7152, 0.0722));  // convert to luminance
  light.diffuse = light.diffuse * floor(diffuse_luminance * _Quantize_Diffuse_Steps) / _Quantize_Diffuse_Steps;
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

  light.attenuation = getShadowAttenuation(i);

	return light;
}

#endif  // __YUM_LIGHTING_INC

