#ifndef __FEATURES_INC
#define __FEATURES_INC

//ifex _Alpha_Multiplier_Enabled==0
#pragma shader_feature_local _ALPHA_MULTIPLIER
//endex

//ifex _Ambient_Occlusion_Enabled==0
#pragma shader_feature_local _AMBIENT_OCCLUSION
//endex

//ifex _Emission_Enabled==0
#pragma shader_feature_local _EMISSION
//endex

//ifex _Wrapped_Lighting_Enabled==0
#pragma shader_feature_local _WRAPPED_LIGHTING
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

//ifex _Vertex_Domain_Warping_Enabled==0
#pragma shader_feature_local _VERTEX_DOMAIN_WARPING
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

#endif  // __FEATURES_INC

