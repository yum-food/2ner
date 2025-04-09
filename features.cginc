#ifndef __FEATURES_INC
#define __FEATURES_INC

//ifex _Material_Type_Cloth_Enabled==0  
#pragma shader_feature_local _MATERIAL_TYPE_CLOTH
#pragma shader_feature_local _MATERIAL_TYPE_CLOTH_SUBSURFACE
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
//endex
//ifex _Decal1_Enabled==0
#pragma shader_feature_local _DECAL1
#pragma shader_feature_local _DECAL1_NORMAL
#pragma shader_feature_local _DECAL1_REFLECTIONS
#pragma shader_feature_local _DECAL1_SDF
#pragma shader_feature_local _DECAL1_MASK
#pragma shader_feature_local _DECAL1_TILING_MODE
#pragma shader_feature_local _DECAL1_REPLACE_ALPHA
//endex
//ifex _Decal2_Enabled==0
#pragma shader_feature_local _DECAL2
#pragma shader_feature_local _DECAL2_NORMAL
#pragma shader_feature_local _DECAL2_REFLECTIONS
#pragma shader_feature_local _DECAL2_SDF
#pragma shader_feature_local _DECAL2_MASK
#pragma shader_feature_local _DECAL2_TILING_MODE
#pragma shader_feature_local _DECAL2_REPLACE_ALPHA
//endex
//ifex _Decal3_Enabled==0
#pragma shader_feature_local _DECAL3
#pragma shader_feature_local _DECAL3_NORMAL
#pragma shader_feature_local _DECAL3_REFLECTIONS
#pragma shader_feature_local _DECAL3_SDF
#pragma shader_feature_local _DECAL3_MASK
#pragma shader_feature_local _DECAL3_TILING_MODE
#pragma shader_feature_local _DECAL3_REPLACE_ALPHA
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
#pragma shader_feature_local _TESSELLATION_RANGE_FACTOR
//endex

//ifex _Spherize_Enabled==0
#pragma shader_feature_local _SPHERIZE
//endex

#endif  // __FEATURES_INC

