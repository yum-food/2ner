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

        //ifex _Detail_Maps_Enabled==0
        [HideInInspector] m_start_Detail_Maps("Detail maps", Float) = 0
          [ThryToggle(_DETAIL_MAPS)]_Detail_Maps_Enabled("Enable", Float) = 0
          _DetailMask("Mask", 2D) = "white" {}
          _DetailAlbedoMap("Base color", 2D) = "white" {}
          [Normal]_DetailNormalMap("Normals", 2D) = "bump" {}
          _DetailNormalMapScale("Normal intensity", Range(0, 10)) = 1
          [HideInInspector] m_end_Detail_Maps("Detail maps", Float) = 0
        //endex

      //ifex _Metallics_Enabled==0
      [HideInInspector] m_reflectionOptions("Reflections", Float) = 0
      [HideInInspector] m_start_Metallic("Metallics", Float) = 0
        [ThryToggle(_METALLICS)]_Metallics_Enabled("Enable", Float) = 0
        _Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
      [HideInInspector] m_end_Metallic("Metallics", Float) = 0
      //endex

      //ifex _Clearcoat_Enabled==0
      [HideInInspector] m_start_Clearcoat("Clearcoat", Float) = 0
        [ThryToggle(_CLEARCOAT)]_Clearcoat_Enabled("Enable", Float) = 0
        _Clearcoat_Strength("Strength", Range(0, 1)) = 1
        _Clearcoat_Roughness("Roughness", Range(0.089, 1)) = 0.089
      [HideInInspector] m_end_Clearcoat("Clearcoat", Float) = 0
      //endex

      [HideInInspector] m_gimmicks("Gimmicks", Float) = 0
        //ifex _Outlines_Enabled==0
        [HideInInspector] m_start_Outlines("Outlines", Float) = 0
        [ThryToggle(_OUTLINES)]_Outlines_Enabled("Enable", Float) = 0
        _Outlines_Enabled_Dynamic("Enable (dynamic)", Float) = 1
        _Outline_Color("Color", Color) = (0, 0, 0, 1)
        _Outline_Emission("Emission strength", Range(0, 10)) = 0
        _Outline_Width("Width", Float) = 0.01
          [HideInInspector] m_start_OutlinesMask("Mask", Float) = 0
          [ThryToggle(_OUTLINE_MASK)]_Outline_Mask_Enabled("Enable", Float) = 0
          _Outline_Mask("Thickness mask", 2D) = "white" {}
          _Outline_Mask_Invert("Invert", Float) = 0
          [HideInInspector] m_end_OutlinesMask("Mask", Float) = 0
        [HideInInspector] m_end_Outlines("Outlines", Float) = 0
        //endex

        [HideInInspector] m_start_Matcaps("Matcaps", Float) = 0
          //ifex _Matcap0_Enabled==0
          [HideInInspector] m_start_Matcap0("Matcap 0", Float) = 0
          [ThryToggle(_MATCAP0)]_Matcap0_Enabled("Enable", Float) = 0
          _Matcap0("Matcap", 2D) = "white" {}
          [Toggle(_)]_Matcap0_Invert("Invert", Float) = 0
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Matcap0_Mode("Mode", Int) = 0
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Matcap0_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
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
          [HideInInspector] m_end_Matcap0("Matcap 0", Float) = 0
          //endex
          //ifex _Matcap1_Enabled==0
          [HideInInspector] m_start_Matcap1("Matcap 1", Float) = 0
          [ThryToggle(_MATCAP1)]_Matcap1_Enabled("Enable", Float) = 0
          _Matcap1("Matcap", 2D) = "white" {}
          [Toggle(_)]_Matcap1_Invert("Invert", Float) = 0
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Matcap1_Mode("Mode", Int) = 0
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Matcap1_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
          _Matcap1_Strength("Strength", Float) = 1
            //ifex _Matcap1_Mask_Enabled==0
            [HideInInspector] m_start_Matcap1_Mask("Mask", Float) = 0
            [ThryToggle(_MATCAP1_MASK)]_Matcap1_Mask_Enabled("Enable", Float) = 0
            _Matcap1_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Matcap1_Mask("Mask", Float) = 0
            //endex
            //ifex _Matcap1_Quantization_Enabled==0
            [HideInInspector] m_start_Matcap1_Quantization("Quantization", Float) = 0
            [ThryToggle(_MATCAP1_QUANTIZATION)]_Matcap1_Quantization_Enabled("Enable", Float) = 0
            _Matcap1_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Matcap1_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Matcap1("Matcap 1", Float) = 0
          //endex
        [HideInInspector] m_end_Matcaps("Matcaps", Float) = 0

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
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Rim_Lighting0_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
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
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Rim_Lighting1_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
            //ifex _Rim_Lighting1_Mask_Enabled==0
            [HideInInspector] m_start_Rim_Lighting1_Mask("Mask", Float) = 0
            [ThryToggle(_RIM_LIGHTING1_MASK)]_Rim_Lighting1_Mask_Enabled("Enable", Float) = 0
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
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Rim_Lighting2_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
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
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Rim_Lighting3_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
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

        [HideInInspector] m_start_Decals("Decals", Float) = 0
          //ifex _Decal0_Enabled==0
          [HideInInspector] m_start_Decal0("Decal 0", Float) = 0
            [ThryToggle(_DECAL0)] _Decal0_Enabled("Enable", Float) = 0
            _Decal0_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal0_MainTex("Base color", 2D) = "white" {}
            _Decal0_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal0_Angle("Angle", Range(0, 1)) = 0.0
            _Decal0_UV_Channel("UV channel", Range(0, 3)) = 0
            [ThryToggle(_DECAL0_TILING_MODE)] _Decal0_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL0_REPLACE_ALPHA)] _Decal0_Replace_Alpha_Mode("Replace alpha", Float) = 0
            //ifex _Decal0_Normal_Enabled==0
            [HideInInspector] m_start_Decal0_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL0_NORMAL)] _Decal0_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal0_Normal("Normal", 2D) = "bump" {}
              _Decal0_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal0_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal0_Reflections_Enabled==0
            [HideInInspector] m_start_Decal0_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL0_REFLECTIONS)] _Decal0_Reflections_Enabled("Enable", Float) = 0
              _Decal0_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal0_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal0_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal0_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal0_SDF_Enabled==0
            [HideInInspector] m_start_Decal0_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL0_SDF)] _Decal0_SDF_Enabled("Enable", Float) = 0
              _Decal0_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal0_SDF_Invert("SDF invert", Float) = 0
              _Decal0_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal0_SDF_Px_Range("SDF px range", Float) = 2
            [HideInInspector] m_end_Decal0_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal0_Mask_Enabled==0
            [HideInInspector] m_start_Decal0_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL0_MASK)] _Decal0_Mask_Enabled("Enable", Float) = 0
              _Decal0_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal0_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal0("Decal 0", Float) = 0
          //endex
          //ifex _Decal1_Enabled==0
          [HideInInspector] m_start_Decal1("Decal 1", Float) = 0
            [ThryToggle(_DECAL1)] _Decal1_Enabled("Enable", Float) = 0
            _Decal1_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal1_MainTex("Base color", 2D) = "white" {}
            _Decal1_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal1_Angle("Angle", Range(0, 1)) = 0.0
            _Decal1_UV_Channel("UV channel", Range(0, 3)) = 0
            [ThryToggle(_DECAL1_TILING_MODE)] _Decal1_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL1_REPLACE_ALPHA)] _Decal1_Replace_Alpha_Mode("Replace alpha", Float) = 0
            //ifex _Decal1_Normal_Enabled==0
            [HideInInspector] m_start_Decal1_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL1_NORMAL)] _Decal1_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal1_Normal("Normal", 2D) = "bump" {}
              _Decal1_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal1_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal1_Reflections_Enabled==0
            [HideInInspector] m_start_Decal1_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL1_REFLECTIONS)] _Decal1_Reflections_Enabled("Enable", Float) = 0
              _Decal1_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal1_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal1_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal1_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal1_SDF_Enabled==0
            [HideInInspector] m_start_Decal1_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL1_SDF)] _Decal1_SDF_Enabled("Enable", Float) = 0
              _Decal1_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal1_SDF_Invert("SDF invert", Float) = 0
              _Decal1_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal1_SDF_Px_Range("SDF px range", Float) = 2
            [HideInInspector] m_end_Decal1_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal1_Mask_Enabled==0
            [HideInInspector] m_start_Decal1_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL1_MASK)] _Decal1_Mask_Enabled("Enable", Float) = 0
              _Decal1_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal1_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal1("Decal 1", Float) = 0
          //endex
          //ifex _Decal2_Enabled==0
          [HideInInspector] m_start_Decal2("Decal 2", Float) = 0
            [ThryToggle(_DECAL2)] _Decal2_Enabled("Enable", Float) = 0
            _Decal2_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal2_MainTex("Base color", 2D) = "white" {}
            _Decal2_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal2_Angle("Angle", Range(0, 1)) = 0.0
            _Decal2_UV_Channel("UV channel", Range(0, 3)) = 0
            [ThryToggle(_DECAL2_TILING_MODE)] _Decal2_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL2_REPLACE_ALPHA)] _Decal2_Replace_Alpha_Mode("Replace alpha", Float) = 0
            //ifex _Decal2_Normal_Enabled==0
            [HideInInspector] m_start_Decal2_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL2_NORMAL)] _Decal2_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal2_Normal("Normal", 2D) = "bump" {}
              _Decal2_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal2_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal2_Reflections_Enabled==0
            [HideInInspector] m_start_Decal2_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL2_REFLECTIONS)] _Decal2_Reflections_Enabled("Enable", Float) = 0
              _Decal2_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal2_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal2_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal2_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal2_SDF_Enabled==0
            [HideInInspector] m_start_Decal2_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL2_SDF)] _Decal2_SDF_Enabled("Enable", Float) = 0
              _Decal2_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal2_SDF_Invert("SDF invert", Float) = 0
              _Decal2_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal2_SDF_Px_Range("SDF px range", Float) = 2
            [HideInInspector] m_end_Decal2_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal2_Mask_Enabled==0
            [HideInInspector] m_start_Decal2_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL2_MASK)] _Decal2_Mask_Enabled("Enable", Float) = 0
              _Decal2_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal2_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal2("Decal 2", Float) = 0
          //endex
          //ifex _Decal3_Enabled==0
          [HideInInspector] m_start_Decal3("Decal 3", Float) = 0
            [ThryToggle(_DECAL3)] _Decal3_Enabled("Enable", Float) = 0
            _Decal3_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal3_MainTex("Base color", 2D) = "white" {}
            _Decal3_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal3_Angle("Angle", Range(0, 1)) = 0.0
            _Decal3_UV_Channel("UV channel", Range(0, 3)) = 0
            [ThryToggle(_DECAL3_TILING_MODE)] _Decal3_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL3_REPLACE_ALPHA)] _Decal3_Replace_Alpha_Mode("Replace alpha", Float) = 0
            //ifex _Decal3_Normal_Enabled==0
            [HideInInspector] m_start_Decal3_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL3_NORMAL)] _Decal3_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal3_Normal("Normal", 2D) = "bump" {}
              _Decal3_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal3_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal3_Reflections_Enabled==0
            [HideInInspector] m_start_Decal3_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL3_REFLECTIONS)] _Decal3_Reflections_Enabled("Enable", Float) = 0
              _Decal3_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal3_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal3_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal3_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal3_SDF_Enabled==0
            [HideInInspector] m_start_Decal3_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL3_SDF)] _Decal3_SDF_Enabled("Enable", Float) = 0
              _Decal3_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal3_SDF_Invert("SDF invert", Float) = 0
              _Decal3_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal3_SDF_Px_Range("SDF px range", Float) = 2
            [HideInInspector] m_end_Decal3_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal3_Mask_Enabled==0
            [HideInInspector] m_start_Decal3_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL3_MASK)] _Decal3_Mask_Enabled("Enable", Float) = 0
              _Decal3_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal3_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal3("Decal 3", Float) = 0
          //endex
        [HideInInspector] m_end_Decals("Decals", Float) = 0

        //ifex _3D_SDF_Enabled==0
        [HideInInspector] m_start_3D_SDF("3D SDF", Float) = 0
          [ThryToggle(_3D_SDF)] _3D_SDF_Enabled("Enable", Float) = 0
          _3D_SDF_Texture("Texture", 3D) = "white" {}
          _3D_SDF_Thresholds("Thresholds", Vector) = (0.2, 0.4, 0.6, 0.8)
          _3D_SDF_Color_0("Color 0", Color) = (1, 0, 0, 1)
          _3D_SDF_Color_1("Color 1", Color) = (0, 1, 0, 1)
          _3D_SDF_Color_2("Color 2", Color) = (0, 0, 1, 1)
          _3D_SDF_Color_3("Color 3", Color) = (1, 1, 0, 1)
          _3D_SDF_Z("Z", Range(0, 1)) = 0
          _3D_SDF_Z_Speed("Z speed", Float) = 0
        [HideInInspector] m_end_3D_SDF("3D SDF", Float) = 0
        //endex

        //ifex _Face_Me_Enabled==0
        [HideInInspector] m_start_Face_Me("Face me", Float) = 0
          [ThryToggle(_FACE_ME)] _Face_Me_Enabled("Enable", Float) = 0
          [MaterialToggle] _Face_Me_Enabled_Dynamic("Enable dynamic", Float) = 0
          [HideInInspector] m_end_Face_Me("Face me", Float) = 0
        //endex

        //ifex _False_Color_Visualization_Enabled==0
        [HideInInspector] m_start_False_Color_Visualization("False color", Float) = 0
          [ThryToggle(_FALSE_COLOR_VISUALIZATION)] _False_Color_Visualization_Enabled("Enable", Float) = 0
          [MaterialToggle] _False_Color_Visualization_Luminance("Luminance", Float) = 0
          [MaterialToggle] _False_Color_Visualization_Luminance_Bounded("Luminance (bounded)", Float) = 0
        [HideInInspector] m_end_False_Color_Visualization("False color", Float) = 0
        //endex

        //ifex _Letter_Grid_Enabled==0
        [HideInInspector] m_start_Letter_Grid("Letter grid", Float) = 0
          [ThryToggle(_LETTER_GRID)] _Letter_Grid_Enabled("Enable", Float) = 0
          _Letter_Grid_Texture("Glyph texture", 2D) = "black" {}
          _Letter_Grid_Tex_Res_X("Glyph X resolution", Float) = 16
          _Letter_Grid_Tex_Res_Y("Glyph Y resolution", Float) = 8
          _Letter_Grid_Res_X("Cell X resolution", Range(1, 4)) = 1
          _Letter_Grid_Res_Y("Cell Y resolution", Range(1, 4)) = 1
          _Letter_Grid_Data_Row_0("Cell data row 0", Vector) = (0, 0, 0, 0)
          _Letter_Grid_Data_Row_1("Cell data row 1", Vector) = (0, 0, 0, 0)
          _Letter_Grid_Data_Row_2("Cell data row 2", Vector) = (0, 0, 0, 0)
          _Letter_Grid_Data_Row_3("Cell data row 3", Vector) = (0, 0, 0, 0)
          _Letter_Grid_UV_Scale_Offset("UV scale/offset", Vector) = (1, 1, 0, 0)
          _Letter_Grid_Padding("Padding", Float) = 0.02
          _Letter_Grid_Color("Color", Color) = (1, 1, 1, 1)
          _Letter_Grid_Metallic("Metallic", Range(0, 1)) = 0
          _Letter_Grid_Roughness("Roughness", Range(0 ,1)) = 0.5
          _Letter_Grid_Emission("Emission", Range(0 ,1)) = 0.0
          _Letter_Grid_Mask("Mask", 2D) = "white" {}
          _Letter_Grid_Global_Offset("Global offset", Float) = 0
          _Letter_Grid_Screen_Px_Range("Screen px range (from msdfgen)", Float) = 10
          _Letter_Grid_Min_Screen_Px_Range("Minimum screen px range", Float) = 1
          _Letter_Grid_Blurriness("Blurriness", Float) = 0.5
          _Letter_Grid_Alpha_Threshold("Alpha threshold", Range(0, 1)) = 0.5
        [HideInInspector] m_end_Letter_Grid("Letter grid", Float) = 0
        //endex

        //ifex _Shatter_Wave_Enabled==0
        [HideInInspector] m_start_Shatter_Wave("Shatter wave", Float) = 0
          [ThryToggle(_SHATTER_WAVE)] _Shatter_Wave_Enabled("Enable", Float) = 0
          _Shatter_Wave_Amplitude("Amplitude", Vector) = (0.4, 0.4, 0.4, 0.4)
          _Shatter_Wave_Wavelength("Wavelength", Vector) = (1, 1, 1, 1)
          _Shatter_Wave_Speed("Speed", Vector) = (30, 30, 30, 30)
          _Shatter_Wave_Period("Period", Vector) = (4, 4, 4, 4)
          _Shatter_Wave_Time_Offset("Time offset", Vector) = (0, 0, 0, 0)
          _Shatter_Wave_Power("Power", Vector) = (5, 5, 5, 5)
          _Shatter_Wave_Direction0("Direction (wave 0)", Vector) = (0, 1, 0)
          _Shatter_Wave_Direction1("Direction (wave 1)", Vector) = (0, 1, 0)
          _Shatter_Wave_Direction2("Direction (wave 2)", Vector) = (0, 1, 0)
          _Shatter_Wave_Direction3("Direction (wave 3)", Vector) = (0, 1, 0)
          [HideInInspector] m_start_Shatter_Wave_Audiolink("Audiolink", Float) = 0
            [ThryToggle(_SHATTER_WAVE_AUDIOLINK)] _Shatter_Wave_Audiolink_Enabled("Enable", Float) = 0
            _Shatter_Wave_Chronotensity_Weights0("Chronotensity weights (band 0)", Vector) = (0, 0, 0, 0)
            _Shatter_Wave_Chronotensity_Weights1("Chronotensity weights (band 1)", Vector) = (0, 0, 0, 0)
            _Shatter_Wave_Chronotensity_Weights2("Chronotensity weights (band 2)", Vector) = (0, 0, 0, 0)
            _Shatter_Wave_Chronotensity_Weights3("Chronotensity weights (band 3)", Vector) = (0, 0, 0, 0)
            _Shatter_Wave_Chronotensity_Time_Factor("Chronotensity time factor", Vector) = (1, 1, 1, 1)
          [HideInInspector] m_end_Shatter_Wave_Audiolink("Audiolink", Float) = 0
          [HideInInspector] m_start_Shatter_Wave_Rotation("Rotation", Float) = 0
            [ThryToggle(_SHATTER_WAVE_ROTATION)] _Shatter_Wave_Rotation_Enabled("Enable", Float) = 0
            _Shatter_Wave_Rotation_Strength("Strength", Vector) = (1.0, 1.0, 1.0, 1.0)
          [HideInInspector] m_end_Shatter_Wave_Rotation("Rotation", Float) = 0
        [HideInInspector] m_end_Shatter_Wave("Shatter wave", Float) = 0
        //endex

        //ifex _Mirror_UVs_In_Mirror_Enabled==0
        [HideInInspector] m_start_Mirror_UVs_In_Mirror("Mirror UVs in mirror", Float) = 0
          [ThryToggle(_MIRROR_UVS_IN_MIRROR)] _Mirror_UVs_In_Mirror_Enabled("Enable", Float) = 0
        [HideInInspector] m_end_Mirror_UVs_In_Mirror("Mirror UVs in mirror", Float) = 0
        //endex

        //ifex _Tessellation_Enabled==0
        [HideInInspector] m_start_Tessellation("Tessellation", Float) = 0
          [ThryToggle(_TESSELLATION)] _Tessellation_Enabled("Enable", Float) = 0
          _Tessellation_Factor("Factor", Range(1, 64)) = 1
          [HideInInspector] m_start_Tessellation_Heightmap("Heightmap", Float) = 0
            [ThryToggle(_TESSELLATION_HEIGHTMAP)] _Tessellation_Heightmap_Enabled("Enable", Float) = 0
            _Tessellation_Heightmap("Heightmap", 2D) = "black" {}
            _Tessellation_Heightmap_Scale("Scale", Float) = 1
            _Tessellation_Heightmap_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_Direction_Control("Direction control", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)] _Tessellation_Heightmap_Direction_Control_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_Direction_Control_Vector("Direction (normal/tangent/binormal)", Vector) = (1, 0, 0)
            [HideInInspector] m_end_Tessellation_Heightmap_Direction_Control("Direction control", Float) = 0
          [HideInInspector] m_end_Tessellation_Heightmap("Heightmap", Float) = 0
          [HideInInspector] m_start_Tessellation_Range_Factor("Range-based factor", Float) = 0
            [ThryToggle(_TESSELLATION_RANGE_FACTOR)] _Tessellation_Range_Factor_Enabled("Enable", Float) = 0
            [Helpbox]_Tessellation_Range_Factor_Help("All distances are given in squared meters. For example, to set the far distance to 4 meters, enter 16.", Int) = 0
            _Tessellation_Range_Factor_Distance_Near("Distance (near)", Float) = 1
            _Tessellation_Range_Factor_Factor_Near("Factor (near)", Float) = 1
            _Tessellation_Range_Factor_Distance_Far("Distance (far)", Float) = 1
            _Tessellation_Range_Factor_Factor_Far("Factor (far)", Float) = 1
          [HideInInspector] m_end_Tessellation_Range_Factor("Range-based factor", Float) = 0
          // Shit for thry
          [HideInInspector] Tessellation_Enabled("Enabled", Float) = 1
          [HideInInspector] Tessellation_EnabledForwardBase("Enabled (ForwardBase)", Float) = 1
          [HideInInspector] Tessellation_EnabledForwardAdd("Enabled (ForwardAdd)", Float) = 1
          [HideInInspector] Tessellation_EnabledShadowCaster("Enabled (ShadowCaster)", Float) = 1
        [HideInInspector] m_end_Tessellation("Tessellation", Float) = 0
        //endex

        //ifex _Spherize_Enabled==0
        [HideInInspector] m_start_Spherize("Spherize", Float) = 0
          [ThryToggle(_SPHERIZE)] _Spherize_Enabled("Enable", Float) = 0
          _Spherize_Radius("Radius", Float) = 1
          _Spherize_Strength("Strength", Range(0, 1)) = 1
        [HideInInspector] m_end_Spherize("Spherize", Float) = 0
        //endex

        //ifex _Vertex_Domain_Warping_Enabled==0
        [HideInInspector] m_start_Vertex_Domain_Warping("Vertex domain warping", Float) = 0
          [ThryToggle(_VERTEX_DOMAIN_WARPING)] _Vertex_Domain_Warping_Enabled("Enable", Float) = 0
          _Vertex_Domain_Warping_Noise("Noise", 3D) = "black" {}
          _Vertex_Domain_Warping_Strength("Strength", Float) = 0.10
          _Vertex_Domain_Warping_Scale("Scale", Float) = 1.0
          _Vertex_Domain_Warping_Octaves("Octaves", Float) = 1.0
          _Vertex_Domain_Warping_Speed("Speed", Float) = 1.0
          //ifex _Vertex_Domain_Warping_Audiolink_Enabled==0
          [HideInInspector] m_start_Vertex_Domain_Warping_Audiolink("Audiolink", Float) = 0
            [ThryToggle(_VERTEX_DOMAIN_WARPING_AUDIOLINK)] _Vertex_Domain_Warping_Audiolink_Enabled("Enable", Float) = 0
            _Vertex_Domain_Warping_Audiolink_VU_Strength_Factor("VU strength factor", Float) = 1.0
            _Vertex_Domain_Warping_Audiolink_VU_Scale_Factor("VU scale factor", Float) = 1.0
          [HideInInspector] m_end_Vertex_Domain_Warping_Audiolink("Audiolink", Float) = 0
          //endex
        [HideInInspector] m_end_Vertex_Domain_Warping("Vertex domain warping", Float) = 0
        //endex

        //ifex _UV_Domain_Warping_Enabled==0
        [HideInInspector] m_start_UV_Domain_Warping("UV domain warping", Float) = 0
          [ThryToggle(_UV_DOMAIN_WARPING)]_UV_Domain_Warping_Enabled("Enable", Float) = 0
          _UV_Domain_Warping_Noise("Noise", 2D) = "black" {}
          _UV_Domain_Warping_Spatial_Strength("Spatial warping strength", Float) = 0.10
          _UV_Domain_Warping_Spatial_Scale("Spatial warping scale", Float) = 0.10
          _UV_Domain_Warping_Spatial_Octaves("Spatial warping octaves", Float) = 1.0
          _UV_Domain_Warping_Spatial_Speed("Spatial warping speed", Float) = 1.0
          _UV_Domain_Warping_Spatial_Direction("Spatial warping direction", Vector) = (1.0, 1.0, 0.0, 0.0)
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

        //ifex _Harnack_Tracing_Enabled==0
        [HideInInspector] m_start_Harnack_Tracing("Harnack tracing", Float) = 0
          [ThryToggle(_HARNACK_TRACING)] _Harnack_Tracing_Enabled("Enable", Float) = 0
          [HideInInspector] m_start_Harnack_Tracing_Gyroid("Gyroid", Float) = 0
            [ThryToggle(_HARNACK_TRACING_GYROID)] _Harnack_Tracing_Gyroid_Enabled("Enable", Float) = 0
            _Harnack_Tracing_Gyroid_Speed("Speed", Float) = 0.0
            _Harnack_Tracing_Gyroid_Scale("Scale", Float) = 10.0
          [HideInInspector] m_end_Harnack_Tracing_Gyroid("Gyroid", Float) = 0
        [HideInInspector] m_end_Harnack_Tracing("Harnack tracing", Float) = 0
        //endex

        //ifex _Masked_Stencil1_Enabled==0
        [HideInInspector] m_start_Masked_Stencil1("Masked stencil 1", Float) = 0
          [ThryToggle(_)] _Masked_Stencil1_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _Stencil1Type ("Stencil Type", Float) = 0
          _Masked_Stencil1_Mask("Mask", 2D) = "white" {}
          [IntRange] _MaskedStencil1Ref ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _MaskedStencil1ReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _MaskedStencil1WriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1PassOp ("Stencil Pass Op--{condition_showS:(_Stencil1Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1FailOp ("Stencil Fail Op--{condition_showS:(_Stencil1Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1ZFailOp ("Stencil ZFail Op--{condition_showS:(_Stencil1Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil1CompareFunction ("Stencil Compare Function--{condition_showS:(_Stencil1Type==0)}", Float) = 8
          [HideInInspector] m_start_MaskedStencil1PassBackOptions("Back--{condition_showS:(_Stencil1Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1BackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1BackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1BackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil1BackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil1PassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_MaskedStencil1PassFrontOptions("Front--{condition_showS:(_Stencil1Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1FrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1FrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil1FrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil1FrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil1PassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Masked_Stencil1("Masked stencil 1", Float) = 0
        //endex

        //ifex _Masked_Stencil2_Enabled==0
        [HideInInspector] m_start_Masked_Stencil2("Masked stencil 2", Float) = 0
          [ThryToggle(_)] _Masked_Stencil2_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _Stencil2Type ("Stencil Type", Float) = 0
          _Masked_Stencil2_Mask("Mask", 2D) = "white" {}
          [IntRange] _MaskedStencil2Ref ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _MaskedStencil2ReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _MaskedStencil2WriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2PassOp ("Stencil Pass Op--{condition_showS:(_Stencil2Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2FailOp ("Stencil Fail Op--{condition_showS:(_Stencil2Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2ZFailOp ("Stencil ZFail Op--{condition_showS:(_Stencil2Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil2CompareFunction ("Stencil Compare Function--{condition_showS:(_Stencil2Type==0)}", Float) = 8
          [HideInInspector] m_start_MaskedStencil2PassBackOptions("Back--{condition_showS:(_Stencil2Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2BackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2BackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2BackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil2BackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil2PassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_MaskedStencil2PassFrontOptions("Front--{condition_showS:(_Stencil2Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2FrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2FrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil2FrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil2FrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil2PassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Masked_Stencil2("Masked stencil 2", Float) = 0
        //endex

        //ifex _Masked_Stencil3_Enabled==0
        [HideInInspector] m_start_Masked_Stencil3("Masked stencil 3", Float) = 0
          [ThryToggle(_)] _Masked_Stencil3_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _Stencil3Type ("Stencil Type", Float) = 0
          _Masked_Stencil3_Mask("Mask", 2D) = "white" {}
          [IntRange] _MaskedStencil3Ref ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _MaskedStencil3ReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _MaskedStencil3WriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3PassOp ("Stencil Pass Op--{condition_showS:(_Stencil3Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3FailOp ("Stencil Fail Op--{condition_showS:(_Stencil3Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3ZFailOp ("Stencil ZFail Op--{condition_showS:(_Stencil3Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil3CompareFunction ("Stencil Compare Function--{condition_showS:(_Stencil3Type==0)}", Float) = 8
          [HideInInspector] m_start_MaskedStencil3PassBackOptions("Back--{condition_showS:(_Stencil3Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3BackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3BackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3BackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil3BackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil3PassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_MaskedStencil3PassFrontOptions("Front--{condition_showS:(_Stencil3Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3FrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3FrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil3FrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil3FrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil3PassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Masked_Stencil3("Masked stencil 3", Float) = 0
        //endex

        //ifex _Masked_Stencil4_Enabled==0
        [HideInInspector] m_start_Masked_Stencil4("Masked stencil 4", Float) = 0
          [ThryToggle(_)] _Masked_Stencil4_Enabled("Enable", Float) = 0
          [ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _Stencil4Type ("Stencil Type", Float) = 0
          _Masked_Stencil4_Mask("Mask", 2D) = "white" {}
          [IntRange] _MaskedStencil4Ref ("Stencil Reference Value", Range(0, 255)) = 0
          [IntRange] _MaskedStencil4ReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
          [IntRange] _MaskedStencil4WriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4PassOp ("Stencil Pass Op--{condition_showS:(_Stencil4Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4FailOp ("Stencil Fail Op--{condition_showS:(_Stencil4Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4ZFailOp ("Stencil ZFail Op--{condition_showS:(_Stencil4Type==0)}", Float) = 0
          [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil4CompareFunction ("Stencil Compare Function--{condition_showS:(_Stencil4Type==0)}", Float) = 8
          [HideInInspector] m_start_MaskedStencil4PassBackOptions("Back--{condition_showS:(_Stencil4Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4BackPassOp ("Back Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4BackFailOp ("Back Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4BackZFailOp ("Back ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil4BackCompareFunction ("Back Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil4PassBackOptions("Back", Float) = 0
          [HideInInspector] m_start_MaskedStencil4PassFrontOptions("Front--{condition_showS:(_Stencil4Type==1)}", Float) = 0
            [Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4FrontPassOp ("Front Pass Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4FrontFailOp ("Front Fail Op", Float) = 0
            [Enum(UnityEngine.Rendering.StencilOp)] _MaskedStencil4FrontZFailOp ("Front ZFail Op", Float) = 0
            [Enum(UnityEngine.Rendering.CompareFunction)] _MaskedStencil4FrontCompareFunction ("Front Compare Function", Float) = 8
          [HideInInspector] m_end_MaskedStencil4PassFrontOptions("Front", Float) = 0
        [HideInInspector] m_end_Masked_Stencil4("Masked stencil 4", Float) = 0
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

        //ifex _Glitter_Enabled==0
        [HideInInspector] m_start_Glitter("Glitter", Float) = 0
          [ThryToggle(_GLITTER)] _Glitter_Enabled("Enable", Float) = 0
          [HDR] _Glitter_Color("Color", Color) = (1, 1, 1, 1)
          _Glitter_Emission("Emission", Color) = (1, 1, 1, 1)
          _Glitter_Layers("Layers", Range(1, 5)) = 1
          _Glitter_Grid_Size("Grid size", Float) = 1
          _Glitter_Size("Size", Range(0, 1)) = 1
          _Glitter_Major_Minor_Ratio("Major/minor ratio", Range(0, 1)) = 1
          _Glitter_Angle_Randomization_Range("Angle randomization", Range(0, 1)) = 1
          _Glitter_Center_Randomization_Range("Center randomization", Range(0, 1)) = 1
          _Glitter_Size_Randomization_Range("Size randomization", Range(0, 1)) = 0.4
          _Glitter_Existence_Chance("Existence chance", Range(0, 1)) = 0.1
          //ifex _Glitter_Angle_Limit_Enabled==0
          [HideInInspector] m_start_Glitter_Angle_Limit("Angle limit", Float) = 0
            [ThryToggle(_GLITTER_ANGLE_LIMIT)] _Glitter_Angle_Limit_Enabled("Enable", Float) = 0
            _Glitter_Angle_Limit("Limit", Range(0.001, 1)) = 1
            _Glitter_Angle_Limit_Transition_Width("Transition width", Range(0, 1)) = 0.1
          [HideInInspector] m_end_Glitter_Angle_Limit("Angle limit", Float) = 0
          //endex
          //ifex _Glitter_Mask_Enabled==0
          [HideInInspector] m_start_Glitter_Mask("Mask", Float) = 0
            [ThryToggle(_GLITTER_MASK)] _Glitter_Mask_Enabled("Enable", Float) = 0
            _Glitter_Mask("Mask", 2D) = "white" {}
          [HideInInspector] m_end_Glitter_Mask("Mask", Float) = 0
          //endex
        [HideInInspector] m_end_Glitter("Glitter", Float) = 0
        //endex

      [HideInInspector] m_lightingOptions("Lighting Options", Float) = 0
        //ifex _Fallback_Cubemap_Enabled==0
        [HideInInspector] m_start_Fallback_Cubemap("Fallback Cubemap", Float) = 0
          [ThryToggle(_FALLBACK_CUBEMAP)] _Fallback_Cubemap_Enabled("Enable", Float) = 0
          [MaterialToggle] _Fallback_Cubemap_Force("Force", Float) = 0
          _Fallback_Cubemap("Cubemap", Cube) = "" {}
          _Fallback_Cubemap_Brightness("Brightness", Float) = 1.0
          [HideInInspector] m_start_Fallback_Cubemap_Limit_Metallic("Limit override to metallic", Float) = 0
            [ThryToggle(_FALLBACK_CUBEMAP_LIMIT_METALLIC)] _Fallback_Cubemap_Limit_Metallic("Enable", Float) = 0
          [HideInInspector] m_end_Fallback_Cubemap_Limit_Metallic("Limit override to metallic", Float) = 0
        [HideInInspector] m_end_Fallback_Cubemap("Fallback Cubemap", Float) = 0
        //endex
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
        //ifex _Brightness_Control_Enabled==0
        [HideInInspector] m_start_Brightness_Control("Brightness", Float) = 0
          [ThryToggle(_BRIGHTNESS_CONTROL)] _Brightness_Control_Enabled("Enable", Float) = 0
          _Brightness_Multiplier("Brightness multiplier", Float) = 1.0
        [HideInInspector] m_end_Brightness_Control("Brightness", Float) = 0
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
    //ifex _Material_Type_Cloth_Enabled==0
    [HideInInspector] m_start_Material_Type_Cloth("Cloth", Float) = 0
      [ThryToggle(_MATERIAL_TYPE_CLOTH)] _Material_Type_Cloth_Enabled("Enable", Float) = 0
      _Cloth_Mask("Mask", 2D) = "white" {}
      _Cloth_Sheen_Color("Sheen Color", Color) = (1, 1, 1, 1)
      _Cloth_Direct_Multiplier("Direct Multiplier", Range(0, 10)) = 1
      _Cloth_Indirect_Multiplier("Indirect Multiplier", Range(0, 10)) = 1
      [HideInInspector] m_start_Material_Type_Cloth_Subsurface("Subsurface", Float) = 0
        [ThryToggle(_MATERIAL_TYPE_CLOTH_SUBSURFACE)] _Material_Type_Cloth_Subsurface("Enable", Float) = 0
        _Cloth_Subsurface_Color("Subsurface Color", Color) = (1, 1, 1, 1)
      [HideInInspector] m_end_Material_Type_Cloth_Subsurface("Subsurface", Float) = 0
    [HideInInspector] m_end_Material_Type_Cloth("Cloth", Float) = 0
    //endex
    _specularAntiAliasingVariance("Specular AA variance", Float) = 0.15
    _specularAntiAliasingThreshold("Specular AA variance", Float) = 0.25
  }

  SubShader {
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "VRCFallback" = "Standard" }

    //ifex _Masked_Stencil1_Enabled==0
    Pass {
      Name "MASKEDSTENCIL1"
      Tags { "LightMode" = "ForwardBase" }
      //BlendOp [_BlendOp], [_BlendOpAlpha]
      //Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      //Cull [_Cull]
      ZWrite Off
      ZTest LEqual

			Stencil
			{
				Ref [_MaskedStencil1Ref]
				ReadMask [_MaskedStencil1ReadMask]
				WriteMask [_MaskedStencil1WriteMask]
				//ifex _Stencil1Type==1
				Comp [_MaskedStencil1CompareFunction]
				Pass [_MaskedStencil1PassOp]
				Fail [_MaskedStencil1FailOp]
				ZFail [_MaskedStencil1ZFailOp]
				//endex

				//ifex _Stencil1Type==0
				CompBack [_MaskedStencil1BackCompareFunction]
				PassBack [_MaskedStencil1BackPassOp]
				FailBack [_MaskedStencil1BackFailOp]
				ZFailBack [_MaskedStencil1BackZFailOp]

				CompFront [_MaskedStencil1FrontCompareFunction]
				PassFront [_MaskedStencil1FrontPassOp]
				FailFront [_MaskedStencil1FrontFailOp]
				ZFailFront [_MaskedStencil1FrontZFailOp]
				//endex
			}

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      #define MASKED_STENCIL1_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
    //ifex _Masked_Stencil2_Enabled==0
    Pass {
      Name "MASKEDSTENCIL2"
      Tags { "LightMode" = "ForwardBase" }
      //BlendOp [_BlendOp], [_BlendOpAlpha]
      //Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      //Cull [_Cull]
      ZWrite Off
      ZTest LEqual

			Stencil
			{
				Ref [_MaskedStencil2Ref]
				ReadMask [_MaskedStencil2ReadMask]
				WriteMask [_MaskedStencil2WriteMask]
				//ifex _Stencil2Type==1
				Comp [_MaskedStencil2CompareFunction]
				Pass [_MaskedStencil2PassOp]
				Fail [_MaskedStencil2FailOp]
				ZFail [_MaskedStencil2ZFailOp]
				//endex

				//ifex _Stencil2Type==0
				CompBack [_MaskedStencil2BackCompareFunction]
				PassBack [_MaskedStencil2BackPassOp]
				FailBack [_MaskedStencil2BackFailOp]
				ZFailBack [_MaskedStencil2BackZFailOp]

				CompFront [_MaskedStencil2FrontCompareFunction]
				PassFront [_MaskedStencil2FrontPassOp]
				FailFront [_MaskedStencil2FrontFailOp]
				ZFailFront [_MaskedStencil2FrontZFailOp]
				//endex
			}

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      #define MASKED_STENCIL2_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
    //ifex _Masked_Stencil3_Enabled==0
    Pass {
      Name "MASKEDSTENCIL3"
      Tags { "LightMode" = "ForwardBase" }
      //BlendOp [_BlendOp], [_BlendOpAlpha]
      //Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      //Cull [_Cull]
      ZWrite Off
      ZTest LEqual

			Stencil
			{
				Ref [_MaskedStencil3Ref]
				ReadMask [_MaskedStencil3ReadMask]
				WriteMask [_MaskedStencil3WriteMask]
				//ifex _Stencil3Type==1
				Comp [_MaskedStencil3CompareFunction]
				Pass [_MaskedStencil3PassOp]
				Fail [_MaskedStencil3FailOp]
				ZFail [_MaskedStencil3ZFailOp]
				//endex

				//ifex _Stencil3Type==0
				CompBack [_MaskedStencil3BackCompareFunction]
				PassBack [_MaskedStencil3BackPassOp]
				FailBack [_MaskedStencil3BackFailOp]
				ZFailBack [_MaskedStencil3BackZFailOp]

				CompFront [_MaskedStencil3FrontCompareFunction]
				PassFront [_MaskedStencil3FrontPassOp]
				FailFront [_MaskedStencil3FrontFailOp]
				ZFailFront [_MaskedStencil3FrontZFailOp]
				//endex
			}

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      #define MASKED_STENCIL3_PASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
    //ifex _Masked_Stencil4_Enabled==0
    Pass {
      Name "MASKEDSTENCIL4"
      Tags { "LightMode" = "ForwardBase" }
      //BlendOp [_BlendOp], [_BlendOpAlpha]
      //Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
      //Cull [_Cull]
      ZWrite Off
      ZTest LEqual

			Stencil
			{
				Ref [_MaskedStencil4Ref]
				ReadMask [_MaskedStencil4ReadMask]
				WriteMask [_MaskedStencil4WriteMask]
				//ifex _Stencil4Type==1
				Comp [_MaskedStencil4CompareFunction]
				Pass [_MaskedStencil4PassOp]
				Fail [_MaskedStencil4FailOp]
				ZFail [_MaskedStencil4ZFailOp]
				//endex

				//ifex _Stencil4Type==0
				CompBack [_MaskedStencil4BackCompareFunction]
				PassBack [_MaskedStencil4BackPassOp]
				FailBack [_MaskedStencil4BackFailOp]
				ZFailBack [_MaskedStencil4BackZFailOp]

				CompFront [_MaskedStencil4FrontCompareFunction]
				PassFront [_MaskedStencil4FrontPassOp]
				FailFront [_MaskedStencil4FrontFailOp]
				ZFailFront [_MaskedStencil4FrontZFailOp]
				//endex
			}

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      #define MASKED_STENCIL4_PASS

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
      #pragma multi_compile_fullshadows
      #pragma multi_compile_instancing
      #pragma multi_compile_fog
      #pragma vertex vert
      #pragma fragment frag

      //ifex _Tessellation_Enabled==0
      #pragma hull hull
      #pragma domain domain
      //endex

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

      //ifex _Tessellation_Enabled==0
      #pragma hull hull
      #pragma domain domain
      //endex

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
      #pragma multi_compile_fullshadows
      #pragma multi_compile_instancing
      #pragma multi_compile_fog
      #pragma vertex vert
      #pragma fragment frag

      //ifex _Tessellation_Enabled==0
      #pragma hull hull
      #pragma domain domain
      //endex

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

      //ifex _Tessellation_Enabled==0
      #pragma hull hull
      #pragma domain domain
      //endex

      #define SHADOW_CASTER_PASS

      #include "2ner.cginc"

      ENDCG
    }
  }
  CustomEditor "Thry.ShaderEditor"
}
