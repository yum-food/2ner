#ifndef UNITY_STANDARD_META_INCLUDED
#define UNITY_STANDARD_META_INCLUDED

// Functionality for Standard shader "meta" pass
// (extracts albedo/emission for lightmapper etc.)

#include "UnityCG.cginc"
#include "UnityMetaPass.cginc"

#include "custom30.cginc"
#include "eyes.cginc"
#include "face_me.cginc"
#include "false_color_visualization.cginc"
#include "features.cginc"
#include "fog.cginc"
#include "globals.cginc"
#include "harnack_tracing.cginc"
#include "interpolators.cginc"
#include "letter_grid.cginc"
#include "matcaps.cginc"
#include "math.cginc"
#include "poi.cginc"
#include "shatter_wave.cginc"
#include "ssao.cginc"
#include "ssfd.cginc"
#include "tessellation.cginc"
#include "unigram_letter_grid.cginc"
#include "vertex_domain_warping.cginc"
#include "yum_brdf.cginc"
#include "yum_pbr.cginc"
#include "yum_lighting.cginc"

struct v2f_meta
{
    float4 pos      : SV_POSITION;
    float4 uv01     : TEXCOORD0;
    float4 uv23     : TEXCOORD1;
    float3 worldPos : TEXCOORD2;
    float3 objPos   : TEXCOORD3;
    float3 normal   : TEXCOORD4;
    float3 tangent  : TEXCOORD5;
    float3 binormal : TEXCOORD6;
    float4 color    : COLOR;
#ifdef EDITOR_VISUALIZATION
    float2 vizUV        : TEXCOORD7;
    float4 lightCoord   : TEXCOORD8;
#endif
};

v2f_meta vert_meta (appdata v)
{
    v2f_meta o;
    o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
    
    o.uv01.xy = v.uv0;
#if defined(LIGHTMAP_ON)
    o.uv01.zw = v.uv1 * unity_LightmapST.xy + unity_LightmapST.zw;
#else
    o.uv01.zw = v.uv1;
#endif
    o.uv23.xy = v.uv2;
    o.uv23.zw = v.uv3;
    
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    o.objPos = v.vertex;
    
    o.normal = v.normal;
    o.tangent = v.tangent.xyz;
    o.binormal = cross(o.normal, o.tangent) * v.tangent.w;
    
    o.color = v.color;
    
#ifdef EDITOR_VISUALIZATION
    o.vizUV = 0;
    o.lightCoord = 0;
    if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
        o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.uv0.xy, v.uv1.xy, v.uv2.xy, unity_EditorViz_Texture_ST);
    else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
    {
        o.vizUV = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
    }
#endif
    return o;
}

float4 frag_meta (v2f_meta i) : SV_Target
{
    i.normal = normalize(UnityObjectToWorldNormal(i.normal));
    i.tangent = normalize(UnityObjectToWorldNormal(i.tangent));
    i.binormal = normalize(UnityObjectToWorldNormal(i.binormal));
    
    float4x4 tangentToWorld = float4x4(
        float4(i.tangent.x, i.binormal.x, i.normal.x, 0),
        float4(i.tangent.y, i.binormal.y, i.normal.y, 0),
        float4(i.tangent.z, i.binormal.z, i.normal.z, 0),
        float4(0, 0, 0, 1)
    );
    
    // Convert v2f_meta to v2f structure expected by YumPbr
    v2f pbr_input;
    pbr_input.uv01 = i.uv01;
    pbr_input.uv23 = i.uv23;
    pbr_input.worldPos = i.worldPos;
    pbr_input.objPos = float4(i.objPos, 1.0);
    pbr_input.normal = i.normal;
    pbr_input.tangent = i.tangent;
    pbr_input.binormal = i.binormal;
    pbr_input.color = i.color;
    
    YumPbr pbr = GetYumPbr(pbr_input, tangentToWorld);

#if defined(_CUSTOM30)
#if defined(_CUSTOM30_BASICCUBE)
    Custom30Output c30_out = BasicCube(pbr_input, tangentToWorld);
#elif defined(_CUSTOM30_BASICWEDGE)
    Custom30Output c30_out = BasicWedge(pbr_input, tangentToWorld);
#elif defined(_CUSTOM30_BASICPLATFORM)
    Custom30Output c30_out = BasicPlatform(pbr_input, tangentToWorld);
#elif defined(_CUSTOM30_RAINBOW)
    Custom30Output c30_out = Rainbow(pbr_input, tangentToWorld);
#else
    Custom30Output c30_out = (Custom30Output) 0;
    c30_out.normal = pbr_input.normal;
    c30_out.objPos = pbr_input.objPos.xyz;
#endif
    // Update surface properties with volumetric results
    pbr_input.normal = c30_out.normal;
    pbr_input.worldPos = mul(unity_ObjectToWorld, float4(c30_out.objPos, 1));
    
    // Recalculate tangent space with new normal
    tangentToWorld = float4x4(
        float4(i.tangent.x, i.binormal.x, pbr_input.normal.x, 0),
        float4(i.tangent.y, i.binormal.y, pbr_input.normal.y, 0),
        float4(i.tangent.z, i.binormal.z, pbr_input.normal.z, 0),
        float4(0, 0, 0, 1)
    );
    
    // Get PBR properties with updated surface
    pbr = GetYumPbr(pbr_input, tangentToWorld);
#endif

    UnityMetaInput o;
    UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);

#ifdef EDITOR_VISUALIZATION
    o.Albedo = pbr.albedo.rgb;
    o.VizUV = i.vizUV;
    o.LightCoord = i.lightCoord;
#else
    // For lightmapping, we want the diffuse albedo with some contribution from rough metals
    half roughness = pbr.roughness_perceptual;
    half3 res = pbr.albedo.rgb;
    res += pbr.metallic * roughness * 0.5;
    o.Albedo = res;
#endif
    
    o.SpecularColor = lerp(0.04, pbr.albedo.rgb, pbr.metallic);
    
#if defined(_EMISSION)
    o.Emission = pbr.emission;
#else
    o.Emission = 0;
#endif

    return UnityMetaFragment(o);
}

#endif // UNITY_STANDARD_META_INCLUDED
