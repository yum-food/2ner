#ifndef __FEATURES_INC
#define __FEATURES_INC

//ifex _Material_Type_Cloth_Enabled==0  
#pragma shader_feature_local _MATERIAL_TYPE_CLOTH
#pragma shader_feature_local _MATERIAL_TYPE_CLOTH_SUBSURFACE
//endex

//ifex _Receive_Shadows_Enabled==0
#pragma shader_feature_local _RECEIVE_SHADOWS
//endex

//ifex _Cast_Shadows_Enabled==0
#pragma shader_feature_local _CAST_SHADOWS
//endex

//ifex _Alpha_Multiplier_Enabled==0
#pragma shader_feature_local _ALPHA_MULTIPLIER
//endex

//ifex _Ambient_Occlusion_Enabled==0
#pragma shader_feature_local _AMBIENT_OCCLUSION
//endex

//ifex _Detail_Maps_Enabled==0
#pragma shader_feature_local _DETAIL_MAPS
//endex

//ifex _Emission_Enabled==0
#pragma shader_feature_local _EMISSION
//endex

//ifex _Fallback_Cubemap_Enabled==0
#pragma shader_feature_local _FALLBACK_CUBEMAP
//endex

//ifex _Fallback_Cubemap_Limit_Metallic_Enabled==0
#pragma shader_feature_local _FALLBACK_CUBEMAP_LIMIT_METALLIC
//endex

//ifex _Wrapped_Lighting_Enabled==0
#pragma shader_feature_local _WRAPPED_LIGHTING
//endex

//ifex _Brightness_Control_Enabled==0
#pragma shader_feature_local _BRIGHTNESS_CONTROL
//endex

//ifex _Min_Brightness_Enabled==0
#pragma shader_feature_local _MIN_BRIGHTNESS
//endex

//ifex _Quantize_NoL_Enabled==0
#pragma shader_feature_local _QUANTIZE_NOL
//endex

//ifex _Quantize_Specular_Enabled==0
#pragma shader_feature_local _QUANTIZE_SPECULAR
//endex

//ifex _Clearcoat_Enabled==0
#pragma shader_feature_local _CLEARCOAT
//endex

//ifex _Metallics_Enabled==0
#pragma shader_feature_local _METALLICS
//endex

//ifex _Outlines_Enabled==0
#pragma shader_feature_local _OUTLINES
//endex
//ifex _Outline_Mask_Enabled==0
#pragma shader_feature_local _OUTLINE_MASK
//endex

//ifex _Matcap0_Enabled==0
#pragma shader_feature_local _MATCAP0
#pragma shader_feature_local _MATCAP0_MASK
#pragma shader_feature_local _MATCAP0_QUANTIZATION
//endex

//ifex _Matcap1_Enabled==0
#pragma shader_feature_local _MATCAP1
#pragma shader_feature_local _MATCAP1_MASK
#pragma shader_feature_local _MATCAP1_QUANTIZATION
//endex

//ifex _Rim_Lighting0_Enabled==0
#pragma shader_feature_local _RIM_LIGHTING0
#pragma shader_feature_local _RIM_LIGHTING0_MASK
#pragma shader_feature_local _RIM_LIGHTING0_ANGLE_LIMIT
#pragma shader_feature_local _RIM_LIGHTING0_QUANTIZATION
//endex
//ifex _Rim_Lighting1_Enabled==0
#pragma shader_feature_local _RIM_LIGHTING1
#pragma shader_feature_local _RIM_LIGHTING1_MASK
#pragma shader_feature_local _RIM_LIGHTING1_ANGLE_LIMIT
#pragma shader_feature_local _RIM_LIGHTING1_QUANTIZATION
//endex
//ifex _Rim_Lighting2_Enabled==0
#pragma shader_feature_local _RIM_LIGHTING2
#pragma shader_feature_local _RIM_LIGHTING2_MASK
#pragma shader_feature_local _RIM_LIGHTING2_ANGLE_LIMIT
#pragma shader_feature_local _RIM_LIGHTING2_QUANTIZATION
//endex
//ifex _Rim_Lighting3_Enabled==0
#pragma shader_feature_local _RIM_LIGHTING3
#pragma shader_feature_local _RIM_LIGHTING3_MASK
#pragma shader_feature_local _RIM_LIGHTING3_ANGLE_LIMIT
#pragma shader_feature_local _RIM_LIGHTING3_QUANTIZATION
//endex

//ifex _Face_Me_Enabled==0
#pragma shader_feature_local _FACE_ME
//endex

//ifex _Harnack_Tracing_Enabled==0
#pragma shader_feature_local _HARNACK_TRACING
#pragma shader_feature_local _HARNACK_TRACING_GYROID
//endex

//ifex _Decal0_Enabled==0
#pragma shader_feature_local _DECAL0
#pragma shader_feature_local _DECAL0_NORMAL
#pragma shader_feature_local _DECAL0_REFLECTIONS
#pragma shader_feature_local _DECAL0_SDF
#pragma shader_feature_local _DECAL0_MASK
#pragma shader_feature_local _DECAL0_TILING_MODE
#pragma shader_feature_local _DECAL0_REPLACE_ALPHA
#pragma shader_feature_local _DECAL0_MULTIPLY
#pragma shader_feature_local _DECAL0_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL0_DOMAIN_WARPING
#pragma shader_feature_local _DECAL0_EMISSIONS
#pragma shader_feature_local _DECAL0_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL0_EMISSIONS_PROXIMITY
//endex
//ifex _Decal1_Enabled==0
#pragma shader_feature_local _DECAL1
#pragma shader_feature_local _DECAL1_NORMAL
#pragma shader_feature_local _DECAL1_REFLECTIONS
#pragma shader_feature_local _DECAL1_SDF
#pragma shader_feature_local _DECAL1_MASK
#pragma shader_feature_local _DECAL1_TILING_MODE
#pragma shader_feature_local _DECAL1_REPLACE_ALPHA
#pragma shader_feature_local _DECAL1_MULTIPLY
#pragma shader_feature_local _DECAL1_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL1_DOMAIN_WARPING
#pragma shader_feature_local _DECAL1_EMISSIONS
#pragma shader_feature_local _DECAL1_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL1_EMISSIONS_PROXIMITY
//endex
//ifex _Decal2_Enabled==0
#pragma shader_feature_local _DECAL2
#pragma shader_feature_local _DECAL2_NORMAL
#pragma shader_feature_local _DECAL2_REFLECTIONS
#pragma shader_feature_local _DECAL2_SDF
#pragma shader_feature_local _DECAL2_MASK
#pragma shader_feature_local _DECAL2_TILING_MODE
#pragma shader_feature_local _DECAL2_REPLACE_ALPHA
#pragma shader_feature_local _DECAL2_MULTIPLY
#pragma shader_feature_local _DECAL2_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL2_DOMAIN_WARPING
#pragma shader_feature_local _DECAL2_EMISSIONS
#pragma shader_feature_local _DECAL2_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL2_EMISSIONS_PROXIMITY
//endex
//ifex _Decal3_Enabled==0
#pragma shader_feature_local _DECAL3
#pragma shader_feature_local _DECAL3_NORMAL
#pragma shader_feature_local _DECAL3_REFLECTIONS
#pragma shader_feature_local _DECAL3_SDF
#pragma shader_feature_local _DECAL3_MASK
#pragma shader_feature_local _DECAL3_TILING_MODE
#pragma shader_feature_local _DECAL3_REPLACE_ALPHA
#pragma shader_feature_local _DECAL3_MULTIPLY
#pragma shader_feature_local _DECAL3_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL3_DOMAIN_WARPING
#pragma shader_feature_local _DECAL3_EMISSIONS
#pragma shader_feature_local _DECAL3_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL3_EMISSIONS_PROXIMITY
//endex
//ifex _Decal4_Enabled==0
#pragma shader_feature_local _DECAL4
#pragma shader_feature_local _DECAL4_NORMAL
#pragma shader_feature_local _DECAL4_REFLECTIONS
#pragma shader_feature_local _DECAL4_SDF
#pragma shader_feature_local _DECAL4_MASK
#pragma shader_feature_local _DECAL4_TILING_MODE
#pragma shader_feature_local _DECAL4_REPLACE_ALPHA
#pragma shader_feature_local _DECAL4_MULTIPLY
#pragma shader_feature_local _DECAL4_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL4_DOMAIN_WARPING
#pragma shader_feature_local _DECAL4_EMISSIONS
#pragma shader_feature_local _DECAL4_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL4_EMISSIONS_PROXIMITY
//endex
//ifex _Decal5_Enabled==0
#pragma shader_feature_local _DECAL5
#pragma shader_feature_local _DECAL5_NORMAL
#pragma shader_feature_local _DECAL5_REFLECTIONS
#pragma shader_feature_local _DECAL5_SDF
#pragma shader_feature_local _DECAL5_MASK
#pragma shader_feature_local _DECAL5_TILING_MODE
#pragma shader_feature_local _DECAL5_REPLACE_ALPHA
#pragma shader_feature_local _DECAL5_MULTIPLY
#pragma shader_feature_local _DECAL5_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL5_DOMAIN_WARPING
#pragma shader_feature_local _DECAL5_EMISSIONS
#pragma shader_feature_local _DECAL5_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL5_EMISSIONS_PROXIMITY
//endex
//ifex _Decal6_Enabled==0
#pragma shader_feature_local _DECAL6
#pragma shader_feature_local _DECAL6_NORMAL
#pragma shader_feature_local _DECAL6_REFLECTIONS
#pragma shader_feature_local _DECAL6_SDF
#pragma shader_feature_local _DECAL6_MASK
#pragma shader_feature_local _DECAL6_TILING_MODE
#pragma shader_feature_local _DECAL6_REPLACE_ALPHA
#pragma shader_feature_local _DECAL6_MULTIPLY
#pragma shader_feature_local _DECAL6_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL6_DOMAIN_WARPING
#pragma shader_feature_local _DECAL6_EMISSIONS
#pragma shader_feature_local _DECAL6_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL6_EMISSIONS_PROXIMITY
//endex
//ifex _Decal7_Enabled==0
#pragma shader_feature_local _DECAL7
#pragma shader_feature_local _DECAL7_NORMAL
#pragma shader_feature_local _DECAL7_REFLECTIONS
#pragma shader_feature_local _DECAL7_SDF
#pragma shader_feature_local _DECAL7_MASK
#pragma shader_feature_local _DECAL7_TILING_MODE
#pragma shader_feature_local _DECAL7_REPLACE_ALPHA
#pragma shader_feature_local _DECAL7_MULTIPLY
#pragma shader_feature_local _DECAL7_CMYK_WARPING_PLANES
#pragma shader_feature_local _DECAL7_DOMAIN_WARPING
#pragma shader_feature_local _DECAL7_EMISSIONS
#pragma shader_feature_local _DECAL7_EMISSION_MODE_ADD_PRODUCT
#pragma shader_feature_local _DECAL7_EMISSIONS_PROXIMITY
//endex

//ifex _3D_SDF_Enabled==0
#pragma shader_feature_local _3D_SDF
//endex

//ifex _SSAO_Enabled==0
#pragma shader_feature_local _SSAO
//endex

//ifex _False_Color_Visualization_Enabled==0
#pragma shader_feature_local _FALSE_COLOR_VISUALIZATION
//endex

//ifex _Vertex_Domain_Warping_Enabled==0
#pragma shader_feature_local _VERTEX_DOMAIN_WARPING
//endex

//ifex _Vertex_Domain_Warping_Audiolink_Enabled==0
#pragma shader_feature_local _VERTEX_DOMAIN_WARPING_AUDIOLINK
//endex

//ifex _UV_Domain_Warping_Enabled==0
#pragma shader_feature_local _UV_DOMAIN_WARPING
//endex

//ifex _Eye_Effect_00_Enabled==0
#pragma shader_feature_local _EYE_EFFECT_00
//endex

//ifex _SSFD_Enabled==0
#pragma shader_feature_local _SSFD
//endex

//ifex _LTCGI_Enabled==0
#pragma shader_feature_local _LTCGI
//endex

//ifex _ExtraStencilColorPass_Enabled==0
#pragma shader_feature_local _EXTRA_STENCIL_COLOR_PASS
//endex

//ifex _Focal_Length_Control_Enabled==0
#pragma shader_feature_local _FOCAL_LENGTH_CONTROL
//endex

//ifex _Glitter_Enabled==0
#pragma shader_feature_local _GLITTER
//endex

//ifex _Glitter_Emission_Enabled==0
#pragma shader_feature_local _GLITTER_EMISSION
//endex

//ifex _Glitter_Angle_Limit_Enabled==0
#pragma shader_feature_local _GLITTER_ANGLE_LIMIT
//endex

//ifex _Glitter_Mask_Enabled==0
#pragma shader_feature_local _GLITTER_MASK
//endex

//ifex _Letter_Grid_Enabled==0
#pragma shader_feature_local _LETTER_GRID
//endex

//ifex _Unigram_Letter_Grid_Enabled==0
#pragma shader_feature_local _UNIGRAM_LETTER_GRID
//endex

//ifex _Shatter_Wave_Enabled==0
#pragma shader_feature_local _SHATTER_WAVE
//endex

//ifex _Shatter_Wave_Audiolink_Enabled==0
#pragma shader_feature_local _SHATTER_WAVE_AUDIOLINK
//endex

//ifex _Shatter_Wave_Rotation_Enabled==0
#pragma shader_feature_local _SHATTER_WAVE_ROTATION
//endex

//ifex _Mirror_UVs_In_Mirror_Enabled==0
#pragma shader_feature_local _MIRROR_UVS_IN_MIRROR
//endex

//ifex _Tessellation_Enabled==0
#pragma shader_feature_local _TESSELLATION
#pragma shader_feature_local _TESSELLATION_HEIGHTMAP
#pragma shader_feature_local _TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL
#pragma shader_feature_local _TESSELLATION_RANGE_FACTOR
//endex

//ifex _Spherize_Enabled==0
#pragma shader_feature_local _SPHERIZE
//endex

//ifex _Custom30_Enabled==0
#pragma shader_feature_local _CUSTOM30
#pragma shader_feature_local _CUSTOM30_BASICCUBE
#pragma shader_feature_local _CUSTOM30_BASICCUBE_CHAMFER
#pragma shader_feature_local _CUSTOM30_BASICCUBE_HEX_GRIP
#pragma shader_feature_local _CUSTOM30_BASICCUBE_HEX_BOLTS
#pragma shader_feature_local _CUSTOM30_BASICWEDGE
#pragma shader_feature_local _CUSTOM30_BASICPLATFORM
#pragma shader_feature_local _CUSTOM30_BASICPLATFORM_CHAMFER
#pragma shader_feature_local _CUSTOM30_BASICPLATFORM_Y_ALIGNED
#pragma shader_feature_local _CUSTOM30_BASICPLATFORM_VERTICAL
#pragma shader_feature_local _CUSTOM30_RAINBOW
//endex

//ifex _Depth_Prepass_Enabled==0
#pragma shader_feature_local _DEPTH_PREPASS
//endex

//ifex _Raymarched_Fog_Enabled==0
#pragma shader_feature_local _RAYMARCHED_FOG
//endex

//ifex _Raymarched_Fog_Emitter_Texture_Enabled==0
#pragma shader_feature_local _RAYMARCHED_FOG_EMITTER_TEXTURE
//endex

//ifex _Raymarched_Fog_Emitter_Texture_Warping_Enabled==0
#pragma shader_feature_local _RAYMARCHED_FOG_EMITTER_TEXTURE_WARPING
//endex

//ifex _Raymarched_Fog_Density_Exponent_Enabled==0
#pragma shader_feature_local _RAYMARCHED_FOG_DENSITY_EXPONENT
//endex

//ifex _Unlit_Enabled==0
#pragma shader_feature_local _UNLIT
//endex

//ifex _Masked_Stencil1_Enabled==0
#pragma shader_feature_local _MASKED_STENCIL1
//endex

//ifex _Masked_Stencil2_Enabled==0
#pragma shader_feature_local _MASKED_STENCIL2
//endex

//ifex _Masked_Stencil3_Enabled==0
#pragma shader_feature_local _MASKED_STENCIL3
//endex

//ifex _Masked_Stencil4_Enabled==0
#pragma shader_feature_local _MASKED_STENCIL4
//endex

//ifex _Oklch_Correction_Enabled==0
#pragma shader_feature_local _OKLCH_CORRECTION
//endex

//ifex _Oklab_Brightness_Clamp_Enabled==0
#pragma shader_feature_local _OKLAB_BRIGHTNESS_CLAMP
//endex

//ifex _Grayscale_Lightmaps_Enabled==0
#pragma shader_feature_local _GRAYSCALE_LIGHTMAPS
//endex

//ifex _Bakery_Enabled==0
#pragma shader_feature_local _BAKERY
#pragma shader_feature_local _BAKERY_RNM
#pragma shader_feature_local _BAKERY_SH
#pragma shader_feature_local _BAKERY_MONOSH
//endex

//ifex _Spherical_Harmonics_L1_Enabled==0
#pragma shader_feature_local _SPHERICAL_HARMONICS_L1
//endex

#endif  // __FEATURES_INC

