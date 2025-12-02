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
          _Detail_Maps_UV_Channel("UV channel", Range(0, 3.1)) = 0
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
        [ThryToggle(_CLEARCOAT_GEOMETRIC_NORMALS)]_Clearcoat_Geometric_Normals_Enabled("Use geometric normals", Float) = 1
        _Clearcoat_Mask("Mask", 2D) = "white" {}
        _Clearcoat_Strength("Strength", Range(0, 10)) = 1
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

        //ifex _Custom30_Enabled==0
        [HideInInspector] m_start_Custom30("Custom 30", Float) = 0
        [ThryToggle(_CUSTOM30)]_Custom30_Enabled("Enable", Float) = 0

        _Custom30_ro_Offset("ro offset", Float) = 0.0
        _Custom30_Quaternion_UV_Channel_0("Quaternion UV Channel 0", Float) = 2
        _Custom30_Quaternion_UV_Channel_1("Quaternion UV Channel 1", Float) = 3

        //ifex _Custom30_BasicCube_Enabled==0
        [HideInInspector] m_start_Custom30_BasicCube("Basic cube", Float) = 0
        [ThryToggle(_CUSTOM30_BASICCUBE)]_Custom30_BasicCube_Enabled("Enable", Float) = 0
        [ThryToggle(_CUSTOM30_BASICCUBE_HEX_GRIP)]_Custom30_BasicCube_Hex_Grip("Hex grip", Float) = 0
        [ThryToggle(_CUSTOM30_BASICCUBE_HEX_BOLTS)]_Custom30_BasicCube_Hex_Bolts("Hex bolts", Float) = 0
        [ThryToggle(_CUSTOM30_BASICCUBE_CHAMFER)]_Custom30_BasicCube_Chamfer("Chamfer", Float) = 0
        [HideInInspector] m_end_Custom30_BasicCube("Basic cube", Float) = 0
        //endex

        //ifex _Custom30_BasicWedge_Enabled==0
        [HideInInspector] m_start_Custom30_BasicWedge("Basic wedge", Float) = 0
        [ThryToggle(_CUSTOM30_BASICWEDGE)]_Custom30_BasicWedge_Enabled("Enable", Float) = 0
        [HideInInspector] m_end_Custom30_BasicWedge("Basic wedge", Float) = 0
        //endex

        //ifex _Custom30_BasicPlatform_Enabled==0
        [HideInInspector] m_start_Custom30_BasicPlatform("Basic platform", Float) = 0
        [ThryToggle(_CUSTOM30_BASICPLATFORM)]_Custom30_BasicPlatform_Enabled("Enable", Float) = 0
        _Custom30_BasicPlatform_Size("Size", Vector) = (1.0, 0.4, 0.2)
        _Custom30_BasicPlatform_Frame_D("Frame dimension", Float) = 0.08
        _Custom30_BasicPlatform_Core_D("Core dimension", Float) = 0.05
        [ThryToggle(_CUSTOM30_BASICPLATFORM_CHAMFER)]_Custom30_BasicPlatform_Chamfer("Chamfer", Float) = 0
        _Custom30_BasicPlatform_Chamfer_Size("Size", Vector) = (0.36, 0.78, 0.9)
        [ThryToggle(_CUSTOM30_BASICPLATFORM_Y_ALIGNED)]_Custom30_BasicPlatform_Y_Aligned("Y aligned", Float) = 0
        [ThryToggle(_CUSTOM30_BASICPLATFORM_VERTICAL)]_Custom30_BasicPlatform_Vertical("Vertical", Float) = 0
        [HideInInspector] m_end_Custom30_BasicPlatform("Basic platform", Float) = 0
        //endex

        //ifex _Custom30_Rainbow_Enabled==0
        [HideInInspector] m_start_Custom30_Rainbow("Rainbow", Float) = 0
        [ThryToggle(_CUSTOM30_RAINBOW)]_Custom30_Rainbow_Enabled("Enable", Float) = 0
        [HideInInspector] m_end_Custom30_Rainbow("Rainbow", Float) = 0
        //endex

        [HideInInspector] m_end_Custom30("Custom 30", Float) = 0
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
          //ifex _Matcap2_Enabled==0
          [HideInInspector] m_start_Matcap2("Matcap 2", Float) = 0
          [ThryToggle(_MATCAP2)]_Matcap2_Enabled("Enable", Float) = 0
          _Matcap2("Matcap", 2D) = "white" {}
          [Toggle(_)]_Matcap2_Invert("Invert", Float) = 0
          [ThryWideEnum(Replace, 0, Add, 1, Multiply, 2, Subtract, 3, AddProduct, 4)]
          _Matcap2_Mode("Mode", Int) = 0
          [ThryWideEnum(_0000b, 0, _0001b, 1, _0010b, 2, _0011b, 3, _0100b, 4, _0101b, 5, _0110b, 6, _0111b, 7, _1000b, 8, _1001b, 9, _1010b, 10, _1011b, 11, _1100b, 12, _1101b, 13, _1110b, 14, _1111b, 15)]
          _Matcap2_Target_Mask("Target mask (albedo|diffuse<<1|specular<<2)", Int) = 1
          _Matcap2_Strength("Strength", Float) = 1
            //ifex _Matcap2_Mask_Enabled==0
            [HideInInspector] m_start_Matcap2_Mask("Mask", Float) = 0
            [ThryToggle(_MATCAP2_MASK)]_Matcap2_Mask_Enabled("Enable", Float) = 0
            _Matcap2_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Matcap2_Mask("Mask", Float) = 0
            //endex
            //ifex _Matcap2_Quantization_Enabled==0
            [HideInInspector] m_start_Matcap2_Quantization("Quantization", Float) = 0
            [ThryToggle(_MATCAP2_QUANTIZATION)]_Matcap2_Quantization_Enabled("Enable", Float) = 0
            _Matcap2_Quantization_Steps("Steps", Float) = 1
            [HideInInspector] m_end_Matcap2_Quantization("Quantization", Float) = 0
            //endex
          [HideInInspector] m_end_Matcap2("Matcap 2", Float) = 0
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
            _Decal0_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal0_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL0_INVERT_BLEND_ORDER)] _Decal0_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL0_TILING_MODE)] _Decal0_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL0_REPLACE_ALPHA)] _Decal0_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL0_MULTIPLY)] _Decal0_Replace_Multiply_Mode("Multiply", Float) = 0
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
              [ThryToggle(_DECAL0_REFLECTIONS_ALPHA_BLEND)] _Decal0_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal0_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal0_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal0_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal0_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal0_Emissions_Enabled==0
            [HideInInspector] m_start_Decal0_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL0_EMISSIONS)] _Decal0_Emissions_Enabled("Enable", Float) = 0
              _Decal0_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal0_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL0_EMISSION_MODE_ADD_PRODUCT)] _Decal0_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal0_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal0_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL0_EMISSIONS_PROXIMITY)] _Decal0_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal0_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal0_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal0_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal0_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal0_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal0_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL0_DOMAIN_WARPING)] _Decal0_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal0_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal0_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal0_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal0_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal0_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal0_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal0_SDF_Enabled==0
            [HideInInspector] m_start_Decal0_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL0_SDF)] _Decal0_SDF_Enabled("Enable", Float) = 0
              _Decal0_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal0_SDF_Invert("SDF invert", Float) = 0
              _Decal0_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal0_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal0_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal0_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL0_SDF_SSN)] _Decal0_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL0_SDF_SSN_REPLACE)] _Decal0_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal0_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal0_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal0_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal0_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL0_CMYK_WARPING_PLANES)] _Decal0_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal0_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal0_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal0_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal0_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal0_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
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
            _Decal1_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal1_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL1_INVERT_BLEND_ORDER)] _Decal1_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL1_TILING_MODE)] _Decal1_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL1_REPLACE_ALPHA)] _Decal1_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL1_MULTIPLY)] _Decal1_Replace_Multiply_Mode("Multiply", Float) = 0
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
              [ThryToggle(_DECAL1_REFLECTIONS_ALPHA_BLEND)] _Decal1_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal1_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal1_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal1_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal1_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal1_Emissions_Enabled==0
            [HideInInspector] m_start_Decal1_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL1_EMISSIONS)] _Decal1_Emissions_Enabled("Enable", Float) = 0
              _Decal1_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal1_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL1_EMISSION_MODE_ADD_PRODUCT)] _Decal1_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal1_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal1_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL1_EMISSIONS_PROXIMITY)] _Decal1_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal1_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal1_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal1_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal1_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal1_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal1_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL1_DOMAIN_WARPING)] _Decal1_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal1_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal1_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal1_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal1_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal1_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal1_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal1_SDF_Enabled==0
            [HideInInspector] m_start_Decal1_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL1_SDF)] _Decal1_SDF_Enabled("Enable", Float) = 0
              _Decal1_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal1_SDF_Invert("SDF invert", Float) = 0
              _Decal1_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal1_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal1_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal1_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL1_SDF_SSN)] _Decal1_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL1_SDF_SSN_REPLACE)] _Decal1_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal1_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal1_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal1_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal1_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL1_CMYK_WARPING_PLANES)] _Decal1_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal1_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal1_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal1_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal1_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal1_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
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
            _Decal2_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal2_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL2_INVERT_BLEND_ORDER)] _Decal2_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL2_TILING_MODE)] _Decal2_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL2_REPLACE_ALPHA)] _Decal2_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL2_MULTIPLY)] _Decal2_Replace_Multiply_Mode("Multiply", Float) = 0
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
              [ThryToggle(_DECAL2_REFLECTIONS_ALPHA_BLEND)] _Decal2_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal2_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal2_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal2_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal2_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal2_Emissions_Enabled==0
            [HideInInspector] m_start_Decal2_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL2_EMISSIONS)] _Decal2_Emissions_Enabled("Enable", Float) = 0
              _Decal2_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal2_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL2_EMISSION_MODE_ADD_PRODUCT)] _Decal2_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal2_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal2_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL2_EMISSIONS_PROXIMITY)] _Decal2_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal2_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal2_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal2_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal2_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal2_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal2_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL2_DOMAIN_WARPING)] _Decal2_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal2_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal2_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal2_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal2_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal2_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal2_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal2_SDF_Enabled==0
            [HideInInspector] m_start_Decal2_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL2_SDF)] _Decal2_SDF_Enabled("Enable", Float) = 0
              _Decal2_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal2_SDF_Invert("SDF invert", Float) = 0
              _Decal2_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal2_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal2_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal2_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL2_SDF_SSN)] _Decal2_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL2_SDF_SSN_REPLACE)] _Decal2_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal2_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal2_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal2_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal2_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL2_CMYK_WARPING_PLANES)] _Decal2_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal2_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal2_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal2_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal2_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal2_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
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
            _Decal3_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal3_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL3_INVERT_BLEND_ORDER)] _Decal3_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL3_TILING_MODE)] _Decal3_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL3_REPLACE_ALPHA)] _Decal3_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL3_MULTIPLY)] _Decal3_Replace_Multiply_Mode("Multiply", Float) = 0
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
              [ThryToggle(_DECAL3_REFLECTIONS_ALPHA_BLEND)] _Decal3_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal3_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal3_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal3_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal3_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal3_Emissions_Enabled==0
            [HideInInspector] m_start_Decal3_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL3_EMISSIONS)] _Decal3_Emissions_Enabled("Enable", Float) = 0
              _Decal3_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal3_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL3_EMISSION_MODE_ADD_PRODUCT)] _Decal3_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal3_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal3_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL3_EMISSIONS_PROXIMITY)] _Decal3_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal3_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal3_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal3_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal3_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal3_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal3_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL3_DOMAIN_WARPING)] _Decal3_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal3_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal3_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal3_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal3_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal3_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal3_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal3_SDF_Enabled==0
            [HideInInspector] m_start_Decal3_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL3_SDF)] _Decal3_SDF_Enabled("Enable", Float) = 0
              _Decal3_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal3_SDF_Invert("SDF invert", Float) = 0
              _Decal3_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal3_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal3_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal3_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL3_SDF_SSN)] _Decal3_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL3_SDF_SSN_REPLACE)] _Decal3_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal3_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal3_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal3_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal3_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL3_CMYK_WARPING_PLANES)] _Decal3_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal3_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal3_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal3_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal3_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal3_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
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
          //ifex _Decal4_Enabled==0
          [HideInInspector] m_start_Decal4("Decal 4", Float) = 0
            [ThryToggle(_DECAL4)] _Decal4_Enabled("Enable", Float) = 0
            _Decal4_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal4_MainTex("Base color", 2D) = "white" {}
            _Decal4_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal4_Angle("Angle", Range(0, 1)) = 0.0
            _Decal4_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal4_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL4_INVERT_BLEND_ORDER)] _Decal4_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL4_TILING_MODE)] _Decal4_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL4_REPLACE_ALPHA)] _Decal4_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL4_MULTIPLY)] _Decal4_Replace_Multiply_Mode("Multiply", Float) = 0
            //ifex _Decal4_Normal_Enabled==0
            [HideInInspector] m_start_Decal4_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL4_NORMAL)] _Decal4_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal4_Normal("Normal", 2D) = "bump" {}
              _Decal4_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal4_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal4_Reflections_Enabled==0
            [HideInInspector] m_start_Decal4_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL4_REFLECTIONS)] _Decal4_Reflections_Enabled("Enable", Float) = 0
              [ThryToggle(_DECAL4_REFLECTIONS_ALPHA_BLEND)] _Decal4_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal4_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal4_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal4_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal4_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal4_Emissions_Enabled==0
            [HideInInspector] m_start_Decal4_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL4_EMISSIONS)] _Decal4_Emissions_Enabled("Enable", Float) = 0
              _Decal4_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal4_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL4_EMISSION_MODE_ADD_PRODUCT)] _Decal4_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal4_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal4_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL4_EMISSIONS_PROXIMITY)] _Decal4_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal4_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal4_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal4_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal4_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal4_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal4_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL4_DOMAIN_WARPING)] _Decal4_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal4_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal4_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal4_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal4_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal4_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal4_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal4_SDF_Enabled==0
            [HideInInspector] m_start_Decal4_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL4_SDF)] _Decal4_SDF_Enabled("Enable", Float) = 0
              _Decal4_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal4_SDF_Invert("SDF invert", Float) = 0
              _Decal4_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal4_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal4_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal4_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL4_SDF_SSN)] _Decal4_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL4_SDF_SSN_REPLACE)] _Decal4_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal4_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal4_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal4_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal4_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL4_CMYK_WARPING_PLANES)] _Decal4_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal4_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal4_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal4_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal4_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal4_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
            [HideInInspector] m_end_Decal4_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal4_Mask_Enabled==0
            [HideInInspector] m_start_Decal4_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL4_MASK)] _Decal4_Mask_Enabled("Enable", Float) = 0
              _Decal4_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal4_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal4("Decal 4", Float) = 0
          //endex
          //ifex _Decal5_Enabled==0
          [HideInInspector] m_start_Decal5("Decal 5", Float) = 0
            [ThryToggle(_DECAL5)] _Decal5_Enabled("Enable", Float) = 0
            _Decal5_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal5_MainTex("Base color", 2D) = "white" {}
            _Decal5_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal5_Angle("Angle", Range(0, 1)) = 0.0
            _Decal5_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal5_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL5_INVERT_BLEND_ORDER)] _Decal5_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL5_TILING_MODE)] _Decal5_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL5_REPLACE_ALPHA)] _Decal5_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL5_MULTIPLY)] _Decal5_Replace_Multiply_Mode("Multiply", Float) = 0
            //ifex _Decal5_Normal_Enabled==0
            [HideInInspector] m_start_Decal5_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL5_NORMAL)] _Decal5_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal5_Normal("Normal", 2D) = "bump" {}
              _Decal5_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal5_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal5_Reflections_Enabled==0
            [HideInInspector] m_start_Decal5_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL5_REFLECTIONS)] _Decal5_Reflections_Enabled("Enable", Float) = 0
              [ThryToggle(_DECAL5_REFLECTIONS_ALPHA_BLEND)] _Decal5_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal5_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal5_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal5_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal5_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal5_Emissions_Enabled==0
            [HideInInspector] m_start_Decal5_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL5_EMISSIONS)] _Decal5_Emissions_Enabled("Enable", Float) = 0
              _Decal5_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal5_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL5_EMISSION_MODE_ADD_PRODUCT)] _Decal5_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal5_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal5_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL5_EMISSIONS_PROXIMITY)] _Decal5_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal5_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal5_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal5_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal5_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal5_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal5_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL5_DOMAIN_WARPING)] _Decal5_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal5_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal5_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal5_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal5_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal5_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal5_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal5_SDF_Enabled==0
            [HideInInspector] m_start_Decal5_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL5_SDF)] _Decal5_SDF_Enabled("Enable", Float) = 0
              _Decal5_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal5_SDF_Invert("SDF invert", Float) = 0
              _Decal5_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal5_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal5_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal5_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL5_SDF_SSN)] _Decal5_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL5_SDF_SSN_REPLACE)] _Decal5_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal5_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal5_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal5_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal5_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL5_CMYK_WARPING_PLANES)] _Decal5_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal5_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal5_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal5_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal5_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal5_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
            [HideInInspector] m_end_Decal5_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal5_Mask_Enabled==0
            [HideInInspector] m_start_Decal5_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL5_MASK)] _Decal5_Mask_Enabled("Enable", Float) = 0
              _Decal5_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal5_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal5("Decal 5", Float) = 0
          //endex
          //ifex _Decal6_Enabled==0
          [HideInInspector] m_start_Decal6("Decal 6", Float) = 0
            [ThryToggle(_DECAL6)] _Decal6_Enabled("Enable", Float) = 0
            _Decal6_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal6_MainTex("Base color", 2D) = "white" {}
            _Decal6_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal6_Angle("Angle", Range(0, 1)) = 0.0
            _Decal6_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal6_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL6_INVERT_BLEND_ORDER)] _Decal6_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL6_TILING_MODE)] _Decal6_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL6_REPLACE_ALPHA)] _Decal6_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL6_MULTIPLY)] _Decal6_Replace_Multiply_Mode("Multiply", Float) = 0
            //ifex _Decal6_Normal_Enabled==0
            [HideInInspector] m_start_Decal6_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL6_NORMAL)] _Decal6_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal6_Normal("Normal", 2D) = "bump" {}
              _Decal6_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal6_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal6_Reflections_Enabled==0
            [HideInInspector] m_start_Decal6_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL6_REFLECTIONS)] _Decal6_Reflections_Enabled("Enable", Float) = 0
              [ThryToggle(_DECAL6_REFLECTIONS_ALPHA_BLEND)] _Decal6_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal6_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal6_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal6_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal6_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal6_Emissions_Enabled==0
            [HideInInspector] m_start_Decal6_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL6_EMISSIONS)] _Decal6_Emissions_Enabled("Enable", Float) = 0
              _Decal6_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal6_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL6_EMISSION_MODE_ADD_PRODUCT)] _Decal6_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal6_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal6_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL6_EMISSIONS_PROXIMITY)] _Decal6_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal6_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal6_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal6_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal6_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal6_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal6_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL6_DOMAIN_WARPING)] _Decal6_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal6_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal6_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal6_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal6_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal6_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal6_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal6_SDF_Enabled==0
            [HideInInspector] m_start_Decal6_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL6_SDF)] _Decal6_SDF_Enabled("Enable", Float) = 0
              _Decal6_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal6_SDF_Invert("SDF invert", Float) = 0
              _Decal6_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal6_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal6_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal6_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL6_SDF_SSN)] _Decal6_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL6_SDF_SSN_REPLACE)] _Decal6_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal6_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal6_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal6_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal6_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL6_CMYK_WARPING_PLANES)] _Decal6_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal6_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal6_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal6_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal6_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal6_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
            [HideInInspector] m_end_Decal6_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal6_Mask_Enabled==0
            [HideInInspector] m_start_Decal6_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL6_MASK)] _Decal6_Mask_Enabled("Enable", Float) = 0
              _Decal6_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal6_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal6("Decal 6", Float) = 0
          //endex
          //ifex _Decal7_Enabled==0
          [HideInInspector] m_start_Decal7("Decal 7", Float) = 0
            [ThryToggle(_DECAL7)] _Decal7_Enabled("Enable", Float) = 0
            _Decal7_Color("Tint", Color) = (1, 1, 1, 1)
            _Decal7_MainTex("Base color", 2D) = "white" {}
            _Decal7_Opacity("Opacity", Range(0, 1)) = 1.0
            _Decal7_Angle("Angle", Range(0, 1)) = 0.0
            _Decal7_UV_Channel("UV channel", Range(0, 3.1)) = 0
            _Decal7_Bias("Mip bias", Range(-4, 4)) = 0
            [ThryToggle(_DECAL7_INVERT_BLEND_ORDER)] _Decal7_Invert_Blend_Order("Invert blend order", Float) = 0
            [ThryToggle(_DECAL7_TILING_MODE)] _Decal7_Tiling_Mode("Tiling mode", Float) = 0
            [ThryToggle(_DECAL7_REPLACE_ALPHA)] _Decal7_Replace_Alpha_Mode("Replace alpha", Float) = 0
            [ThryToggle(_DECAL7_MULTIPLY)] _Decal7_Replace_Multiply_Mode("Multiply", Float) = 0
            //ifex _Decal7_Normal_Enabled==0
            [HideInInspector] m_start_Decal7_Normal("Normal", Float) = 0
              [ThryToggle(_DECAL7_NORMAL)] _Decal7_Normal_Enabled("Enable", Float) = 0
              [Normal]_Decal7_Normal("Normal", 2D) = "bump" {}
              _Decal7_Normal_Scale("Normal scale", Float) = 1.0
            [HideInInspector] m_end_Decal7_Normal("Normal", Float) = 0
            //endex
            //ifex _Decal7_Reflections_Enabled==0
            [HideInInspector] m_start_Decal7_Reflections("Reflections", Float) = 0
              [ThryToggle(_DECAL7_REFLECTIONS)] _Decal7_Reflections_Enabled("Enable", Float) = 0
              [ThryToggle(_DECAL7_REFLECTIONS_ALPHA_BLEND)] _Decal7_Reflections_Alpha_Blend("Alpha blend", Float) = 0
              _Decal7_MetallicGlossMap("Metallic gloss map", 2D) = "white" {}
              _Decal7_Smoothness("Smoothness", Range(0, 1)) = 0.5
              _Decal7_Metallic("Metallic", Range(0, 1)) = 0.0
            [HideInInspector] m_end_Decal7_Reflections("Reflections", Float) = 0
            //endex
            //ifex _Decal7_Emissions_Enabled==0
            [HideInInspector] m_start_Decal7_Emissions("Emissions", Float) = 0
              [ThryToggle(_DECAL7_EMISSIONS)] _Decal7_Emissions_Enabled("Enable", Float) = 0
              _Decal7_Emission_Color("Emission color", Color) = (1, 1, 1, 1)
              _Decal7_Emission_Strength("Emission strength", Float) = 1
              [ThryToggle(_DECAL7_EMISSION_MODE_ADD_PRODUCT)] _Decal7_Emission_Mode_Add_Product("Add product", Float) = 0
              //ifex _Decal7_Emissions_Proximity_Enabled==0
              [HideInInspector] m_start_Decal7_Emissions_Proximity("Proximity", Float) = 0
                [ThryToggle(_DECAL7_EMISSIONS_PROXIMITY)] _Decal7_Emissions_Proximity_Enabled("Enable", Float) = 0
                _Decal7_Emissions_Proximity_Min_Distance("Min distance", Float) = 0
                _Decal7_Emissions_Proximity_Max_Distance("Max distance", Float) = 1
              [HideInInspector] m_end_Decal7_Emissions_Proximity("Proximity", Float) = 0
              //endex
            [HideInInspector] m_end_Decal7_Emissions("Emissions", Float) = 0
            //endex
            //ifex _Decal7_Domain_Warping_Enabled==0
            [HideInInspector] m_start_Decal7_Domain_Warping("Domain warping", Float) = 0
              [ThryToggle(_DECAL7_DOMAIN_WARPING)] _Decal7_Domain_Warping_Enabled("Enable", Float) = 0
              _Decal7_Domain_Warping_Noise("Noise", 2D) = "black" {}
              _Decal7_Domain_Warping_Octaves("Octaves", Float) = 1
              _Decal7_Domain_Warping_Strength("Strength", Float) = 0.1
              _Decal7_Domain_Warping_Scale("Scale", Float) = 0.1
              _Decal7_Domain_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Decal7_Domain_Warping("Domain warping", Float) = 0
            //endex
            //ifex _Decal7_SDF_Enabled==0
            [HideInInspector] m_start_Decal7_SDF("SDF mode", Float) = 0
              [ThryToggle(_DECAL7_SDF)] _Decal7_SDF_Enabled("Enable", Float) = 0
              _Decal7_SDF_Threshold("SDF threshold", Range(0, 1)) = 0.5
              [MaterialToggle] _Decal7_SDF_Invert("SDF invert", Float) = 0
              _Decal7_SDF_Softness("SDF softness", Range(0, 1)) = 0.01
              _Decal7_SDF_Px_Range("SDF px range", Float) = 2
              //ifex _Decal7_SDF_SSN_Enabled==0
              [HideInInspector] m_start_Decal7_SSN("Screen space normals", Float) = 0
                [ThryToggle(_DECAL7_SDF_SSN)] _Decal7_SDF_SSN_Enabled("Enable", Float) = 0
                [ThryToggle(_DECAL7_SDF_SSN_REPLACE)] _Decal7_SDF_SSN_Replace("Replace normals", Float) = 0
                _Decal7_SDF_SSN_Strength("Strength", Range(0, 10)) = 1
              [HideInInspector] m_end_Decal7_SSN("Screen space normals", Float) = 0
              //endex
              //ifex _Decal7_CMYK_Warping_Planes_Enabled==0
              [HideInInspector] m_start_Decal7_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
                [ThryToggle(_DECAL7_CMYK_WARPING_PLANES)] _Decal7_CMYK_Warping_Planes_Enabled("Enable", Float) = 0
                _Decal7_CMYK_Warping_Planes_Noise("Noise", 2D) = "black" {}
                _Decal7_CMYK_Warping_Planes_Strength("Strength", Float) = 0.1
                _Decal7_CMYK_Warping_Planes_Scale("Scale", Float) = 0.1
                _Decal7_CMYK_Warping_Planes_Speed("Speed", Float) = 1.0
              [HideInInspector] m_end_Decal7_CMYK_Warping_Planes("CMYK warping planes", Float) = 0
              //endex
            [HideInInspector] m_end_Decal7_SDF("SDF", Float) = 0
            //endex
            //ifex _Decal7_Mask_Enabled==0
            [HideInInspector] m_start_Decal7_Mask("Mask", Float) = 0
              [ThryToggle(_DECAL7_MASK)] _Decal7_Mask_Enabled("Enable", Float) = 0
              _Decal7_Mask("Mask", 2D) = "white" {}
            [HideInInspector] m_end_Decal7_Mask("Mask", Float) = 0
            //endex
          [HideInInspector] m_end_Decal7("Decal 7", Float) = 0
          //endex
        [HideInInspector] m_end_Decals("Decals", Float) = 0

        //ifex _Gradient_Normals_Enabled==0
        [HideInInspector] m_start_Gradient_Normals("Gradient Normals", Float) = 0
          [ThryToggle(_GRADIENT_NORMALS)] _Gradient_Normals_Enabled("Enable", Float) = 0

          //ifex _Gradient_Normals_0_Vertical_Enabled==0
          [HideInInspector] m_start_Gradient_Normals_0("Vertical displacement gradient 0", Float) = 0
            [ThryToggle(_GRADIENT_NORMALS_0_VERTICAL)] _Gradient_Normals_0_Vertical_Enabled("Enable", Float) = 0
            _Gradient_Normals_0_Vertical("(dfy/dx, dfy/dz)", 2D) = "black" {}

            //ifex _Gradient_Normals_0_Horizontal_Enabled==0
            [HideInInspector] m_start_Gradient_Normals_0_Horizontal("Horizontal displacement gradient", Float) = 0
              [ThryToggle(_GRADIENT_NORMALS_0_HORIZONTAL)] _Gradient_Normals_0_Horizontal_Enabled("Enable", Float) = 0
              _Gradient_Normals_0_Horizontal("(dfx/dx, dfz/dz)", 2D) = "black" {}
            [HideInInspector] m_end_Gradient_Normals_0_Horizontal("Horizontal displacement gradient", Float) = 0
            //endex

          [HideInInspector] m_end_Gradient_Normals_0("Gradient 0", Float) = 0
          //endex

          //ifex _Gradient_Normals_1_Vertical_Enabled==0
          [HideInInspector] m_start_Gradient_Normals_1("Vertical displacement gradient 1", Float) = 0
            [ThryToggle(_GRADIENT_NORMALS_1_VERTICAL)] _Gradient_Normals_1_Vertical_Enabled("Enable", Float) = 0
            _Gradient_Normals_1_Vertical("(dfy/dx, dfy/dz)", 2D) = "black" {}

            //ifex _Gradient_Normals_1_Horizontal_Enabled==0
            [HideInInspector] m_start_Gradient_Normals_1_Horizontal("Horizontal displacement gradient", Float) = 0
              [ThryToggle(_GRADIENT_NORMALS_1_HORIZONTAL)] _Gradient_Normals_1_Horizontal_Enabled("Enable", Float) = 0
              _Gradient_Normals_1_Horizontal("(dfx/dx, dfz/dz)", 2D) = "black" {}
            [HideInInspector] m_end_Gradient_Normals_1_Horizontal("Horizontal displacement gradient", Float) = 0
            //endex

          [HideInInspector] m_end_Gradient_Normals_1("Gradient 1", Float) = 0
          //endex

          //ifex _Gradient_Normals_2_Vertical_Enabled==0
          [HideInInspector] m_start_Gradient_Normals_2("Vertical displacement gradient 2", Float) = 0
            [ThryToggle(_GRADIENT_NORMALS_2_VERTICAL)] _Gradient_Normals_2_Vertical_Enabled("Enable", Float) = 0
            _Gradient_Normals_2_Vertical("(dfy/dx, dfy/dz)", 2D) = "black" {}

            //ifex _Gradient_Normals_2_Horizontal_Enabled==0
            [HideInInspector] m_start_Gradient_Normals_2_Horizontal("Horizontal displacement gradient", Float) = 0
              [ThryToggle(_GRADIENT_NORMALS_2_HORIZONTAL)] _Gradient_Normals_2_Horizontal_Enabled("Enable", Float) = 0
              _Gradient_Normals_2_Horizontal("(dfx/dx, dfz/dz)", 2D) = "black" {}
            [HideInInspector] m_end_Gradient_Normals_2_Horizontal("Horizontal displacement gradient", Float) = 0
            //endex

          [HideInInspector] m_end_Gradient_Normals_2("Gradient 2", Float) = 0
          //endex

          //ifex _Gradient_Normals_3_Vertical_Enabled==0
          [HideInInspector] m_start_Gradient_Normals_3("Vertical displacement gradient 3", Float) = 0
            [ThryToggle(_GRADIENT_NORMALS_3_VERTICAL)] _Gradient_Normals_3_Vertical_Enabled("Enable", Float) = 0
            _Gradient_Normals_3_Vertical("(dfy/dx, dfy/dz)", 2D) = "black" {}

            //ifex _Gradient_Normals_3_Horizontal_Enabled==0
            [HideInInspector] m_start_Gradient_Normals_3_Horizontal("Horizontal displacement gradient", Float) = 0
              [ThryToggle(_GRADIENT_NORMALS_3_HORIZONTAL)] _Gradient_Normals_3_Horizontal_Enabled("Enable", Float) = 0
              _Gradient_Normals_3_Horizontal("(dfx/dx, dfz/dz)", 2D) = "black" {}
            [HideInInspector] m_end_Gradient_Normals_3_Horizontal("Horizontal displacement gradient", Float) = 0
            //endex

          [HideInInspector] m_end_Gradient_Normals_3("Gradient 3", Float) = 0
          //endex
        [HideInInspector] m_end_Gradient_Normals("Gradient Normals", Float) = 0
        //endex

        //ifex _Sea_Foam_Enabled==0
        [HideInInspector] m_start_Sea_Foam("Sea foam", Float) = 0
          [ThryToggle(_SEA_FOAM)] _Sea_Foam_Enabled("Enable", Float) = 0
          _Sea_Foam_Color("Color", Color) = (1, 1, 1, 1)
          _Sea_Foam_Roughness("Roughness", Float) = 0.85
          _Sea_Foam_Lambda("Lambda", Range(0, 4)) = 1
          _Sea_Foam_Power("Power", Range(0, 50)) = 1
          _Sea_Foam_Factor("Factor", Range(0, 2)) = 1
          _Sea_Foam_Bias("Bias", Range(-5, 5)) = 0
          //ifex _Sea_Foam_0_Enabled==0
          [HideInInspector] m_start_Sea_Foam_0("Sea foam 0", Float) = 0
            [ThryToggle(_SEA_FOAM_0)] _Sea_Foam_0_Enabled("Enable", Float) = 0
            _Sea_Foam_0_Slope("(dfx/dx, dfy/dy, 0, dfx/dy)", 2D) = "black" {}
          [HideInInspector] m_end_Sea_Foam_0("Sea foam 0", Float) = 0
          //endex
          //ifex _Sea_Foam_1_Enabled==0
          [HideInInspector] m_start_Sea_Foam_1("Sea foam 1", Float) = 0
            [ThryToggle(_SEA_FOAM_1)] _Sea_Foam_1_Enabled("Enable", Float) = 0
            _Sea_Foam_1_Slope("(dfx/dx, dfy/dy, 0, dfx/dy)", 2D) = "black" {}
          [HideInInspector] m_end_Sea_Foam_1("Sea foam 1", Float) = 0
          //endex
          //ifex _Sea_Foam_2_Enabled==0
          [HideInInspector] m_start_Sea_Foam_2("Sea foam 2", Float) = 0
            [ThryToggle(_SEA_FOAM_2)] _Sea_Foam_2_Enabled("Enable", Float) = 0
            _Sea_Foam_2_Slope("(dfx/dx, dfy/dy, 0, dfx/dy)", 2D) = "black" {}
          [HideInInspector] m_end_Sea_Foam_2("Sea foam 2", Float) = 0
          //endex
          //ifex _Sea_Foam_3_Enabled==0
          [HideInInspector] m_start_Sea_Foam_3("Sea foam 3", Float) = 0
            [ThryToggle(_SEA_FOAM_3)] _Sea_Foam_3_Enabled("Enable", Float) = 0
            _Sea_Foam_3_Slope("(dfx/dx, dfy/dy, 0, dfx/dy)", 2D) = "black" {}
          [HideInInspector] m_end_Sea_Foam_3("Sea foam 3", Float) = 0
          //endex
        [HideInInspector] m_end_Sea_Foam("Sea foam", Float) = 0
        //endex

        [HideInInspector] m_start_Color_Correction("Color correction", Float) = 0
          //ifex _Oklch_Correction_Enabled==0
          [HideInInspector] m_start_Oklch_Correction("Oklch", Float) = 0
            [ThryToggle(_OKLCH_CORRECTION)] _Oklch_Correction_Enabled("Enable", Float) = 0
            _Oklch_Correction_L("L", Range(0,1)) = 1
            _Oklch_Correction_C("C", Range(0,1)) = 1
            _Oklch_Correction_H("H", Range(0,1)) = 1
          [HideInInspector] m_end_Oklch_Correction("Oklch", Float) = 0
          //endex
          //ifex _Oklab_Brightness_Clamp_Enabled==0
          [HideInInspector] m_start_Oklab_Brightness_Clamp("Oklab brightness clamp", Float) = 0
            [ThryToggle(_OKLAB_BRIGHTNESS_CLAMP)] _Oklab_Brightness_Clamp_Enabled("Enable", Float) = 0
            _Oklab_Brightness_Clamp_Min("Min", Float) = 0
            _Oklab_Brightness_Clamp_Max("Max", Float) = 1
          [HideInInspector] m_end_Oklab_Brightness_Clamp("Oklab brightness clamp", Float) = 0
          //endex
        [HideInInspector] m_end_Color_Correction("Color correction", Float) = 0

        //ifex _Raymarched_Fog_Enabled==0
        [HideInInspector] m_start_Raymarched_Fog("Raymarched fog", Float) = 0
          [ThryToggle(_RAYMARCHED_FOG)] _Raymarched_Fog_Enabled("Enable", Float) = 0
          _Raymarched_Fog_Steps("Steps", Range(1, 32)) = 32
          _Raymarched_Fog_Color("Color", Color) = (0.3, 0.3, 0.3, 1)
          _Raymarched_Fog_Direct_Light_Intensity("Direct light intensity", Float) = 1
          _Raymarched_Fog_Indirect_Light_Intensity("Indirect light intensity", Float) = 1
          _Raymarched_Fog_Dithering_Noise("Dithering noise", 2D) = "black" {}
          _Raymarched_Fog_Density_Noise("Density noise", 3D) = "black" {}
          _Raymarched_Fog_Density_Noise_Scale("Density noise scale", Vector) = (1, 1, 1, 0)
          _Raymarched_Fog_Y_Cutoff("Y cutoff", Float) = -1000
          _Raymarched_Fog_Velocity("Velocity", Vector) = (1, -.2, 0, 0)
          _Raymarched_Fog_Mean_Free_Path("Mean free path", Float) = 1
          _Raymarched_Fog_Albedo("Albedo", Float) = 1
          _Raymarched_Fog_G("G", Float) = 1
          _Raymarched_Fog_Height_Scale("Height scale", Float) = 10
          _Raymarched_Fog_Height_Offset("Height offset", Float) = 0
          _Raymarched_Fog_Turbulence("Turbulence", Float) = 1
          _Raymarched_Fog_Step_Size("Step size", Float) = 0.8
          _Raymarched_Fog_Step_Growth("Step growth", Float) = 1.25
          //ifex _Raymarched_Fog_Density_Exponent_Enabled==0
          [HideInInspector] m_start_Raymarched_Fog_Density_Exponent("Density exponent", Float) = 0
            [ThryToggle(_RAYMARCHED_FOG_DENSITY_EXPONENT)] _Raymarched_Fog_Density_Exponent_Enabled("Enable", Float) = 0
            _Raymarched_Fog_Density_Exponent("Exponent", Float) = 1
          [HideInInspector] m_end_Raymarched_Fog_Density_Exponent("Density exponent", Float) = 0
          //endex
          //ifex _Raymarched_Fog_Emitter_Texture_Enabled==0
          [HideInInspector] m_start_Raymarched_Fog_Emitter_Texture("Emitter texture", Float) = 0
            [ThryToggle(_RAYMARCHED_FOG_EMITTER_TEXTURE)] _Raymarched_Fog_Emitter_Texture_Enabled("Enable", Float) = 0
            _Raymarched_Fog_Emitter_Texture("Texture", 2D) = "black" {}
            _Raymarched_Fog_Emitter_Texture_World_Pos("World position", Vector) = (0, 0, 0, 0)
            _Raymarched_Fog_Emitter_Texture_World_Normal("World normal", Vector) = (0, 0, 0, 0)
            _Raymarched_Fog_Emitter_Texture_World_Tangent("World tangent", Vector) = (0, 0, 0, 0)
            _Raymarched_Fog_Emitter_Texture_World_Scale("World scale", Vector) = (1, 1, 0, 0)
            _Raymarched_Fog_Emitter_Texture_World_Scale_Rcp("World scale reciprocal", Vector) = (1, 1, 0, 0)
            _Raymarched_Fog_Emitter_Texture_Luminance("Luminance (W·sr⁻¹·m⁻²)", Float) = 100
            _Raymarched_Fog_Emitter_Texture_Intensity("Intensity", Float) = 2000

            //ifex _Raymarched_Fog_Emitter_Texture_Warping_Enabled==0
            [HideInInspector] m_start_Raymarched_Fog_Emitter_Texture_Warping("Emitter texture warping", Float) = 0
              [ThryToggle(_RAYMARCHED_FOG_EMITTER_TEXTURE_WARPING)] _Raymarched_Fog_Emitter_Texture_Warping_Enabled("Enable", Float) = 0
              _Raymarched_Fog_Emitter_Texture_Warping_Octaves("Octaves", Float) = 1
              _Raymarched_Fog_Emitter_Texture_Warping_Strength("Strength", Float) = 0.1
              _Raymarched_Fog_Emitter_Texture_Warping_Scale("Scale", Float) = 0.1
              _Raymarched_Fog_Emitter_Texture_Warping_Speed("Speed", Float) = 1.0
            [HideInInspector] m_end_Raymarched_Fog_Emitter_Texture_Warping("Emitter texture warping", Float) = 0
            //endex

          [HideInInspector] m_end_Raymarched_Fog_Emitter_Texture("Emitter texture", Float) = 0
          //endex

        [HideInInspector] m_end_Raymarched_Fog("Raymarched fog", Float) = 0
        //endex

        //ifex _3D_SDF_Enabled==0
        [HideInInspector] m_start_3D_SDF("3D SDF", Float) = 0
          [ThryToggle(_3D_SDF)] _3D_SDF_Enabled("Enable", Float) = 0
          _3D_SDF_Texture("Texture", 3D) = "white" {}
          _3D_SDF_ST("Scale and offset", Vector) = (1, 1, 0, 0)
          _3D_SDF_UV_Channel("UV channel", Range(0, 3.1)) = 0
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

        //ifex _SSAO_Enabled==0
        [HideInInspector] m_start_SSAO("SSAO", Float) = 0
          [ThryToggle(_SSAO)] _SSAO_Enabled("Enable", Float) = 0
          _SSAO_Radius("Radius", Float) = 1.0
          _SSAO_Samples("Samples", Float) = 5
          _SSAO_Strength("Strength", Float) = 1
          _SSAO_Noise("Noise", 2D) = "black" {}
          _SSAO_Bias("Bias", Float) = 0.0
          _SSAO_Frame_Counter("Frame counter", Float) = 0.0
        [HideInInspector] m_end_SSAO("SSAO", Float) = 0
        //endex

        //ifex _Trochoid_Enabled==0
        [HideInInspector] m_start_Trochoid("Trochoid", Float) = 0
          [ThryToggle(_TROCHOID)] _Trochoid_Enabled("Enable", Float) = 0
          _Trochoid_R("R", Range(0, 15)) = 1
          _Trochoid_r("r", Range(0, 15)) = 1
          _Trochoid_d("d", Range(0, 15)) = 1
          _Trochoid_theta_k("Theta factor", Range(0, 64)) = 1
          _Trochoid_t_k("Time factor", Range(0, 64)) = 1
          _Trochoid_X_Scale("X scale", Range(0, 4)) = 1
          _Trochoid_Y_Scale("Y scale", Range(0, 4)) = 1
          _Trochoid_Z_Scale("Z scale", Range(0, 64)) = 1
          _Trochoid_r_Power("r power", Range(0, 32)) = 1
          [Gradient] _Trochoid_Color_Ramp("Color ramp", 2D) = "black" {}
        [HideInInspector] m_end_Trochoid("Trochoid", Float) = 0
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

        //ifex _Unigram_Letter_Grid_Enabled==0
        [HideInInspector] m_start_Unigram_Letter_Grid("Unigram letter grid", Float) = 0
          [ThryToggle(_UNIGRAM_LETTER_GRID)] _Unigram_Letter_Grid_Enabled("Enable", Float) = 0
          _Unigram_Letter_Grid_Glyphs("Glyph texture", 2D) = "black" {}
          _Unigram_Letter_Grid_LUT("Unigram tokenizer LUT", 2D) = "black" {}
          _Unigram_Letter_Grid_Tex_Res_X("Glyph X resolution", Float) = 16
          _Unigram_Letter_Grid_Tex_Res_Y("Glyph Y resolution", Float) = 8
          _Unigram_Letter_Grid_Res_X("Cell X resolution", Range(1, 80)) = 1
          _Unigram_Letter_Grid_Res_Y("Cell Y resolution", Range(1, 80)) = 1
          _Unigram_Letter_Grid_UV_Scale_Offset("UV scale/offset", Vector) = (1, 1, 0, 0)
          _Unigram_Letter_Grid_Padding("Padding", Float) = 0.02
          _Unigram_Letter_Grid_Screen_Px_Range("Screen px range (from msdfgen)", Float) = 10
          _Unigram_Letter_Grid_Min_Screen_Px_Range("Minimum screen px range", Float) = 1
          _Unigram_Letter_Grid_Alpha_Threshold("Alpha threshold", Range(0, 1)) = 0.5

          // We compose the addressable space into blocks of 2-byte cells.
          // Each cell contains a 16-bit token id.
          // Each block contains 5 cells.
          // There are a total of 40 blocks.
          // This gives us a total of 200 cells. Since each cell is, on
          // average, 4.8 characters (according to test), this gives an
          // addressable space of 960 characters. Sending one block at 3 Hz
          // means that it will take a total of 13.3 seconds to fill the entire
          // space.
					// The "_Animated" suffix is to prevent thry's optimizer from inlining
					// these. Don't wanna have to click "is animated" one by one for all of them.
          _Unigram_Letter_Grid_Block00_Visual_Pointer_Animated("Block 00 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block01_Visual_Pointer_Animated("Block 01 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block02_Visual_Pointer_Animated("Block 02 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block03_Visual_Pointer_Animated("Block 03 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block04_Visual_Pointer_Animated("Block 04 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block05_Visual_Pointer_Animated("Block 05 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block06_Visual_Pointer_Animated("Block 06 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block07_Visual_Pointer_Animated("Block 07 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block08_Visual_Pointer_Animated("Block 08 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block09_Visual_Pointer_Animated("Block 09 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block10_Visual_Pointer_Animated("Block 10 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block11_Visual_Pointer_Animated("Block 11 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block12_Visual_Pointer_Animated("Block 12 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block13_Visual_Pointer_Animated("Block 13 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block14_Visual_Pointer_Animated("Block 14 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block15_Visual_Pointer_Animated("Block 15 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block16_Visual_Pointer_Animated("Block 16 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block17_Visual_Pointer_Animated("Block 17 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block18_Visual_Pointer_Animated("Block 18 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block19_Visual_Pointer_Animated("Block 19 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block20_Visual_Pointer_Animated("Block 20 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block21_Visual_Pointer_Animated("Block 21 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block22_Visual_Pointer_Animated("Block 22 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block23_Visual_Pointer_Animated("Block 23 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block24_Visual_Pointer_Animated("Block 24 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block25_Visual_Pointer_Animated("Block 25 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block26_Visual_Pointer_Animated("Block 26 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block27_Visual_Pointer_Animated("Block 27 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block28_Visual_Pointer_Animated("Block 28 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block29_Visual_Pointer_Animated("Block 29 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block30_Visual_Pointer_Animated("Block 30 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block31_Visual_Pointer_Animated("Block 31 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block32_Visual_Pointer_Animated("Block 32 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block33_Visual_Pointer_Animated("Block 33 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block34_Visual_Pointer_Animated("Block 34 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block35_Visual_Pointer_Animated("Block 35 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block36_Visual_Pointer_Animated("Block 36 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block37_Visual_Pointer_Animated("Block 37 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block38_Visual_Pointer_Animated("Block 38 visual pointer", Float) = 0
          _Unigram_Letter_Grid_Block39_Visual_Pointer_Animated("Block 39 visual pointer", Float) = 0

          _Unigram_Letter_Grid_Data_Block00_Datum00_Byte00_Animated("Block 00, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum00_Byte01_Animated("Block 00, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum01_Byte00_Animated("Block 00, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum01_Byte01_Animated("Block 00, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum02_Byte00_Animated("Block 00, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum02_Byte01_Animated("Block 00, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum03_Byte00_Animated("Block 00, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum03_Byte01_Animated("Block 00, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum04_Byte00_Animated("Block 00, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block00_Datum04_Byte01_Animated("Block 00, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block01_Datum00_Byte00_Animated("Block 01, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum00_Byte01_Animated("Block 01, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum01_Byte00_Animated("Block 01, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum01_Byte01_Animated("Block 01, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum02_Byte00_Animated("Block 01, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum02_Byte01_Animated("Block 01, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum03_Byte00_Animated("Block 01, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum03_Byte01_Animated("Block 01, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum04_Byte00_Animated("Block 01, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block01_Datum04_Byte01_Animated("Block 01, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block02_Datum00_Byte00_Animated("Block 02, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum00_Byte01_Animated("Block 02, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum01_Byte00_Animated("Block 02, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum01_Byte01_Animated("Block 02, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum02_Byte00_Animated("Block 02, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum02_Byte01_Animated("Block 02, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum03_Byte00_Animated("Block 02, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum03_Byte01_Animated("Block 02, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum04_Byte00_Animated("Block 02, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block02_Datum04_Byte01_Animated("Block 02, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block03_Datum00_Byte00_Animated("Block 03, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum00_Byte01_Animated("Block 03, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum01_Byte00_Animated("Block 03, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum01_Byte01_Animated("Block 03, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum02_Byte00_Animated("Block 03, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum02_Byte01_Animated("Block 03, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum03_Byte00_Animated("Block 03, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum03_Byte01_Animated("Block 03, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum04_Byte00_Animated("Block 03, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block03_Datum04_Byte01_Animated("Block 03, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block04_Datum00_Byte00_Animated("Block 04, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum00_Byte01_Animated("Block 04, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum01_Byte00_Animated("Block 04, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum01_Byte01_Animated("Block 04, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum02_Byte00_Animated("Block 04, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum02_Byte01_Animated("Block 04, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum03_Byte00_Animated("Block 04, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum03_Byte01_Animated("Block 04, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum04_Byte00_Animated("Block 04, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block04_Datum04_Byte01_Animated("Block 04, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block05_Datum00_Byte00_Animated("Block 05, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum00_Byte01_Animated("Block 05, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum01_Byte00_Animated("Block 05, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum01_Byte01_Animated("Block 05, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum02_Byte00_Animated("Block 05, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum02_Byte01_Animated("Block 05, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum03_Byte00_Animated("Block 05, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum03_Byte01_Animated("Block 05, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum04_Byte00_Animated("Block 05, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block05_Datum04_Byte01_Animated("Block 05, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block06_Datum00_Byte00_Animated("Block 06, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum00_Byte01_Animated("Block 06, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum01_Byte00_Animated("Block 06, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum01_Byte01_Animated("Block 06, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum02_Byte00_Animated("Block 06, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum02_Byte01_Animated("Block 06, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum03_Byte00_Animated("Block 06, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum03_Byte01_Animated("Block 06, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum04_Byte00_Animated("Block 06, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block06_Datum04_Byte01_Animated("Block 06, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block07_Datum00_Byte00_Animated("Block 07, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum00_Byte01_Animated("Block 07, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum01_Byte00_Animated("Block 07, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum01_Byte01_Animated("Block 07, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum02_Byte00_Animated("Block 07, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum02_Byte01_Animated("Block 07, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum03_Byte00_Animated("Block 07, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum03_Byte01_Animated("Block 07, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum04_Byte00_Animated("Block 07, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block07_Datum04_Byte01_Animated("Block 07, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block08_Datum00_Byte00_Animated("Block 08, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum00_Byte01_Animated("Block 08, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum01_Byte00_Animated("Block 08, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum01_Byte01_Animated("Block 08, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum02_Byte00_Animated("Block 08, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum02_Byte01_Animated("Block 08, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum03_Byte00_Animated("Block 08, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum03_Byte01_Animated("Block 08, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum04_Byte00_Animated("Block 08, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block08_Datum04_Byte01_Animated("Block 08, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block09_Datum00_Byte00_Animated("Block 09, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum00_Byte01_Animated("Block 09, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum01_Byte00_Animated("Block 09, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum01_Byte01_Animated("Block 09, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum02_Byte00_Animated("Block 09, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum02_Byte01_Animated("Block 09, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum03_Byte00_Animated("Block 09, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum03_Byte01_Animated("Block 09, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum04_Byte00_Animated("Block 09, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block09_Datum04_Byte01_Animated("Block 09, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block10_Datum00_Byte00_Animated("Block 10, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum00_Byte01_Animated("Block 10, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum01_Byte00_Animated("Block 10, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum01_Byte01_Animated("Block 10, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum02_Byte00_Animated("Block 10, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum02_Byte01_Animated("Block 10, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum03_Byte00_Animated("Block 10, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum03_Byte01_Animated("Block 10, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum04_Byte00_Animated("Block 10, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block10_Datum04_Byte01_Animated("Block 10, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block11_Datum00_Byte00_Animated("Block 11, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum00_Byte01_Animated("Block 11, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum01_Byte00_Animated("Block 11, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum01_Byte01_Animated("Block 11, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum02_Byte00_Animated("Block 11, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum02_Byte01_Animated("Block 11, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum03_Byte00_Animated("Block 11, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum03_Byte01_Animated("Block 11, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum04_Byte00_Animated("Block 11, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block11_Datum04_Byte01_Animated("Block 11, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block12_Datum00_Byte00_Animated("Block 12, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum00_Byte01_Animated("Block 12, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum01_Byte00_Animated("Block 12, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum01_Byte01_Animated("Block 12, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum02_Byte00_Animated("Block 12, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum02_Byte01_Animated("Block 12, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum03_Byte00_Animated("Block 12, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum03_Byte01_Animated("Block 12, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum04_Byte00_Animated("Block 12, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block12_Datum04_Byte01_Animated("Block 12, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block13_Datum00_Byte00_Animated("Block 13, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum00_Byte01_Animated("Block 13, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum01_Byte00_Animated("Block 13, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum01_Byte01_Animated("Block 13, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum02_Byte00_Animated("Block 13, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum02_Byte01_Animated("Block 13, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum03_Byte00_Animated("Block 13, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum03_Byte01_Animated("Block 13, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum04_Byte00_Animated("Block 13, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block13_Datum04_Byte01_Animated("Block 13, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block14_Datum00_Byte00_Animated("Block 14, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum00_Byte01_Animated("Block 14, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum01_Byte00_Animated("Block 14, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum01_Byte01_Animated("Block 14, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum02_Byte00_Animated("Block 14, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum02_Byte01_Animated("Block 14, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum03_Byte00_Animated("Block 14, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum03_Byte01_Animated("Block 14, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum04_Byte00_Animated("Block 14, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block14_Datum04_Byte01_Animated("Block 14, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block15_Datum00_Byte00_Animated("Block 15, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum00_Byte01_Animated("Block 15, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum01_Byte00_Animated("Block 15, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum01_Byte01_Animated("Block 15, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum02_Byte00_Animated("Block 15, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum02_Byte01_Animated("Block 15, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum03_Byte00_Animated("Block 15, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum03_Byte01_Animated("Block 15, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum04_Byte00_Animated("Block 15, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block15_Datum04_Byte01_Animated("Block 15, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block16_Datum00_Byte00_Animated("Block 16, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum00_Byte01_Animated("Block 16, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum01_Byte00_Animated("Block 16, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum01_Byte01_Animated("Block 16, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum02_Byte00_Animated("Block 16, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum02_Byte01_Animated("Block 16, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum03_Byte00_Animated("Block 16, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum03_Byte01_Animated("Block 16, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum04_Byte00_Animated("Block 16, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block16_Datum04_Byte01_Animated("Block 16, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block17_Datum00_Byte00_Animated("Block 17, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum00_Byte01_Animated("Block 17, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum01_Byte00_Animated("Block 17, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum01_Byte01_Animated("Block 17, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum02_Byte00_Animated("Block 17, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum02_Byte01_Animated("Block 17, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum03_Byte00_Animated("Block 17, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum03_Byte01_Animated("Block 17, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum04_Byte00_Animated("Block 17, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block17_Datum04_Byte01_Animated("Block 17, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block18_Datum00_Byte00_Animated("Block 18, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum00_Byte01_Animated("Block 18, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum01_Byte00_Animated("Block 18, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum01_Byte01_Animated("Block 18, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum02_Byte00_Animated("Block 18, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum02_Byte01_Animated("Block 18, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum03_Byte00_Animated("Block 18, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum03_Byte01_Animated("Block 18, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum04_Byte00_Animated("Block 18, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block18_Datum04_Byte01_Animated("Block 18, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block19_Datum00_Byte00_Animated("Block 19, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum00_Byte01_Animated("Block 19, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum01_Byte00_Animated("Block 19, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum01_Byte01_Animated("Block 19, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum02_Byte00_Animated("Block 19, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum02_Byte01_Animated("Block 19, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum03_Byte00_Animated("Block 19, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum03_Byte01_Animated("Block 19, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum04_Byte00_Animated("Block 19, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block19_Datum04_Byte01_Animated("Block 19, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block20_Datum00_Byte00_Animated("Block 20, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum00_Byte01_Animated("Block 20, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum01_Byte00_Animated("Block 20, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum01_Byte01_Animated("Block 20, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum02_Byte00_Animated("Block 20, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum02_Byte01_Animated("Block 20, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum03_Byte00_Animated("Block 20, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum03_Byte01_Animated("Block 20, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum04_Byte00_Animated("Block 20, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block20_Datum04_Byte01_Animated("Block 20, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block21_Datum00_Byte00_Animated("Block 21, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum00_Byte01_Animated("Block 21, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum01_Byte00_Animated("Block 21, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum01_Byte01_Animated("Block 21, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum02_Byte00_Animated("Block 21, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum02_Byte01_Animated("Block 21, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum03_Byte00_Animated("Block 21, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum03_Byte01_Animated("Block 21, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum04_Byte00_Animated("Block 21, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block21_Datum04_Byte01_Animated("Block 21, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block22_Datum00_Byte00_Animated("Block 22, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum00_Byte01_Animated("Block 22, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum01_Byte00_Animated("Block 22, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum01_Byte01_Animated("Block 22, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum02_Byte00_Animated("Block 22, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum02_Byte01_Animated("Block 22, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum03_Byte00_Animated("Block 22, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum03_Byte01_Animated("Block 22, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum04_Byte00_Animated("Block 22, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block22_Datum04_Byte01_Animated("Block 22, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block23_Datum00_Byte00_Animated("Block 23, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum00_Byte01_Animated("Block 23, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum01_Byte00_Animated("Block 23, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum01_Byte01_Animated("Block 23, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum02_Byte00_Animated("Block 23, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum02_Byte01_Animated("Block 23, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum03_Byte00_Animated("Block 23, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum03_Byte01_Animated("Block 23, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum04_Byte00_Animated("Block 23, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block23_Datum04_Byte01_Animated("Block 23, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block24_Datum00_Byte00_Animated("Block 24, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum00_Byte01_Animated("Block 24, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum01_Byte00_Animated("Block 24, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum01_Byte01_Animated("Block 24, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum02_Byte00_Animated("Block 24, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum02_Byte01_Animated("Block 24, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum03_Byte00_Animated("Block 24, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum03_Byte01_Animated("Block 24, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum04_Byte00_Animated("Block 24, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block24_Datum04_Byte01_Animated("Block 24, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block25_Datum00_Byte00_Animated("Block 25, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum00_Byte01_Animated("Block 25, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum01_Byte00_Animated("Block 25, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum01_Byte01_Animated("Block 25, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum02_Byte00_Animated("Block 25, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum02_Byte01_Animated("Block 25, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum03_Byte00_Animated("Block 25, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum03_Byte01_Animated("Block 25, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum04_Byte00_Animated("Block 25, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block25_Datum04_Byte01_Animated("Block 25, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block26_Datum00_Byte00_Animated("Block 26, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum00_Byte01_Animated("Block 26, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum01_Byte00_Animated("Block 26, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum01_Byte01_Animated("Block 26, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum02_Byte00_Animated("Block 26, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum02_Byte01_Animated("Block 26, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum03_Byte00_Animated("Block 26, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum03_Byte01_Animated("Block 26, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum04_Byte00_Animated("Block 26, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block26_Datum04_Byte01_Animated("Block 26, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block27_Datum00_Byte00_Animated("Block 27, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum00_Byte01_Animated("Block 27, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum01_Byte00_Animated("Block 27, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum01_Byte01_Animated("Block 27, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum02_Byte00_Animated("Block 27, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum02_Byte01_Animated("Block 27, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum03_Byte00_Animated("Block 27, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum03_Byte01_Animated("Block 27, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum04_Byte00_Animated("Block 27, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block27_Datum04_Byte01_Animated("Block 27, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block28_Datum00_Byte00_Animated("Block 28, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum00_Byte01_Animated("Block 28, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum01_Byte00_Animated("Block 28, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum01_Byte01_Animated("Block 28, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum02_Byte00_Animated("Block 28, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum02_Byte01_Animated("Block 28, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum03_Byte00_Animated("Block 28, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum03_Byte01_Animated("Block 28, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum04_Byte00_Animated("Block 28, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block28_Datum04_Byte01_Animated("Block 28, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block29_Datum00_Byte00_Animated("Block 29, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum00_Byte01_Animated("Block 29, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum01_Byte00_Animated("Block 29, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum01_Byte01_Animated("Block 29, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum02_Byte00_Animated("Block 29, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum02_Byte01_Animated("Block 29, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum03_Byte00_Animated("Block 29, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum03_Byte01_Animated("Block 29, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum04_Byte00_Animated("Block 29, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block29_Datum04_Byte01_Animated("Block 29, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block30_Datum00_Byte00_Animated("Block 30, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum00_Byte01_Animated("Block 30, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum01_Byte00_Animated("Block 30, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum01_Byte01_Animated("Block 30, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum02_Byte00_Animated("Block 30, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum02_Byte01_Animated("Block 30, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum03_Byte00_Animated("Block 30, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum03_Byte01_Animated("Block 30, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum04_Byte00_Animated("Block 30, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block30_Datum04_Byte01_Animated("Block 30, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block31_Datum00_Byte00_Animated("Block 31, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum00_Byte01_Animated("Block 31, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum01_Byte00_Animated("Block 31, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum01_Byte01_Animated("Block 31, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum02_Byte00_Animated("Block 31, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum02_Byte01_Animated("Block 31, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum03_Byte00_Animated("Block 31, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum03_Byte01_Animated("Block 31, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum04_Byte00_Animated("Block 31, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block31_Datum04_Byte01_Animated("Block 31, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block32_Datum00_Byte00_Animated("Block 32, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum00_Byte01_Animated("Block 32, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum01_Byte00_Animated("Block 32, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum01_Byte01_Animated("Block 32, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum02_Byte00_Animated("Block 32, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum02_Byte01_Animated("Block 32, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum03_Byte00_Animated("Block 32, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum03_Byte01_Animated("Block 32, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum04_Byte00_Animated("Block 32, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block32_Datum04_Byte01_Animated("Block 32, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block33_Datum00_Byte00_Animated("Block 33, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum00_Byte01_Animated("Block 33, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum01_Byte00_Animated("Block 33, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum01_Byte01_Animated("Block 33, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum02_Byte00_Animated("Block 33, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum02_Byte01_Animated("Block 33, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum03_Byte00_Animated("Block 33, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum03_Byte01_Animated("Block 33, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum04_Byte00_Animated("Block 33, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block33_Datum04_Byte01_Animated("Block 33, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block34_Datum00_Byte00_Animated("Block 34, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum00_Byte01_Animated("Block 34, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum01_Byte00_Animated("Block 34, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum01_Byte01_Animated("Block 34, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum02_Byte00_Animated("Block 34, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum02_Byte01_Animated("Block 34, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum03_Byte00_Animated("Block 34, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum03_Byte01_Animated("Block 34, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum04_Byte00_Animated("Block 34, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block34_Datum04_Byte01_Animated("Block 34, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block35_Datum00_Byte00_Animated("Block 35, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum00_Byte01_Animated("Block 35, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum01_Byte00_Animated("Block 35, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum01_Byte01_Animated("Block 35, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum02_Byte00_Animated("Block 35, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum02_Byte01_Animated("Block 35, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum03_Byte00_Animated("Block 35, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum03_Byte01_Animated("Block 35, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum04_Byte00_Animated("Block 35, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block35_Datum04_Byte01_Animated("Block 35, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block36_Datum00_Byte00_Animated("Block 36, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum00_Byte01_Animated("Block 36, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum01_Byte00_Animated("Block 36, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum01_Byte01_Animated("Block 36, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum02_Byte00_Animated("Block 36, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum02_Byte01_Animated("Block 36, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum03_Byte00_Animated("Block 36, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum03_Byte01_Animated("Block 36, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum04_Byte00_Animated("Block 36, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block36_Datum04_Byte01_Animated("Block 36, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block37_Datum00_Byte00_Animated("Block 37, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum00_Byte01_Animated("Block 37, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum01_Byte00_Animated("Block 37, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum01_Byte01_Animated("Block 37, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum02_Byte00_Animated("Block 37, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum02_Byte01_Animated("Block 37, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum03_Byte00_Animated("Block 37, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum03_Byte01_Animated("Block 37, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum04_Byte00_Animated("Block 37, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block37_Datum04_Byte01_Animated("Block 37, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block38_Datum00_Byte00_Animated("Block 38, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum00_Byte01_Animated("Block 38, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum01_Byte00_Animated("Block 38, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum01_Byte01_Animated("Block 38, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum02_Byte00_Animated("Block 38, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum02_Byte01_Animated("Block 38, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum03_Byte00_Animated("Block 38, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum03_Byte01_Animated("Block 38, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum04_Byte00_Animated("Block 38, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block38_Datum04_Byte01_Animated("Block 38, Datum 04, Byte 01", Range(0,255)) = 255

          _Unigram_Letter_Grid_Data_Block39_Datum00_Byte00_Animated("Block 39, Datum 00, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum00_Byte01_Animated("Block 39, Datum 00, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum01_Byte00_Animated("Block 39, Datum 01, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum01_Byte01_Animated("Block 39, Datum 01, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum02_Byte00_Animated("Block 39, Datum 02, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum02_Byte01_Animated("Block 39, Datum 02, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum03_Byte00_Animated("Block 39, Datum 03, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum03_Byte01_Animated("Block 39, Datum 03, Byte 01", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum04_Byte00_Animated("Block 39, Datum 04, Byte 00", Range(0,255)) = 255
          _Unigram_Letter_Grid_Data_Block39_Datum04_Byte01_Animated("Block 39, Datum 04, Byte 01", Range(0,255)) = 255

        [HideInInspector] m_end_Unigram_Letter_Grid("Unigram letter grid", Float) = 0
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
          _Tessellation_Factor("Factor", Range(1, 256)) = 1
          _Tessellation_Frustum_Culling_Bias("Frustum culling bias", Float) = 35
          [HideInInspector] m_start_Tessellation_Heightmap("Heightmap", Float) = 0
            [ThryToggle(_TESSELLATION_HEIGHTMAP_WORLD_SPACE)] _Tessellation_Heightmap_World_Space_Enabled("World space mode (RGB)", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_0("Heightmap 0", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_0)] _Tessellation_Heightmap_0_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_0("Heightmap 0", 2D) = "black" {}
              _Tessellation_Heightmap_0_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_0_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_0("Heightmap 0", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_1("Heightmap 1", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_1)] _Tessellation_Heightmap_1_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_1("Heightmap 1", 2D) = "black" {}
              _Tessellation_Heightmap_1_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_1_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_1("Heightmap 1", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_2("Heightmap 2", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_2)] _Tessellation_Heightmap_2_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_2("Heightmap 2", 2D) = "black" {}
              _Tessellation_Heightmap_2_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_2_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_2("Heightmap 2", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_3("Heightmap 3", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_3)] _Tessellation_Heightmap_3_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_3("Heightmap 3", 2D) = "black" {}
              _Tessellation_Heightmap_3_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_3_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_3("Heightmap 3", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_4("Heightmap 4", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_4)] _Tessellation_Heightmap_4_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_4("Heightmap 4", 2D) = "black" {}
              _Tessellation_Heightmap_4_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_4_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_4("Heightmap 4", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_5("Heightmap 5", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_5)] _Tessellation_Heightmap_5_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_5("Heightmap 5", 2D) = "black" {}
              _Tessellation_Heightmap_5_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_5_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_5("Heightmap 5", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_6("Heightmap 6", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_6)] _Tessellation_Heightmap_6_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_6("Heightmap 6", 2D) = "black" {}
              _Tessellation_Heightmap_6_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_6_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_6("Heightmap 6", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_7("Heightmap 7", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_7)] _Tessellation_Heightmap_7_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_7("Heightmap 7", 2D) = "black" {}
              _Tessellation_Heightmap_7_Scale("Scale", Float) = 1
              _Tessellation_Heightmap_7_Offset("Offset", Range(-1, 1)) = 0
            [HideInInspector] m_end_Tessellation_Heightmap_7("Heightmap 7", Float) = 0
            [HideInInspector] m_start_Tessellation_Heightmap_Direction_Control("Direction control", Float) = 0
              [ThryToggle(_TESSELLATION_HEIGHTMAP_DIRECTION_CONTROL)] _Tessellation_Heightmap_Direction_Control_Enabled("Enable", Float) = 0
              _Tessellation_Heightmap_Direction_Control_Vector("Direction (normal/tangent/binormal)", Vector) = (1, 0, 0)
            [HideInInspector] m_end_Tessellation_Heightmap_Direction_Control("Direction control", Float) = 0
          [HideInInspector] m_end_Tessellation_Heightmap("Heightmap", Float) = 0
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
          [ThryToggle(_MASKED_STENCIL1)] _Masked_Stencil1_Enabled("Enable", Float) = 0
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
          [ThryToggle(_MASKED_STENCIL2)] _Masked_Stencil2_Enabled("Enable", Float) = 0
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
          [ThryToggle(_MASKED_STENCIL3)] _Masked_Stencil3_Enabled("Enable", Float) = 0
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
          [ThryToggle(_MASKED_STENCIL4)] _Masked_Stencil4_Enabled("Enable", Float) = 0
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
        //ifex _Quasi_Shadows_Enabled==0
        [HideInInspector] m_start_Quasi_Shadows("Quasi Shadows", Float) = 0
          [ThryToggle(_QUASI_SHADOWS)] _Quasi_Shadows_Enabled("Enable", Float) = 0
          _Quasi_Shadows_0_Color("Color 0", Color) = (1, 1, 1, 1)
          _Quasi_Shadows_0_Threshold("Threshold 0", Range(0, 1)) = 0.5
          _Quasi_Shadows_0_Width("Width 0", Range(0, 1)) = 0.1
        [HideInInspector] m_end_Quasi_Shadows("Quasi Shadows", Float) = 0
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
        //ifex _Bakery_Enabled==0
        [HideInInspector] m_start_Bakery("Bakery Lightmapping", Float) = 0
          [ThryToggle(_BAKERY)] _Bakery_Enabled("Enable", Float) = 0
          [ThryToggle(_BAKERY_RNM)] _Bakery_RNM_Enabled("RNM", Float) = 0
          [ThryToggle(_BAKERY_SH)] _Bakery_SH_Enabled("SH", Float) = 0
          [ThryToggle(_BAKERY_MONOSH)] _Bakery_MONOSH_Enabled("MonoSH", Float) = 0
        [HideInInspector] m_end_Bakery("Bakery Lightmapping", Float) = 0
        //endex
        //ifex _Grayscale_Lightmaps_Enabled==0
        [HideInInspector] m_start_Grayscale_Lightmaps("Grayscale Lightmaps", Float) = 0
          [ThryToggle(_GRAYSCALE_LIGHTMAPS)] _Grayscale_Lightmaps_Enabled("Enable", Float) = 0
        [HideInInspector] m_end_Grayscale_Lightmaps("Grayscale Lightmaps", Float) = 0
        //endex

      [HideInInspector] m_renderingOptions("Rendering Options", Float) = 0

      [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", Float) = 2
      [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 4
      [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Source Blend", Float) = 1
      [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Destination Blend", Float) = 0
      [Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Int) = 1

      //ifex _Receive_Shadows_Enabled==0
      [HideInInspector] m_start_Shadow_Receiving("Receive shadows", Float) = 0
      [ThryToggle(_RECEIVE_SHADOWS)] _Receive_Shadows_Enabled("Enable", Float) = 1
      _Shadow_Strength("Shadow strength", Range(0, 1)) = 0.25
      [HideInInspector] m_end_Shadow_Receiving("Shadows", Float) = 0
      //endex
      //ifex _Cast_Shadows_Enabled==0
      [HideInInspector] m_start_Shadow_Casting("Cast shadows", Float) = 0
      [ThryToggle(_CAST_SHADOWS)] _Cast_Shadows_Enabled("Enable", Float) = 1
      [HideInInspector] m_end_Shadow_Casting("Cast shadows", Float) = 0
      //endex

      //ifex _Screen_Space_Normals_Enabled==0
      [HideInInspector] m_start_Screen_Space_Normals("Screen Space Normals", Float) = 0
        [ThryToggle(_SCREEN_SPACE_NORMALS)] _Screen_Space_Normals_Enabled("Enable", Float) = 0
      [HideInInspector] m_end_Screen_Space_Normals("Screen Space Normals", Float) = 0
      //endex

      //ifex _Depth_Prepass_Enabled==0
      [HideInInspector] m_start_Depth_Prepass("Depth Prepass", Float) = 0
        [ThryToggle(_DEPTH_PREPASS)] _Depth_Prepass_Enabled("Enable", Float) = 0
      [HideInInspector] m_end_Depth_Prepass("Depth Prepass", Float) = 0
      //endex

      //ifex _Unlit_Enabled==0
      [HideInInspector] m_start_Unlit("Unlit", Float) = 0
        [ThryToggle(_UNLIT)] _Unlit_Enabled("Enable", Float) = 0
      [HideInInspector] m_end_Unlit("Unlit", Float) = 0
      //endex

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
    [ThryWideEnum(Water, 0.35, Skin, 0.42, Eyes, 0.39, Hair, 0.54, Teeth, 0.6, Fabric, 0.55, Stone, 0.55, Plastic, 0.50, Glass, 0.56, Gemstone, 0.9, Diamond, 1.0)]_reflectance("Reflectance", Float) = 0.55
    _ExposureOcclusion("Exposure Occlusion", Float) = 1
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
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "VRCFallback" = "Standard" "DisableBatching" = "True" }

    //ifex _Depth_Prepass_Enabled==0
    Pass {
      Name "DEPTHPREPASS"
      Tags { }

      ColorMask 0
      ZWrite On
      ZTest LEqual
      Cull [_Cull]

      CGPROGRAM
      #pragma target 5.0
      #pragma multi_compile_instancing
      #pragma vertex vert
      #pragma fragment frag

      //ifex _Tessellation_Enabled==0
      #pragma hull hull
      #pragma domain domain
      //endex

      #define DEPTH_PREPASS

      #include "2ner.cginc"
      ENDCG
    }
    //endex
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
      //ifex _Depth_Prepass_Enabled==0
      ZTest LEqual
      //endex
      //ifex _Depth_Prepass_Enabled!=0
      ZTest [_ZTest]
      //endex

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
      #pragma multi_compile_fwdbase
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
    //ifex _Cast_Shadows_Enabled==0
    Pass {
      Tags { "LightMode" = "ShadowCaster" }

      CGPROGRAM
      #pragma multi_compile_instancing
      #pragma multi_compile_shadowcaster
      #pragma multi_compile_fog
			#pragma vertex vert
			#pragma fragment frag

			#include "mochie_shadow_caster.cginc"
      ENDCG
    }
    //endex
    Pass {
      Name "META"
      Tags { "LightMode" = "Meta" }

      Cull Off

      CGPROGRAM
      #pragma vertex vert_meta
      #pragma fragment frag_meta
      #pragma shader_feature _EMISSION
      #pragma shader_feature _METALLICGLOSSMAP
      #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

      #define META_PASS
      #include "UnityStandardMeta.cginc"
      ENDCG
    }
  }
  CustomEditor "Thry.ShaderEditor"
}
