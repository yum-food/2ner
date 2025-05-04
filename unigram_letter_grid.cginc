#ifndef __UNIGRAM_LETTER_GRID_INC
#define __UNIGRAM_LETTER_GRID_INC

#if defined(_UNIGRAM_LETTER_GRID)

#include "disinfo.cginc"
#include "features.cginc"
#include "globals.cginc"
#include "interpolators.cginc"
#include "math.cginc"
#include "texture_utils.cginc"

// ULD = unigram letter grid
// Block width = number of tokens sent per block
#define ULD_BLOCK_WIDTH 5
// Num blocks = total # of blocks in memory
#define ULD_NUM_BLOCKS 10

texture2D _Unigram_Letter_Grid_Glyphs;
float4    _Unigram_Letter_Grid_Glyphs_TexelSize;
texture2D _Unigram_Letter_Grid_LUT;
float4    _Unigram_Letter_Grid_LUT_TexelSize;
float _Unigram_Letter_Grid_Tex_Res_X;
float _Unigram_Letter_Grid_Tex_Res_Y;
float _Unigram_Letter_Grid_Res_X;
float _Unigram_Letter_Grid_Res_Y;
float4 _Unigram_Letter_Grid_UV_Scale_Offset;
float _Unigram_Letter_Grid_Padding;
float _Unigram_Letter_Grid_Screen_Px_Range;
float _Unigram_Letter_Grid_Min_Screen_Px_Range;
float _Unigram_Letter_Grid_Blurriness;
float _Unigram_Letter_Grid_Alpha_Threshold;

// For posterity: this syntax is called "cbuffer aliasing".
// The purpose here is to map a bunch of material properties onto an indexable
// array (the first element of the cbuffer).
cbuffer UnigramLetterGridVisualPointers
{
  float _Unigram_Letter_Visual_Pointers[ULD_NUM_BLOCKS] : packoffset(c0);
  float _Unigram_Letter_Grid_Block00_Visual_Pointer : packoffset(c0);
  float _Unigram_Letter_Grid_Block01_Visual_Pointer : packoffset(c1);
  float _Unigram_Letter_Grid_Block02_Visual_Pointer : packoffset(c2);
  float _Unigram_Letter_Grid_Block03_Visual_Pointer : packoffset(c3);
  float _Unigram_Letter_Grid_Block04_Visual_Pointer : packoffset(c4);
  float _Unigram_Letter_Grid_Block05_Visual_Pointer : packoffset(c5);
  float _Unigram_Letter_Grid_Block06_Visual_Pointer : packoffset(c6);
  float _Unigram_Letter_Grid_Block07_Visual_Pointer : packoffset(c7);
  float _Unigram_Letter_Grid_Block08_Visual_Pointer : packoffset(c8);
  float _Unigram_Letter_Grid_Block09_Visual_Pointer : packoffset(c9);
}

cbuffer UnigramLetterGridDataByte00
{
  float _Unigram_Letter_Data_Byte00[ULD_NUM_BLOCKS][ULD_BLOCK_WIDTH] : packoffset(c0);

  float _Unigram_Letter_Grid_Data_Block00_Datum00_Byte00 : packoffset(c0);
  float _Unigram_Letter_Grid_Data_Block00_Datum01_Byte00 : packoffset(c1);
  float _Unigram_Letter_Grid_Data_Block00_Datum02_Byte00 : packoffset(c2);
  float _Unigram_Letter_Grid_Data_Block00_Datum03_Byte00 : packoffset(c3);
  float _Unigram_Letter_Grid_Data_Block00_Datum04_Byte00 : packoffset(c4);

  float _Unigram_Letter_Grid_Data_Block01_Datum00_Byte00 : packoffset(c5);
  float _Unigram_Letter_Grid_Data_Block01_Datum01_Byte00 : packoffset(c6);
  float _Unigram_Letter_Grid_Data_Block01_Datum02_Byte00 : packoffset(c7);
  float _Unigram_Letter_Grid_Data_Block01_Datum03_Byte00 : packoffset(c8);
  float _Unigram_Letter_Grid_Data_Block01_Datum04_Byte00 : packoffset(c9);

  float _Unigram_Letter_Grid_Data_Block02_Datum00_Byte00 : packoffset(c10);
  float _Unigram_Letter_Grid_Data_Block02_Datum01_Byte00 : packoffset(c11);
  float _Unigram_Letter_Grid_Data_Block02_Datum02_Byte00 : packoffset(c12);
  float _Unigram_Letter_Grid_Data_Block02_Datum03_Byte00 : packoffset(c13);
  float _Unigram_Letter_Grid_Data_Block02_Datum04_Byte00 : packoffset(c14);

  float _Unigram_Letter_Grid_Data_Block03_Datum00_Byte00 : packoffset(c15);
  float _Unigram_Letter_Grid_Data_Block03_Datum01_Byte00 : packoffset(c16);
  float _Unigram_Letter_Grid_Data_Block03_Datum02_Byte00 : packoffset(c17);
  float _Unigram_Letter_Grid_Data_Block03_Datum03_Byte00 : packoffset(c18);
  float _Unigram_Letter_Grid_Data_Block03_Datum04_Byte00 : packoffset(c19);

  float _Unigram_Letter_Grid_Data_Block04_Datum00_Byte00 : packoffset(c20);
  float _Unigram_Letter_Grid_Data_Block04_Datum01_Byte00 : packoffset(c21);
  float _Unigram_Letter_Grid_Data_Block04_Datum02_Byte00 : packoffset(c22);
  float _Unigram_Letter_Grid_Data_Block04_Datum03_Byte00 : packoffset(c23);
  float _Unigram_Letter_Grid_Data_Block04_Datum04_Byte00 : packoffset(c24);

  float _Unigram_Letter_Grid_Data_Block05_Datum00_Byte00 : packoffset(c25);
  float _Unigram_Letter_Grid_Data_Block05_Datum01_Byte00 : packoffset(c26);
  float _Unigram_Letter_Grid_Data_Block05_Datum02_Byte00 : packoffset(c27);
  float _Unigram_Letter_Grid_Data_Block05_Datum03_Byte00 : packoffset(c28);
  float _Unigram_Letter_Grid_Data_Block05_Datum04_Byte00 : packoffset(c29);

  float _Unigram_Letter_Grid_Data_Block06_Datum00_Byte00 : packoffset(c30);
  float _Unigram_Letter_Grid_Data_Block06_Datum01_Byte00 : packoffset(c31);
  float _Unigram_Letter_Grid_Data_Block06_Datum02_Byte00 : packoffset(c32);
  float _Unigram_Letter_Grid_Data_Block06_Datum03_Byte00 : packoffset(c33);
  float _Unigram_Letter_Grid_Data_Block06_Datum04_Byte00 : packoffset(c34);

  float _Unigram_Letter_Grid_Data_Block07_Datum00_Byte00 : packoffset(c35);
  float _Unigram_Letter_Grid_Data_Block07_Datum01_Byte00 : packoffset(c36);
  float _Unigram_Letter_Grid_Data_Block07_Datum02_Byte00 : packoffset(c37);
  float _Unigram_Letter_Grid_Data_Block07_Datum03_Byte00 : packoffset(c38);
  float _Unigram_Letter_Grid_Data_Block07_Datum04_Byte00 : packoffset(c39);

  float _Unigram_Letter_Grid_Data_Block08_Datum00_Byte00 : packoffset(c40);
  float _Unigram_Letter_Grid_Data_Block08_Datum01_Byte00 : packoffset(c41);
  float _Unigram_Letter_Grid_Data_Block08_Datum02_Byte00 : packoffset(c42);
  float _Unigram_Letter_Grid_Data_Block08_Datum03_Byte00 : packoffset(c43);
  float _Unigram_Letter_Grid_Data_Block08_Datum04_Byte00 : packoffset(c44);

  float _Unigram_Letter_Grid_Data_Block09_Datum00_Byte00 : packoffset(c45);
  float _Unigram_Letter_Grid_Data_Block09_Datum01_Byte00 : packoffset(c46);
  float _Unigram_Letter_Grid_Data_Block09_Datum02_Byte00 : packoffset(c47);
  float _Unigram_Letter_Grid_Data_Block09_Datum03_Byte00 : packoffset(c48);
  float _Unigram_Letter_Grid_Data_Block09_Datum04_Byte00 : packoffset(c49);
}

cbuffer UnigramLetterGridDataByte01
{
  float _Unigram_Letter_Data_Byte01[ULD_NUM_BLOCKS][ULD_BLOCK_WIDTH] : packoffset(c0);

  float _Unigram_Letter_Grid_Data_Block00_Datum00_Byte01 : packoffset(c0);
  float _Unigram_Letter_Grid_Data_Block00_Datum01_Byte01 : packoffset(c1);
  float _Unigram_Letter_Grid_Data_Block00_Datum02_Byte01 : packoffset(c2);
  float _Unigram_Letter_Grid_Data_Block00_Datum03_Byte01 : packoffset(c3);
  float _Unigram_Letter_Grid_Data_Block00_Datum04_Byte01 : packoffset(c4);

  float _Unigram_Letter_Grid_Data_Block01_Datum00_Byte01 : packoffset(c5);
  float _Unigram_Letter_Grid_Data_Block01_Datum01_Byte01 : packoffset(c6);
  float _Unigram_Letter_Grid_Data_Block01_Datum02_Byte01 : packoffset(c7);
  float _Unigram_Letter_Grid_Data_Block01_Datum03_Byte01 : packoffset(c8);
  float _Unigram_Letter_Grid_Data_Block01_Datum04_Byte01 : packoffset(c9);

  float _Unigram_Letter_Grid_Data_Block02_Datum00_Byte01 : packoffset(c10);
  float _Unigram_Letter_Grid_Data_Block02_Datum01_Byte01 : packoffset(c11);
  float _Unigram_Letter_Grid_Data_Block02_Datum02_Byte01 : packoffset(c12);
  float _Unigram_Letter_Grid_Data_Block02_Datum03_Byte01 : packoffset(c13);
  float _Unigram_Letter_Grid_Data_Block02_Datum04_Byte01 : packoffset(c14);

  float _Unigram_Letter_Grid_Data_Block03_Datum00_Byte01 : packoffset(c15);
  float _Unigram_Letter_Grid_Data_Block03_Datum01_Byte01 : packoffset(c16);
  float _Unigram_Letter_Grid_Data_Block03_Datum02_Byte01 : packoffset(c17);
  float _Unigram_Letter_Grid_Data_Block03_Datum03_Byte01 : packoffset(c18);
  float _Unigram_Letter_Grid_Data_Block03_Datum04_Byte01 : packoffset(c19);

  float _Unigram_Letter_Grid_Data_Block04_Datum00_Byte01 : packoffset(c20);
  float _Unigram_Letter_Grid_Data_Block04_Datum01_Byte01 : packoffset(c21);
  float _Unigram_Letter_Grid_Data_Block04_Datum02_Byte01 : packoffset(c22);
  float _Unigram_Letter_Grid_Data_Block04_Datum03_Byte01 : packoffset(c23);
  float _Unigram_Letter_Grid_Data_Block04_Datum04_Byte01 : packoffset(c24);

  float _Unigram_Letter_Grid_Data_Block05_Datum00_Byte01 : packoffset(c25);
  float _Unigram_Letter_Grid_Data_Block05_Datum01_Byte01 : packoffset(c26);
  float _Unigram_Letter_Grid_Data_Block05_Datum02_Byte01 : packoffset(c27);
  float _Unigram_Letter_Grid_Data_Block05_Datum03_Byte01 : packoffset(c28);
  float _Unigram_Letter_Grid_Data_Block05_Datum04_Byte01 : packoffset(c29);

  float _Unigram_Letter_Grid_Data_Block06_Datum00_Byte01 : packoffset(c30);
  float _Unigram_Letter_Grid_Data_Block06_Datum01_Byte01 : packoffset(c31);
  float _Unigram_Letter_Grid_Data_Block06_Datum02_Byte01 : packoffset(c32);
  float _Unigram_Letter_Grid_Data_Block06_Datum03_Byte01 : packoffset(c33);
  float _Unigram_Letter_Grid_Data_Block06_Datum04_Byte01 : packoffset(c34);

  float _Unigram_Letter_Grid_Data_Block07_Datum00_Byte01 : packoffset(c35);
  float _Unigram_Letter_Grid_Data_Block07_Datum01_Byte01 : packoffset(c36);
  float _Unigram_Letter_Grid_Data_Block07_Datum02_Byte01 : packoffset(c37);
  float _Unigram_Letter_Grid_Data_Block07_Datum03_Byte01 : packoffset(c38);
  float _Unigram_Letter_Grid_Data_Block07_Datum04_Byte01 : packoffset(c39);

  float _Unigram_Letter_Grid_Data_Block08_Datum00_Byte01 : packoffset(c40);
  float _Unigram_Letter_Grid_Data_Block08_Datum01_Byte01 : packoffset(c41);
  float _Unigram_Letter_Grid_Data_Block08_Datum02_Byte01 : packoffset(c42);
  float _Unigram_Letter_Grid_Data_Block08_Datum03_Byte01 : packoffset(c43);
  float _Unigram_Letter_Grid_Data_Block08_Datum04_Byte01 : packoffset(c44);

  float _Unigram_Letter_Grid_Data_Block09_Datum00_Byte01 : packoffset(c45);
  float _Unigram_Letter_Grid_Data_Block09_Datum01_Byte01 : packoffset(c46);
  float _Unigram_Letter_Grid_Data_Block09_Datum02_Byte01 : packoffset(c47);
  float _Unigram_Letter_Grid_Data_Block09_Datum03_Byte01 : packoffset(c48);
  float _Unigram_Letter_Grid_Data_Block09_Datum04_Byte01 : packoffset(c49);
}

void GetBlock(uint which_block, out uint data[ULD_BLOCK_WIDTH]) {
  [loop]
  for (uint i = 0; i < ULD_BLOCK_WIDTH; i++) {
    data[i]  = ((uint) _Unigram_Letter_Data_Byte00[which_block][i]);
    data[i] |= ((uint) _Unigram_Letter_Data_Byte01[which_block][i]) << 8;
  }
}

// Get the tokens that cover `screen_ptr`. Also return `block_ptr`, the
// location where this block of tokens begins.
void GetTokens(uint screen_ptr,
    out uint block_ptr,
    out uint tokens[ULD_BLOCK_WIDTH]) {
  block_ptr = 0;
  uint which_block = 0;
  [loop]
  for (uint i = 0; i < ULD_BLOCK_WIDTH; i++) {
    if (screen_ptr >= _Unigram_Letter_Visual_Pointers[i]) {
      block_ptr = _Unigram_Letter_Visual_Pointers[i];
      which_block = i;
    }
  }
  GetBlock(which_block, tokens);
}

uint2 FoldIndex(uint flat_idx, uint img_res) {
  return uint2(flat_idx % img_res, floor(flat_idx / img_res));
}

uint UnfoldIndex(uint2 coord, uint img_res) {
  return coord[0] + coord[1] * img_res;
}

float2 GetUnigramLutUV(uint idx)
{
  // Remap from [0,  65535] to [0, 511] x [0,511].
  // Note that the LUT is square.
  uint2 idx_2d = FoldIndex(idx, _Unigram_Letter_Grid_LUT_TexelSize.z);
  // Remap onto [0, 1] x [0, 1].
  float2 uv = idx_2d * _Unigram_Letter_Grid_LUT_TexelSize.xy;
  // Center the UV coordinate in its texel.
  uv += _Unigram_Letter_Grid_LUT_TexelSize.x * 0.5;
  // uvs have 0,0 at bottom left. LUT has 0,0 at top left. yerr.
  uv.y = 1.0 - uv.y;
  return uv;
}

// Gets the length of the subword encoded by the token. Performs one texture
// tap.
void TokenLengthOffset(uint token,
    out uint length, out uint offset)
{
  float2 token_uv = GetUnigramLutUV(token);
  // Header has this format:
  //      rgba = ((tok_ptr >>  0) & 0xFF,
  //              (tok_ptr >>  8) & 0xFF,
  //              (tok_ptr >> 16) & 0xFF,
  //              tok_len)
  uint4 rgba = (uint4) (_Unigram_Letter_Grid_LUT.SampleLevel(point_repeat_s, token_uv, 0) * 255.0);
  offset  = (rgba[0] <<  0);
  offset |= (rgba[1] <<  8);
  offset |= (rgba[2] << 16);
  length = rgba[3];
}

// Gets the nth character of the token stored at `token_offset`.
uint GetTokenChar(uint token_offset, uint nth)
{
  // We store 4 characters per pixel (RGBA texture).
  token_offset += floor(nth / 4.0);
  float2 token_uv = GetUnigramLutUV(token_offset);
  uint4 chars = (uint4) (_Unigram_Letter_Grid_LUT.SampleLevel(point_repeat_s, token_uv, 0) * 255.0);
  return chars[nth % 4];
}

// Get the character which covers the screen position.
uint GetChar(uint screen_ptr) {
  uint block_ptr;
  uint tokens[ULD_BLOCK_WIDTH];
  GetTokens(screen_ptr, block_ptr, tokens);
  // Begin scanning at the start of the block.
  uint start = block_ptr;
  uint covering_token = 0;
  uint token_ptr = block_ptr;
  uint token_offset;
  for (uint i = 0; i < ULD_BLOCK_WIDTH; i++) {
    uint token_length;
    TokenLengthOffset(tokens[i], token_length, token_offset);
    if (token_ptr + token_length >= screen_ptr) {
      covering_token = tokens[i];
    }
    token_ptr += token_length;
  }
  uint nth_char = screen_ptr - token_ptr;
  return GetTokenChar(token_offset, nth_char);
}

struct UnigramLetterGridOutput {
  float4 albedo;
  float metallic;
  float roughness;
  float3 emission;
};

UnigramLetterGridOutput UnigramLetterGrid(v2f i) {
    UnigramLetterGridOutput output;
    
    int2 cell_pos;
    int2 font_res = int2(round(_Unigram_Letter_Grid_Tex_Res_X), round(_Unigram_Letter_Grid_Tex_Res_Y));
    int2 grid_res = int2(round(_Unigram_Letter_Grid_Res_X), round(_Unigram_Letter_Grid_Res_Y));
    float2 cell_uv;  // uv within each letter cell

    float4 scoff = _Unigram_Letter_Grid_UV_Scale_Offset;
    float2 uv = ((i.uv01.xy - 0.5) - scoff.zw) * scoff.xy + 0.5;

    bool in_box = getBoxLoc(uv, 0, 1, grid_res, _Unigram_Letter_Grid_Padding, cell_pos, cell_uv);
    cell_pos.y = (grid_res.y - cell_pos.y) - 1;

    //float c = GetChar(cell_pos.x) + '0';
    // DEBUG: show the token offset and length for the first 4 tokens.
    uint tok_len, tok_off;
    TokenLengthOffset(cell_pos.y, tok_len, tok_off);
    float c;
    switch (cell_pos.x % 4) {
      case 0:
        c = tok_off & 0xff;
        break;
      case 1:
        c = (tok_off >> 8) & 0xff;
        break;
      case 2:
        c = (tok_off >> 16) & 0xff;
        break;
      case 3:
        c = tok_len;
        break;
    }
    c += '0';

    float3 msd = renderInBox(c, uv, cell_uv, _Unigram_Letter_Grid_Glyphs, font_res).rgb;
    float sd = median(msd);
    
    // Calculate screen pixel range
    float screen_px_range;
    {
        float2 tex_size = float2(_Unigram_Letter_Grid_Glyphs_TexelSize.zw);
        float2 real_cell_size = floor(tex_size / grid_res);  // size of cell in texels
        float2 unit_range = _Unigram_Letter_Grid_Screen_Px_Range / real_cell_size;
        float2 screen_tex_size = 1 / fwidth(cell_uv);
        screen_px_range = max(0.5 * dot(unit_range, screen_tex_size), _Unigram_Letter_Grid_Min_Screen_Px_Range);
    }
    
    float screen_px_distance = screen_px_range * (sd - _Unigram_Letter_Grid_Alpha_Threshold);
    float smooth_range = (length(grid_res) / sqrt(screen_px_range)) * _Unigram_Letter_Grid_Blurriness;
    float op = smoothstep(-smooth_range, smooth_range, screen_px_distance);

    // Apply blending to output
    output.albedo = float4(float3(1,1,1), op * in_box);
    output.metallic = 0;
    output.roughness = 1;
    output.emission = 0;
    
    return output;
}

#endif  // _UNIGRAM_LETTER_GRID
#endif  // __UNIGRAM_LETTER_GRID_INC

