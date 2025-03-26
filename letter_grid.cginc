#ifndef __LETTER_GRID_INC
#define __LETTER_GRID_INC

#include "disinfo.cginc"
#include "features.cginc"
#include "globals.cginc"
#include "interpolators.cginc"
#include "math.cginc"
#include "texture_utils.cginc"

#if defined(_LETTER_GRID)

struct LetterGridOutput {
  float4 albedo;
  float metallic;
  float roughness;
  float3 emission;
};

LetterGridOutput LetterGrid(v2f i) {
    LetterGridOutput output;
    
    int2 cell_pos;
    int2 font_res = int2(round(_Letter_Grid_Tex_Res_X), round(_Letter_Grid_Tex_Res_Y));
    int2 grid_res = int2(round(_Letter_Grid_Res_X), round(_Letter_Grid_Res_Y));
    float2 cell_uv;  // uv within each letter cell

    float4 scoff = _Letter_Grid_UV_Scale_Offset;
    float2 uv = ((i.uv01.xy - 0.5) - scoff.zw) * scoff.xy + 0.5;

    bool in_box = getBoxLoc(uv, 0, 1, grid_res, _Letter_Grid_Padding, cell_pos, cell_uv);

    // Extract char from _Letter_Grid_Data_Row_0 et al using cell_pos.
    cell_pos.y = (grid_res.y - cell_pos.y) - 1;
    float c = lerp(
        lerp(
        _Letter_Grid_Data_Row_0[cell_pos.x],
        _Letter_Grid_Data_Row_1[cell_pos.x],
        cell_pos.y),
        lerp(
        _Letter_Grid_Data_Row_2[cell_pos.x],
        _Letter_Grid_Data_Row_3[cell_pos.x],
        cell_pos.y - 2),
        cell_pos.y/2);
    c += _Letter_Grid_Global_Offset;

    float3 msd = renderInBox(c, uv, cell_uv, _Letter_Grid_Texture, font_res).rgb;
    float sd = median(msd);
    
    // Calculate screen pixel range
    float screen_px_range;
    {
        float2 tex_size = float2(_Letter_Grid_Texture_TexelSize.zw);
        float2 real_cell_size = floor(tex_size / grid_res);  // size of cell in texels
        float2 unit_range = _Letter_Grid_Screen_Px_Range / real_cell_size;
        float2 screen_tex_size = 1 / fwidth(cell_uv);
        screen_px_range = max(0.5 * dot(unit_range, screen_tex_size), _Letter_Grid_Min_Screen_Px_Range);
    }
    
    float screen_px_distance = screen_px_range * (sd - _Letter_Grid_Alpha_Threshold);
    float smooth_range = (length(grid_res) / sqrt(screen_px_range)) * _Letter_Grid_Blurriness;
    float op = smoothstep(-smooth_range, smooth_range, screen_px_distance);
    
    // Sample mask if enabled
    #if defined(_LETTER_GRID_MASK)
    float mask = _Letter_Grid_Mask.Sample(linear_repeat_s, i.uv01.xy).r;
    #else
    float mask = 1.0;
    #endif
    
    op *= mask;

    // Apply blending to output
    output.albedo = float4(_Letter_Grid_Color.rgb, op * in_box);
    output.metallic = _Letter_Grid_Metallic;
    output.roughness = _Letter_Grid_Roughness;
    output.emission = _Letter_Grid_Color.rgb * _Letter_Grid_Emission;
    
    return output;
}

#endif  // _LETTER_GRID

#endif  // __LETTER_GRID_INC

