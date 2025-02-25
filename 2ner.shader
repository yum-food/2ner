Shader "yum_food/2ner"
{
  // Certain parts of the Properties below are derived from Poiyomi's toon
  // shader. The license is available in this repository at the top of
  // poi.cginc.
	Properties
  {
      [HideInInspector] shader_master_label("<color=#de719bff>2ner</color>", Float) = 0
      [HideInInspector] shader_is_using_thry_editor("", Float) = 0
      [HideInInspector] shader_presets("ThryPresetsExample", Float) = 0
      [HideInInspector] shader_properties_label_file("ThryLabelExample", Float) = 0

      //ifex _ShaderOptimizerEnabled==0
      [HideInInspector] _ForgotToLockMaterial(";;YOU_FORGOT_TO_LOCK_THE_MATERIAL;", Int) = 0
      //endex
      [ThryShaderOptimizerLockButton] _ShaderOptimizerEnabled("", Int) = 0

      // TODO these are buggy
      // [HideInInspector] footer_youtube ("", Float) = 0
      // [HideInInspector] footer_github ("", Float) = 0

      [ThryWideEnum(Opaque, 0, Cutout, 1, TransClipping, 9, Fade, 2, Transparent, 3, Additive, 4, Soft Additive, 5, Multiplicative, 6, 2x Multiplicative, 7)]_Mode("Rendering Preset--{on_value_actions:[
      {value:0,actions:[{type:SET_PROPERTY,data:render_queue=2000},{type:SET_PROPERTY,data:_AlphaForceOpaque=1}, {type:SET_PROPERTY,data:render_type=Opaque},            {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=0}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:1,actions:[{type:SET_PROPERTY,data:render_queue=2450},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=TransparentCutout}, {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=.5}, {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:9,actions:[{type:SET_PROPERTY,data:render_queue=2460},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=TransparentCutout}, {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0.01},  {type:SET_PROPERTY,data:_SrcBlend=5}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=5}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=5}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:2,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0.002},  {type:SET_PROPERTY,data:_SrcBlend=5}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=5}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=5}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:3,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=1}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:4,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=1},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=1},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:5,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=4}, {type:SET_PROPERTY,data:_DstBlend=1},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=4}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=4}, {type:SET_PROPERTY,data:_OutlineDstBlend=1},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:6,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=2}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=2}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=2}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
      {value:7,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=2}, {type:SET_PROPERTY,data:_DstBlend=3},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=2}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=2}, {type:SET_PROPERTY,data:_OutlineDstBlend=3},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]}
      }]}]}", Int) = 0

      [HideInInspector] m_mainOptions("Main", Float) = 0
      _Color("Tint", Color) = (1, 1, 1, 1)
      _MainTex("Base color", 2D) = "white" {}
      [PanningTexture][Normal]_BumpMap("Normals", 2D) = "bump" {}
      _BumpScale("Normal Intensity", Range(0, 10)) = 1
      _Clip("Alpha Cuttoff", Range(0, 1.001)) = 0.5
        //ifex _Alpha_Multiplier_Enabled==0
        [HideInInspector] m_start_Alpha_Multiplier("Alpha multiplier", Float) = 0
          [ThryToggle(_ALPHA_MULTIPLIER)]_Alpha_Multiplier_Enabled("Enable", Float) = 0
          _Alpha_Multiplier("Multiplier", Float) = 1
        [HideInInspector] m_end_Alpha_Multiplier("Alpha multiplier", Float) = 0
        //endex

        //ifex _Emission_Enabled==0
        [HideInInspector] m_start_Emission("Emission", Float) = 0
          [ThryToggle(_EMISSION)]_Emission_Enabled("Enable", Float) = 0
          _EmissionColor("Color", Color) = (1, 1, 1, 1)
          _EmissionMap("Emission", 2D) = "white" {}
          [HideInInspector] m_end_Emission("Emission", Float) = 0
        //endex

        //ifex _Ambient_Occlusion_Enabled==0
        [HideInInspector] m_start_AO("Ambient occlusion", Float) = 0
        [ThryToggle(_AMBIENT_OCCLUSION)]_Ambient_Occlusion_Enabled("Enable", Float) = 0
        _OcclusionMap("Ambient occlusion", 2D) = "white" {}
        _OcclusionStrength("Ambient occlusion", Float) = 1
        [HideInInspector] m_end_AO("Metallics", Float) = 0
        //endex

      //ifex _Metallics_Enabled==0
      [HideInInspector] m_reflectionOptions("Reflections", Float) = 0
      [HideInInspector] m_start_Metallic("Metallics", Float) = 0
        [ThryToggle(_METALLICS)]_Metallics_Enabled("Enable", Float) = 0
        _MetallicMask("Metallic Mask", 2D) = "white" {}
        _Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
      [HideInInspector] m_end_Metallic("Metallics", Float) = 0
      //endex

      [HideInInspector] m_gimmicks("Gimmicks", Float) = 0
        //ifex _Outlines_Enabled==0
        [HideInInspector] m_start_Outlines("Outlines", Float) = 0
        [ThryToggle(_OUTLINES)]_Outlines_Enabled("Enable", Float) = 0
        _Outline_Color("Color", Color) = (0, 0, 0, 1)
        _Outline_Width("Width", Float) = 0.01
          [HideInInspector] m_start_OutlinesMask("Mask", Float) = 0
          [ThryToggle(_OUTLINE_MASK)]_Outline_Mask_Enabled("Enable", Float) = 0
          _Outline_Mask("Thickness mask", 2D) = "white" {}
          [HideInInspector] m_end_OutlinesMask("Mask", Float) = 0
        [HideInInspector] m_end_Outlines("Outlines", Float) = 0
        //endex

        //ifex _Matcap0_Enabled==0
        [HideInInspector] m_start_Matcaps("Matcaps", Float) = 0
          [HideInInspector] m_start_Matcap0("Matcap 0", Float) = 0
          [ThryToggle(_MATCAP0)]_Matcap0_Enabled("Enable", Float) = 0
          _Matcap0("Matcap", 2D) = "white" {}
          [Toggle(_)]_Matcap0_Invert("Invert", Float) = 0
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Matcap0_Mode("Mode", Int) = 0
          _Matcap0_Strength("Strength", Float) = 1
            //ifex _Matcap0_Mask_Enabled==0
            [HideInInspector] m_start_Matcap0_Mask("Mask", Float) = 0
            [ThryToggle(_MATCAP0_MASK)]_Matcap0_Mask_Enabled("Enable", Float) = 0
            _Matcap0_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Matcap0_Mask("Mask", Float) = 0
            //endex
            //ifex _Matcap0_Quantization_Enabled==0
            [HideInInspector] m_start_Matcap0_Quantization("Quantization", Float) = 0
            [ThryToggle(_MATCAP0_QUANTIZATION)]_Matcap0_Quantization_Enabled("Enable", Float) = 0
            _Matcap0_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Matcap0_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Matcap0("Matcaps", Float) = 0
        [HideInInspector] m_end_Matcaps("Matcaps", Float) = 0
        //endex

        [HideInInspector] m_start_Rim_Lighting("Rim lighting", Float) = 0
          //ifex _Rim_Lighting0_Enabled==0
          [HideInInspector] m_start_Rim_Lighting0("Rim lighting 0", Float) = 0
          [ThryToggle(_RIM_LIGHTING0)]_Rim_Lighting0_Enabled("Enable", Float) = 0
          _Rim_Lighting0_Center("Center", Range(0, 0.5)) = 0.5
          _Rim_Lighting0_Power("Power", Float) = 5
          _Rim_Lighting0_Color("Color", Color) = (1, 1, 1, 1)
          _Rim_Lighting0_Brightness("Brightness", Float) = 1
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Rim_Lighting0_Mode("Mode", Int) = 0
            //ifex _Rim_Lighting0_Mask_Enabled==0
            [HideInInspector] m_start_Rim_Lighting0_Mask("Mask", Float) = 0
            [ThryToggle(_RIM_LIGHTING0_MASK)]_Rim_Lighting0_Mask_Enabled("Enable", Float) = 0
            _Rim_Lighting0_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Rim_Lighting0_Mask("Mask", Float) = 0
            //endex
            //ifex _Rim_Lighting0_Angle_Limit_Enabled==0
            [HideInInspector] m_start_Rim_Lighting0_Angle_Limit("Angle limit", Float) = 0
            [ThryToggle(_RIM_LIGHTING0_ANGLE_LIMIT)]_Rim_Lighting0_Angle_Limit_Enabled("Enable", Float) = 0
            _Rim_Lighting0_Angle_Limit_Target_Vector("Target vector", Vector) = (0, -1, 0, 0)
            _Rim_Lighting0_Angle_Limit_Power("Power", Float) = 1
            [HideInInspector] m_end_Rim_Lighting0_Angle_Limit("Angle limit", Float) = 0
            //endex
            //ifex _Rim_Lighting0_Quantization_Enabled==0
            [HideInInspector] m_start_Rim_Lighting0_Quantization("Quantization", Float) = 0
            [ThryToggle(_RIM_LIGHTING0_QUANTIZATION)]_Rim_Lighting0_Quantization_Enabled("Enable", Float) = 0
            _Rim_Lighting0_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Rim_Lighting0_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Rim_Lighting0("Rim lighting", Float) = 0
          //endex

          //ifex _Rim_Lighting1_Enabled==0
          [HideInInspector] m_start_Rim_Lighting1("Rim lighting 1", Float) = 0
          [ThryToggle(_RIM_LIGHTING1)]_Rim_Lighting1_Enabled("Enable", Float) = 0
          _Rim_Lighting1_Center("Center", Range(0, 0.5)) = 0.5
          _Rim_Lighting1_Power("Power", Float) = 5
          _Rim_Lighting1_Color("Color", Color) = (1, 1, 1, 1)
          _Rim_Lighting1_Brightness("Brightness", Float) = 1
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Rim_Lighting1_Mode("Mode", Int) = 0
            //ifex _Rim_Lighting1_Mask_Enabled==0
            [HideInInspector] m_start_Rim_Lighting1_Mask("Mask", Float) = 0
            [ThryToggle(_RIM_LIGHTINg1_MASK)]_Rim_Lighting1_Mask_Enabled("Enable", Float) = 0
            _Rim_Lighting1_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Rim_Lighting1_Mask("Mask", Float) = 0
            //endex
            //ifex _Rim_Lighting1_Angle_Limit_Enabled==0
            [HideInInspector] m_start_Rim_Lighting1_Angle_Limit("Angle limit", Float) = 0
            [ThryToggle(_RIM_LIGHTING1_ANGLE_LIMIT)]_Rim_Lighting1_Angle_Limit_Enabled("Enable", Float) = 0
            _Rim_Lighting1_Angle_Limit_Target_Vector("Target vector", Vector) = (0, -1, 0, 0)
            _Rim_Lighting1_Angle_Limit_Power("Power", Float) = 1
            [HideInInspector] m_end_Rim_Lighting1_Angle_Limit("Angle limit", Float) = 0
            //endex
            //ifex _Rim_Lighting1_Quantization_Enabled==0
            [HideInInspector] m_start_Rim_Lighting1_Quantization("Quantization", Float) = 0
            [ThryToggle(_RIM_LIGHTING1_QUANTIZATION)]_Rim_Lighting1_Quantization_Enabled("Enable", Float) = 0
            _Rim_Lighting1_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Rim_Lighting1_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Rim_Lighting1("Rim lighting", Float) = 0
          //endex

          //ifex _Rim_Lighting2_Enabled==0
          [HideInInspector] m_start_Rim_Lighting2("Rim lighting 2", Float) = 0
          [ThryToggle(_RIM_LIGHTING2)]_Rim_Lighting2_Enabled("Enable", Float) = 0
          _Rim_Lighting2_Center("Center", Range(0, 0.5)) = 0.5
          _Rim_Lighting2_Power("Power", Float) = 5
          _Rim_Lighting2_Color("Color", Color) = (1, 1, 1, 1)
          _Rim_Lighting2_Brightness("Brightness", Float) = 1
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Rim_Lighting2_Mode("Mode", Int) = 0
            //ifex _Rim_Lighting2_Mask_Enabled==0
            [HideInInspector] m_start_Rim_Lighting2_Mask("Mask", Float) = 0
            [ThryToggle(_RIM_LIGHTING2_MASK)]_Rim_Lighting2_Mask_Enabled("Enable", Float) = 0
            _Rim_Lighting2_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Rim_Lighting2_Mask("Mask", Float) = 0
            //endex
            //ifex _Rim_Lighting2_Angle_Limit_Enabled==0
            [HideInInspector] m_start_Rim_Lighting2_Angle_Limit("Angle limit", Float) = 0
            [ThryToggle(_RIM_LIGHTING2_ANGLE_LIMIT)]_Rim_Lighting2_Angle_Limit_Enabled("Enable", Float) = 0
            _Rim_Lighting2_Angle_Limit_Target_Vector("Target vector", Vector) = (0, -1, 0, 0)
            _Rim_Lighting2_Angle_Limit_Power("Power", Float) = 1
            [HideInInspector] m_end_Rim_Lighting2_Angle_Limit("Angle limit", Float) = 0
            //endex
            //ifex _Rim_Lighting2_Quantization_Enabled==0
            [HideInInspector] m_start_Rim_Lighting2_Quantization("Quantization", Float) = 0
            [ThryToggle(_RIM_LIGHTING2_QUANTIZATION)]_Rim_Lighting2_Quantization_Enabled("Enable", Float) = 0
            _Rim_Lighting2_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Rim_Lighting2_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Rim_Lighting2("Rim lighting", Float) = 0
          //endex

          //ifex _Rim_Lighting3_Enabled==0
          [HideInInspector] m_start_Rim_Lighting3("Rim lighting 3", Float) = 0
          [ThryToggle(_RIM_LIGHTING3)]_Rim_Lighting3_Enabled("Enable", Float) = 0
          _Rim_Lighting3_Center("Center", Range(0, 0.5)) = 0.5
          _Rim_Lighting3_Power("Power", Float) = 5
          _Rim_Lighting3_Color("Color", Color) = (1, 1, 1, 1)
          _Rim_Lighting3_Brightness("Brightness", Float) = 1
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Rim_Lighting3_Mode("Mode", Int) = 0
            //ifex _Rim_Lighting3_Mask_Enabled==0
            [HideInInspector] m_start_Rim_Lighting3_Mask("Mask", Float) = 0
            [ThryToggle(_RIM_LIGHTING3_MASK)]_Rim_Lighting3_Mask_Enabled("Enable", Float) = 0
            _Rim_Lighting3_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Rim_Lighting3_Mask("Mask", Float) = 0
            //endex
            //ifex _Rim_Lighting3_Angle_Limit_Enabled==0
            [HideInInspector] m_start_Rim_Lighting3_Angle_Limit("Angle limit", Float) = 0
            [ThryToggle(_RIM_LIGHTING3_ANGLE_LIMIT)]_Rim_Lighting3_Angle_Limit_Enabled("Enable", Float) = 0
            _Rim_Lighting3_Angle_Limit_Target_Vector("Target vector", Vector) = (0, -1, 0, 0)
            _Rim_Lighting3_Angle_Limit_Power("Power", Float) = 1
            [HideInInspector] m_end_Rim_Lighting3_Angle_Limit("Angle limit", Float) = 0
            //endex
            //ifex _Rim_Lighting3_Quantization_Enabled==0
            [HideInInspector] m_start_Rim_Lighting3_Quantization("Quantization", Float) = 0
            [ThryToggle(_RIM_LIGHTING3_QUANTIZATION)]_Rim_Lighting3_Quantization_Enabled("Enable", Float) = 0
            _Rim_Lighting3_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Rim_Lighting3_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Rim_Lighting3("Rim lighting", Float) = 0
          //endex

        [HideInInspector] m_end_Rim_Lighting("Rim lighting", Float) = 0

        //ifex _Vertex_Domain_Warping_Enabled==0
        [HideInInspector] m_start_Vertex_Domain_Warping("Vertex domain warping", Float) = 0
          [ThryToggle(_VERTEX_DOMAIN_WARPING)]_Vertex_Domain_Warping_Enabled("Enable", Float) = 0
          _Vertex_Domain_Warping_Spatial_Strength("Spatial warping strength", Float) = 0.10
          _Vertex_Domain_Warping_Spatial_Scale("Spatial warping scale", Float) = 1.0
          _Vertex_Domain_Warping_Spatial_Octaves("Spatial warping octaves", Float) = 1.0
          _Vertex_Domain_Warping_Speed("Speed", Float) = 1.0
          _Vertex_Domain_Warping_Temporal_Strength("Temporal warping strength", Float) = 0.10
          [HideInInspector] m_end_Vertex_Domain_Warping("Vertex domain warping", Float) = 0
        //endex

        //ifex _UV_Domain_Warping_Enabled==0
        [HideInInspector] m_start_UV_Domain_Warping("UV domain warping", Float) = 0
          [ThryToggle(_UV_DOMAIN_WARPING)]_UV_Domain_Warping_Enabled("Enable", Float) = 0
          _UV_Domain_Warping_Spatial_Strength("Spatial warping strength", Float) = 0.10
          _UV_Domain_Warping_Spatial_Scale("Spatial warping scale", Float) = 0.10
          _UV_Domain_Warping_Spatial_Octaves("Spatial warping octaves", Float) = 1.0
          [HideInInspector] m_end_UV_Domain_Warping("UV domain warping", Float) = 0
        //endex

        //ifex _Eye_Effect_00_Enabled==0
        [HideInInspector] m_start_Eye_Effect_00("Eye effect 00", Float) = 0
          [ThryToggle(_EYE_EFFECT_00)]_Eye_Effect_00_Enabled("Enable", Float) = 0
          _Gimmick_Eye_Effect_00_Edge_Length("Edge length", Float) = 0.1
          _Gimmick_Eye_Effect_00_Period("Period", Vector) = (1.0, 1.0, 1.0)
          _Gimmick_Eye_Effect_00_Count("Count", Vector) = (1.0, 1.0, 1.0)
          _Gimmick_Eye_Effect_00_Noise("Noise", 2D) = "white" {}
          _Gimmick_Eye_Effect_00_Domain_Warping_Octaves("Domain warping octaves", Float) = 1.0
          _Gimmick_Eye_Effect_00_Domain_Warping_Scale("Domain warping scale", Float) = 1.0
          _Gimmick_Eye_Effect_00_Domain_Warping_Speed("Domain warping speed", Float) = 1.0
          _Gimmick_Eye_Effect_00_Domain_Warping_Strength("Domain warping strength", Float) = 0.1
          [HideInInspector] m_end_Eye_Effect_00("Eye effect 00", Float) = 0
        //endex

        //ifex _SSFD_Enabled==0
        [HideInInspector] m_start_SSFD("SSFD", Float) = 0
          [ThryToggle(_SSFD)] _SSFD_Enabled("Enable", Float) = 0
          _SSFD_Scale("Scale", Float) = 1.0
          _SSFD_Max_Fwidth("Max fwidth", Float) = 1.0
          _SSFD_Noise("Noise", 3D) = "black" {}
          _SSFD_Size_Factor("Size factor", Float) = 1.0
          _SSFD_Threshold("Threshold", Range(0, 1)) = 0.5
        [HideInInspector] m_end_SSFD("SSFD", Float) = 0
        //endex

        //ifex _Masked_Stencil_Enabled==0
        [HideInInspector] m_start_Masked_Stencil("Masked stencil", Float) = 0
          [ThryToggle(_)] _Masked_Stencil_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _MaskedStencilType ("Stencil Type", Float) = 0
          _Masked_Stencil_Mask("Mask", 2D) = "white" {}
          [IntRange] _MaskedStencilRef ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _MaskedStencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _MaskedStencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilPassOp ("Stencil Pass Op--{condition_showS:(_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilFailOp ("Stencil Fail Op--{condition_showS:(_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilZFailOp ("Stencil ZFail Op--{condition_showS:(_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencilCompareFunction ("Stencil Compare Function--{condition_showS:(_StencilType==0)}", Float) = 8
          [HideInInspector] m_start_MaskedStencilPassBackOptions("Back--{condition_showS:(_MaskedStencilType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilBackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilBackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilBackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencilBackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencilPassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_MaskedStencilPassFrontOptions("Front--{condition_showS:(_MaskedStencilType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilFrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilFrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencilFrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencilFrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencilPassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Masked_Stencil("Masked stencil", Float) = 0
        //endex

        //ifex _Stencil_Enabled==0
        [HideInInspector] m_start_Stencil("Stencil", Float) = 0
          [ThryToggle(_)] _Stencil_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _StencilType ("Stencil Type", Float) = 0
          [IntRange] _StencilRef ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Stencil Pass Op--{condition_showS:(_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Stencil Fail Op--{condition_showS:(_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("Stencil ZFail Op--{condition_showS:(_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompareFunction ("Stencil Compare Function--{condition_showS:(_StencilType==0)}", Float) = 8
          [HideInInspector] m_start_StencilPassBackOptions("Back--{condition_showS:(_StencilType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _StencilBackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _StencilBackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _StencilBackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _StencilBackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_StencilPassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_StencilPassFrontOptions("Front--{condition_showS:(_StencilType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _StencilFrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _StencilFrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _StencilFrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _StencilFrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_StencilPassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Stencil("Stencil", Float) = 0
        //endex

        //ifex _ExtraStencilColorPass_Enabled==0
        [HideInInspector] m_start_ExtraStencilColorPass("Extra stencil color pass", Float) = 0
          [ThryToggle(_EXTRA_STENCIL_COLOR_PASS)] _ExtraStencilColorPass_Enabled("Enable", Float) = 0
          _ExtraStencilColor("Color", Color) = (1, 1, 1, 1)
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _ExtraStencilColorType ("Stencil Type", Float) = 0
          [IntRange] _ExtraStencilColorRef ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _ExtraStencilColorReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _ExtraStencilColorWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorPassOp ("Stencil Pass Op--{condition_showS:(_ExtraStencilColorType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorFailOp ("Stencil Fail Op--{condition_showS:(_ExtraStencilColorType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorZFailOp ("Stencil ZFail Op--{condition_showS:(_ExtraStencilColorType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _ExtraStencilColorCompareFunction ("Stencil Compare Function--{condition_showS:(_ExtraStencilColorType==0)}", Float) = 8
          [HideInInspector] m_start_ExtraStencilColorPassBackOptions("Back--{condition_showS:(_ExtraStencilColorType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorBackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorBackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorBackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _ExtraStencilColorBackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_ExtraStencilColorPassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_ExtraStencilColorPassFrontOptions("Front--{condition_showS:(_ExtraStencilColorType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorFrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorFrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _ExtraStencilColorFrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _ExtraStencilColorFrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_ExtraStencilColorPassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_ExtraStencilColorPass("Extra Stencil Color", Float) = 0
        //endex

        //ifex _Outline_Stencil_Enabled==0
        [HideInInspector] m_start_Outline_Stencil("Outline Stencil", Float) = 0
          [ThryToggle(_)] _Outline_Stencil_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _Outline_StencilType ("Stencil Type", Float) = 0
          [IntRange] _Outline_StencilRef ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _Outline_StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _Outline_StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilPassOp ("Stencil Pass Op--{condition_showS:(_Outline_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilFailOp ("Stencil Fail Op--{condition_showS:(_Outline_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilZFailOp ("Stencil ZFail Op--{condition_showS:(_Outline_StencilType==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _Outline_StencilCompareFunction ("Stencil Compare Function--{condition_showS:(_Outline_StencilType==0)}", Float) = 8
          [HideInInspector] m_start_Outline_StencilPassBackOptions("Back--{condition_showS:(_Outline_StencilType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilBackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilBackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilBackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _Outline_StencilBackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_Outline_StencilPassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_Outline_StencilPassFrontOptions("Front--{condition_showS:(_Outline_StencilType==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilFrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilFrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _Outline_StencilFrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _Outline_StencilFrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_Outline_StencilPassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Outline_Stencil("Outline Stencil", Float) = 0
        //endex

        //ifex _Focal_Length_Control_Enabled==0
        [HideInInspector] m_start_Focal_Length_Control("Focal Length Control", Float) = 0
          [ThryToggle(_FOCAL_LENGTH_CONTROL)] _Focal_Length_Control_Enabled("Enable", Float) = 0
          [MaterialToggle] _Focal_Length_Enabled_Dynamic("Enable (dynamic)", Float) = 0
          _Focal_Length_Multiplier("Focal length multiplier", Float) = 1.0
        [HideInInspector] m_end_Focal_Length_Control("Focal Length Control", Float) = 0
        //endex

      [HideInInspector] m_lightingOptions("Lighting Options", Float) = 0
        //ifex _Receive_Shadows_Enabled==0
        [HideInInspector] m_start_Shadow_Receiving("Receive shadows", Float) = 0
        [ThryToggle(_RECEIVE_SHADOWS)] _Receive_Shadows_Enabled("Enable", Float) = 1
        _Shadow_Strength("Shadow strength", Range(0, 1)) = 0.25
        [HideInInspector] m_end_Shadow_Receiving("Shadows", Float) = 0
        //endex
        //ifex _Cast_Shadows_Enabled==0
        [HideInInspector] m_start_Shadow_Casting("Cast shadows", Float) = 0
        [ThryToggle(_)] _Cast_Shadows_Enabled("Enable", Float) = 1
        [HideInInspector] m_end_Shadow_Casting("Cast shadows", Float) = 0
        //ifex _Wrapped_Lighting_Enabled==0
        [HideInInspector] m_start_WrappedLighting("Wrapped lighting", Float) = 0
        [ThryToggle(_WRAPPED_LIGHTING)] _Wrapped_Lighting_Enabled("Enable", Float) = 1
        _Wrap_NoL_Diffuse_Strength("Diffuse strength", Range(0, 1)) = 0.25
        _Wrap_NoL_Specular_Strength("Specular strength", Range(0, 1)) = 0.1
        [HideInInspector] m_end_WrappedLighting("Wrapped lighting", Float) = 0
        //endex
        //ifex _Min_Brightness_Enabled==0
        [HideInInspector] m_start_Min_Brightness("Minimum brightness", Float) = 0
        [ThryToggle(_MIN_BRIGHTNESS)] _Min_Brightness_Enabled("Enable", Float) = 0
        _Min_Brightness("Value", Range(0, 1)) = 0
        [HideInInspector] m_end_Min_Brightness("Minimum brightness", Float) = 0
        //endex
        //ifex _Quantize_NoL_Enabled==0
        [HideInInspector] m_start_Quantize_NoL("Quantize NoL", Float) = 0
          [ThryToggle(_QUANTIZE_NOL)] _Quantize_NoL_Enabled("Enable", Float) = 0
          _Quantize_NoL_Steps("Steps", Float) = 1
        [HideInInspector] m_end_Quantize_NoL("Quantize NoL", Float) = 0
        //endex
        //ifex _Quantize_Specular_Enabled==0
        [HideInInspector] m_start_Quantize_Specular("Quantize Specular", Float) = 0
          [ThryToggle(_QUANTIZE_SPECULAR)] _Quantize_Specular_Enabled("Enable", Float) = 0
          _Quantize_Specular_Steps("Steps", Float) = 1
        [HideInInspector] m_end_Quantize_Specular("Quantize Specular", Float) = 0
        //endex
        //ifex _LTCGI_Enabled==0
        [HideInInspector] m_start_LTCGI("LTCGI", Float) = 0
          [ThryToggle(_LTCGI)] _LTCGI_Enabled("Enable", Float) = 0
          _LTCGI_Strength("Strength", Range(0, 1)) = 1.0
          _LTCGI_SpecularColor("Specular color", Color) = (1, 1, 1, 1)
          _LTCGI_DiffuseColor("Diffuse color", Color) = (1, 1, 1, 1)
        [HideInInspector] m_end_LTCGI("LTCGI", Float) = 0
        //endex

      [HideInInspector] m_renderingOptions("Rendering Options", Float) = 0
      [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2
      [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4
      [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Source Blend", Float) = 1
      [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Destination Blend", Float) = 0
      [Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Int) = 1
      [Enum(Realistic, 0, Toon, 1)] _SphericalHarmonics("Spherical harmonics", Int) = 1
      [HideInInspector] m_start_blending ("Blending--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/rendering/blending},hover:Documentation}}", Float) = 0
      [DoNotAnimate][Enum(Thry.BlendOp)]_BlendOp ("RGB Blend Op", Int) = 0
      [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("RGB Source Blend", Int) = 1
      [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("RGB Destination Blend", Int) = 0
      [DoNotAnimate][Space][ThryHeaderLabel(Additive Blending, 13)]
      [DoNotAnimate][Enum(Thry.BlendOp)]_AddBlendOp ("RGB Blend Op", Int) = 4
      [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddSrcBlend ("RGB Source Blend", Int) = 1
      [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddDstBlend ("RGB Destination Blend", Int) = 1
        [DoNotAnimate][HideInInspector] m_start_alphaBlending ("Advanced Alpha Blending", Float) = 0
        [DoNotAnimate][Enum(Thry.BlendOp)]_BlendOpAlpha ("Alpha Blend Op", Int) = 0
        [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha ("Alpha Source Blend", Int) = 1
        [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha ("Alpha Destination Blend", Int) = 10
        [DoNotAnimate][Space][ThryHeaderLabel(Additive Blending, 13)]
        [DoNotAnimate][Enum(Thry.BlendOp)]_AddBlendOpAlpha ("Alpha Blend Op", Int) = 4
        [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddSrcBlendAlpha ("Alpha Source Blend", Int) = 0
        [DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddDstBlendAlpha ("Alpha Destination Blend", Int) = 1
        [DoNotAnimate][HideInInspector] m_end_alphaBlending ("Advanced Alpha Blending", Float) = 0
      [HideInInspector] m_end_blending ("Blending", Float) = 0
      //ifex _Outlines_Enabled==0
      // Outline Blending Options
      [HideInInspector] m_start_outlineBlending ("Outline Blending", Float) = 0
      [Enum(Thry.BlendOp)]_OutlineBlendOp ("RGB Blend Op", Int) = 0
      [Enum(UnityEngine.Rendering.BlendMode)] _OutlineSrcBlend ("RGB Source Blend", Int) = 1
      [Enum(UnityEngine.Rendering.BlendMode)] _OutlineDstBlend ("RGB Destination Blend", Int) = 0
      [HideInInspector] m_start_outlineAlphaBlending ("Advanced Alpha Blending", Float) = 0
      [Enum(Thry.BlendOp)]_OutlineBlendOpAlpha ("Alpha Blend Op", Int) = 4
      [Enum(UnityEngine.Rendering.BlendMode)] _OutlineSrcBlendAlpha ("Alpha Source Blend", Int) = 1
      [Enum(UnityEngine.Rendering.BlendMode)] _OutlineDstBlendAlpha ("Alpha Destination Blend", Int) = 0
      [HideInInspector] m_end_outlineAlphaBlending ("Advanced Alpha Blending", Float) = 0
      [HideInInspector] m_end_outlineBlending ("Outline Blending", Float) = 0
      //endex

    [HideInInspector] m_FilamentStuff("Filament stuff", Float) = 0
    [NonModifiableTextureData]_DFG("DFG", 2D) = "white" {}
    [ThryWideEnum(Water, 0.02, Skin, 0.028, Eyes, 0.025, Hair, 0.046, Teeth, 0.058, Fabric, 0.05, Stone, 0.045, Plastic, 0.045, Glass, 0.06, Gemstone, 0.07, Diamond, 0.18)]_reflectance("Reflectance", Float) = 0.028
    [Helpbox]_reflectance_help("Values are documented in the filament whitepaper here https://google.github.io/filament/Filament.html#toc4.8.3.2", Float) = 1
    _specularAntiAliasingVariance("Specular AA variance", Float) = 0.15
    _specularAntiAliasingThreshold("Specular AA variance", Float) = 0.25
  }

  SubShader {
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "VRCFallback" = "Standard" }

    //ifex _Masked_Stencil_Enabled==0
    Pass {
      Name "MASKEDSTENCIL"
      Tags { "LightMode" = "ForwardBase" }
      //BlendOp [_BlendOp], [_BlendOpAlpha]
      //Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      //Cull [_Cull]
      ZWrite Off
      ZTest LEqual

			Stencil
			{
				Ref [_MaskedStencilRef]
				ReadMask [_MaskedStencilReadMask]
				WriteMask [_MaskedStencilWriteMask]
				//ifex _MaskedStencilType==1
				Comp [_MaskedStencilCompareFunction]
				Pass [_MaskedStencilPassOp]
				Fail [_MaskedStencilFailOp]
				ZFail [_MaskedStencilZFailOp]
				//endex

				//ifex _MaskedStencilType==0
				CompBack [_MaskedStencilBackCompareFunction]
				PassBack [_MaskedStencilBackPassOp]
				FailBack [_MaskedStencilBackFailOp]
				ZFailBack [_MaskedStencilBackZFailOp]

				CompFront [_MaskedStencilFrontCompareFunction]
				PassFront [_MaskedStencilFrontPassOp]
				FailFront [_MaskedStencilFrontFailOp]
				ZFailFront [_MaskedStencilFrontZFailOp]
				//endex
			}

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      #define MASKED_STENCIL_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
    Pass {
      Name "FORWARD"
      Tags { "LightMode" = "ForwardBase" }
      BlendOp [_BlendOp], [_BlendOpAlpha]
      Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      Cull [_Cull]
      ZWrite [_ZWrite]
      ZTest [_ZTest]

      //ifex _Stencil_Enabled==0
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				//ifex _StencilType==1
				Comp [_StencilCompareFunction]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
				//endex

				//ifex _StencilType==0
				CompBack [_StencilBackCompareFunction]
				PassBack [_StencilBackPassOp]
				FailBack [_StencilBackFailOp]
				ZFailBack [_StencilBackZFailOp]

				CompFront [_StencilFrontCompareFunction]
				PassFront [_StencilFrontPassOp]
				FailFront [_StencilFrontFailOp]
				ZFailFront [_StencilFrontZFailOp]
				//endex
			}
      //endex

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_fwdbase
      #pragma multi_compile_instancing
      #pragma multi_compile_fog
      #pragma vertex vert
      #pragma fragment frag

      #define FORWARD_BASE_PASS

      #include "2ner.cginc"
      ENDCG
    }
    Pass {
      Name "ADDITIVE"
      Tags { "LightMode" = "ForwardAdd" }
      Fog { Color (0,0,0,0) }
      Cull [_Cull]
      ZWrite Off
      ZTest [_ZTest]
			BlendOp [_AddBlendOp], [_AddBlendOpAlpha]
			Blend [_AddSrcBlend] [_AddDstBlend], [_AddSrcBlendAlpha] [_AddDstBlendAlpha]

      //ifex _Stencil_Enabled==0
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				//ifex _StencilType==1
				Comp [_StencilCompareFunction]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
				//endex

				//ifex _StencilType==0
				CompBack [_StencilBackCompareFunction]
				PassBack [_StencilBackPassOp]
				FailBack [_StencilBackFailOp]
				ZFailBack [_StencilBackZFailOp]

				CompFront [_StencilFrontCompareFunction]
				PassFront [_StencilFrontPassOp]
				FailFront [_StencilFrontFailOp]
				ZFailFront [_StencilFrontZFailOp]
				//endex
			}
      //endex

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_fwdadd_fullshadows
      #pragma multi_compile_instancing
      #pragma multi_compile_fog
      #pragma vertex vert
      #pragma fragment frag

      #define FORWARD_ADD_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //ifex _ExtraStencilColorPass_Enabled==0
    Pass {
      Name "EXTRASTENCILCOLOR"
      Tags { "LightMode" = "ForwardBase" }
      BlendOp [_BlendOp], [_BlendOpAlpha]
      Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      Cull [_Cull]
      ZWrite [_ZWrite]
      ZTest [_ZTest]

			Stencil
			{
				Ref [_ExtraStencilColorRef]
				ReadMask [_ExtraStencilColorReadMask]
				WriteMask [_ExtraStencilColorWriteMask]
				//ifex _ExtraStencilColorType==1
				Comp [_ExtraStencilColorCompareFunction]
				Pass [_ExtraStencilColorPassOp]
				Fail [_ExtraStencilColorFailOp]
				ZFail [_ExtraStencilColorZFailOp]
				//endex

				//ifex _ExtraStencilColorType==0
				CompBack [_ExtraStencilColorBackCompareFunction]
				PassBack [_ExtraStencilColorBackPassOp]
				FailBack [_ExtraStencilColorBackFailOp]
				ZFailBack [_ExtraStencilColorBackZFailOp]

				CompFront [_MaskedStencilFrontCompareFunction]
				PassFront [_ExtraStencilColorFrontPassOp]
				FailFront [_ExtraStencilColorFrontFailOp]
				ZFailFront [_ExtraStencilColorFrontZFailOp]
				//endex
			}

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      #define EXTRA_STENCIL_COLOR_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
    //ifex _Outlines_Enabled==0
    Pass {
      Name "OUTLINES"
      Tags { "LightMode" = "ForwardBase" }
      Cull Front
      ZWrite [_ZWrite]
      ZTest [_ZTest]
			BlendOp [_OutlineBlendOp], [_OutlineBlendOpAlpha]
			Blend [_OutlineSrcBlend] [_OutlineDstBlend], [_OutlineSrcBlendAlpha] [_OutlineDstBlendAlpha]

      //ifex _Outline_Stencil_Enabled==0
			Stencil
			{
				Ref [_Outline_StencilRef]
				ReadMask [_Outline_StencilReadMask]
				WriteMask [_Outline_StencilWriteMask]
				//ifex _Outline_StencilType==1
				Comp [_Outline_StencilCompareFunction]
				Pass [_Outline_StencilPassOp]
				Fail [_Outline_StencilFailOp]
				ZFail [_Outline_StencilZFailOp]
				//endex

				//ifex _Outline_StencilType==0
				CompBack [_Outline_StencilBackCompareFunction]
				PassBack [_Outline_StencilBackPassOp]
				FailBack [_Outline_StencilBackFailOp]
				ZFailBack [_Outline_StencilBackZFailOp]

				CompFront [_Outline_StencilFrontCompareFunction]
				PassFront [_Outline_StencilFrontPassOp]
				FailFront [_Outline_StencilFrontFailOp]
				ZFailFront [_Outline_StencilFrontZFailOp]
				//endex
			}
      //endex

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_fwdbase
      #pragma multi_compile_instancing
      #pragma multi_compile_fog
      #pragma vertex vert
      #pragma fragment frag

      #define OUTLINE_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
    Pass {
      Name "ShadowCaster"
      Tags { "LightMode" = "ShadowCaster" }

      ZWrite [_ZWrite]
      ZTest [_ZTest]

      //ifex _Stencil_Enabled==0
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				//ifex _StencilType==1
				Comp [_StencilCompareFunction]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
				//endex

				//ifex _StencilType==0
				CompBack [_StencilBackCompareFunction]
				PassBack [_StencilBackPassOp]
				FailBack [_StencilBackFailOp]
				ZFailBack [_StencilBackZFailOp]

				CompFront [_StencilFrontCompareFunction]
				PassFront [_StencilFrontPassOp]
				FailFront [_StencilFrontFailOp]
				ZFailFront [_StencilFrontZFailOp]
				//endex
			}
      //endex

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_shadowcaster
      #pragma multi_compile_instancing
      #pragma multi_compile_fog
      #pragma vertex vert
      #pragma fragment frag

      #define SHADOW_CASTER_PASS

      #include "2ner.cginc"

      ENDCG
    }
  }
  CustomEditor "Thry.ShaderEditor"
}
