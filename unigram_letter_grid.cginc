#ifndef __UNIGRAM_LETTER_GRID_INC
#define __UNIGRAM_LETTER_GRID_INC

#if defined(_UNIGRAM_LETTER_GRID)

#include "disinfo.cginc"
#include "features.cginc"
#include "globals.cginc"
#include "interpolators.cginc"
#include "math.cginc"
#include "oklab.cginc"
#include "texture_utils.cginc"

// ULG = unigram letter grid
// Block width = number of tokens sent per block
#define ULG_BLOCK_WIDTH 5
// Num blocks = total # of blocks in memory
#define ULG_NUM_BLOCKS 40
// The data coming from the animator can be a little noisy. Add this then floor
// to mask it out.
#define FUDGE_AMOUNT 0.5

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
float _Unigram_Letter_Grid_Alpha_Threshold;

// These macros exist for debugging.
#define ULG_VP
#define ULG_D0
#define ULG_D1

#if defined(ULG_VP)
// For posterity: this syntax is called "cbuffer aliasing".
// The purpose here is to map a bunch of material properties onto an indexable
// array (the first element of the cbuffer).
cbuffer UnigramLetterGridVisualPointers
{
  float _Unigram_Letter_Visual_Pointers[ULG_NUM_BLOCKS] : packoffset(c0);
  float _Unigram_Letter_Grid_Block00_Visual_Pointer_Animated : packoffset(c0);
  float _Unigram_Letter_Grid_Block01_Visual_Pointer_Animated : packoffset(c1);
  float _Unigram_Letter_Grid_Block02_Visual_Pointer_Animated : packoffset(c2);
  float _Unigram_Letter_Grid_Block03_Visual_Pointer_Animated : packoffset(c3);
  float _Unigram_Letter_Grid_Block04_Visual_Pointer_Animated : packoffset(c4);
  float _Unigram_Letter_Grid_Block05_Visual_Pointer_Animated : packoffset(c5);
  float _Unigram_Letter_Grid_Block06_Visual_Pointer_Animated : packoffset(c6);
  float _Unigram_Letter_Grid_Block07_Visual_Pointer_Animated : packoffset(c7);
  float _Unigram_Letter_Grid_Block08_Visual_Pointer_Animated : packoffset(c8);
  float _Unigram_Letter_Grid_Block09_Visual_Pointer_Animated : packoffset(c9);
  float _Unigram_Letter_Grid_Block10_Visual_Pointer_Animated : packoffset(c10);
  float _Unigram_Letter_Grid_Block11_Visual_Pointer_Animated : packoffset(c11);
  float _Unigram_Letter_Grid_Block12_Visual_Pointer_Animated : packoffset(c12);
  float _Unigram_Letter_Grid_Block13_Visual_Pointer_Animated : packoffset(c13);
  float _Unigram_Letter_Grid_Block14_Visual_Pointer_Animated : packoffset(c14);
  float _Unigram_Letter_Grid_Block15_Visual_Pointer_Animated : packoffset(c15);
  float _Unigram_Letter_Grid_Block16_Visual_Pointer_Animated : packoffset(c16);
  float _Unigram_Letter_Grid_Block17_Visual_Pointer_Animated : packoffset(c17);
  float _Unigram_Letter_Grid_Block18_Visual_Pointer_Animated : packoffset(c18);
  float _Unigram_Letter_Grid_Block19_Visual_Pointer_Animated : packoffset(c19);
  float _Unigram_Letter_Grid_Block20_Visual_Pointer_Animated : packoffset(c20);
  float _Unigram_Letter_Grid_Block21_Visual_Pointer_Animated : packoffset(c21);
  float _Unigram_Letter_Grid_Block22_Visual_Pointer_Animated : packoffset(c22);
  float _Unigram_Letter_Grid_Block23_Visual_Pointer_Animated : packoffset(c23);
  float _Unigram_Letter_Grid_Block24_Visual_Pointer_Animated : packoffset(c24);
  float _Unigram_Letter_Grid_Block25_Visual_Pointer_Animated : packoffset(c25);
  float _Unigram_Letter_Grid_Block26_Visual_Pointer_Animated : packoffset(c26);
  float _Unigram_Letter_Grid_Block27_Visual_Pointer_Animated : packoffset(c27);
  float _Unigram_Letter_Grid_Block28_Visual_Pointer_Animated : packoffset(c28);
  float _Unigram_Letter_Grid_Block29_Visual_Pointer_Animated : packoffset(c29);
  float _Unigram_Letter_Grid_Block30_Visual_Pointer_Animated : packoffset(c30);
  float _Unigram_Letter_Grid_Block31_Visual_Pointer_Animated : packoffset(c31);
  float _Unigram_Letter_Grid_Block32_Visual_Pointer_Animated : packoffset(c32);
  float _Unigram_Letter_Grid_Block33_Visual_Pointer_Animated : packoffset(c33);
  float _Unigram_Letter_Grid_Block34_Visual_Pointer_Animated : packoffset(c34);
  float _Unigram_Letter_Grid_Block35_Visual_Pointer_Animated : packoffset(c35);
  float _Unigram_Letter_Grid_Block36_Visual_Pointer_Animated : packoffset(c36);
  float _Unigram_Letter_Grid_Block37_Visual_Pointer_Animated : packoffset(c37);
  float _Unigram_Letter_Grid_Block38_Visual_Pointer_Animated : packoffset(c38);
  float _Unigram_Letter_Grid_Block39_Visual_Pointer_Animated : packoffset(c39);
}
#endif  // ULG_VP

#if defined(ULG_D0)
cbuffer UnigramLetterGridDataByte00_Animated
{
  float _Unigram_Letter_Data_Byte00[ULG_NUM_BLOCKS * ULG_BLOCK_WIDTH] : packoffset(c0);

  float _Unigram_Letter_Grid_Data_Block00_Datum00_Byte00_Animated : packoffset(c0);
  float _Unigram_Letter_Grid_Data_Block00_Datum01_Byte00_Animated : packoffset(c1);
  float _Unigram_Letter_Grid_Data_Block00_Datum02_Byte00_Animated : packoffset(c2);
  float _Unigram_Letter_Grid_Data_Block00_Datum03_Byte00_Animated : packoffset(c3);
  float _Unigram_Letter_Grid_Data_Block00_Datum04_Byte00_Animated : packoffset(c4);
  float _Unigram_Letter_Grid_Data_Block01_Datum00_Byte00_Animated : packoffset(c5);
  float _Unigram_Letter_Grid_Data_Block01_Datum01_Byte00_Animated : packoffset(c6);
  float _Unigram_Letter_Grid_Data_Block01_Datum02_Byte00_Animated : packoffset(c7);
  float _Unigram_Letter_Grid_Data_Block01_Datum03_Byte00_Animated : packoffset(c8);
  float _Unigram_Letter_Grid_Data_Block01_Datum04_Byte00_Animated : packoffset(c9);

  float _Unigram_Letter_Grid_Data_Block02_Datum00_Byte00_Animated : packoffset(c10);
  float _Unigram_Letter_Grid_Data_Block02_Datum01_Byte00_Animated : packoffset(c11);
  float _Unigram_Letter_Grid_Data_Block02_Datum02_Byte00_Animated : packoffset(c12);
  float _Unigram_Letter_Grid_Data_Block02_Datum03_Byte00_Animated : packoffset(c13);
  float _Unigram_Letter_Grid_Data_Block02_Datum04_Byte00_Animated : packoffset(c14);
  float _Unigram_Letter_Grid_Data_Block03_Datum00_Byte00_Animated : packoffset(c15);
  float _Unigram_Letter_Grid_Data_Block03_Datum01_Byte00_Animated : packoffset(c16);
  float _Unigram_Letter_Grid_Data_Block03_Datum02_Byte00_Animated : packoffset(c17);
  float _Unigram_Letter_Grid_Data_Block03_Datum03_Byte00_Animated : packoffset(c18);
  float _Unigram_Letter_Grid_Data_Block03_Datum04_Byte00_Animated : packoffset(c19);

  float _Unigram_Letter_Grid_Data_Block04_Datum00_Byte00_Animated : packoffset(c20);
  float _Unigram_Letter_Grid_Data_Block04_Datum01_Byte00_Animated : packoffset(c21);
  float _Unigram_Letter_Grid_Data_Block04_Datum02_Byte00_Animated : packoffset(c22);
  float _Unigram_Letter_Grid_Data_Block04_Datum03_Byte00_Animated : packoffset(c23);
  float _Unigram_Letter_Grid_Data_Block04_Datum04_Byte00_Animated : packoffset(c24);
  float _Unigram_Letter_Grid_Data_Block05_Datum00_Byte00_Animated : packoffset(c25);
  float _Unigram_Letter_Grid_Data_Block05_Datum01_Byte00_Animated : packoffset(c26);
  float _Unigram_Letter_Grid_Data_Block05_Datum02_Byte00_Animated : packoffset(c27);
  float _Unigram_Letter_Grid_Data_Block05_Datum03_Byte00_Animated : packoffset(c28);
  float _Unigram_Letter_Grid_Data_Block05_Datum04_Byte00_Animated : packoffset(c29);

  float _Unigram_Letter_Grid_Data_Block06_Datum00_Byte00_Animated : packoffset(c30);
  float _Unigram_Letter_Grid_Data_Block06_Datum01_Byte00_Animated : packoffset(c31);
  float _Unigram_Letter_Grid_Data_Block06_Datum02_Byte00_Animated : packoffset(c32);
  float _Unigram_Letter_Grid_Data_Block06_Datum03_Byte00_Animated : packoffset(c33);
  float _Unigram_Letter_Grid_Data_Block06_Datum04_Byte00_Animated : packoffset(c34);
  float _Unigram_Letter_Grid_Data_Block07_Datum00_Byte00_Animated : packoffset(c35);
  float _Unigram_Letter_Grid_Data_Block07_Datum01_Byte00_Animated : packoffset(c36);
  float _Unigram_Letter_Grid_Data_Block07_Datum02_Byte00_Animated : packoffset(c37);
  float _Unigram_Letter_Grid_Data_Block07_Datum03_Byte00_Animated : packoffset(c38);
  float _Unigram_Letter_Grid_Data_Block07_Datum04_Byte00_Animated : packoffset(c39);

  float _Unigram_Letter_Grid_Data_Block08_Datum00_Byte00_Animated : packoffset(c40);
  float _Unigram_Letter_Grid_Data_Block08_Datum01_Byte00_Animated : packoffset(c41);
  float _Unigram_Letter_Grid_Data_Block08_Datum02_Byte00_Animated : packoffset(c42);
  float _Unigram_Letter_Grid_Data_Block08_Datum03_Byte00_Animated : packoffset(c43);
  float _Unigram_Letter_Grid_Data_Block08_Datum04_Byte00_Animated : packoffset(c44);
  float _Unigram_Letter_Grid_Data_Block09_Datum00_Byte00_Animated : packoffset(c45);
  float _Unigram_Letter_Grid_Data_Block09_Datum01_Byte00_Animated : packoffset(c46);
  float _Unigram_Letter_Grid_Data_Block09_Datum02_Byte00_Animated : packoffset(c47);
  float _Unigram_Letter_Grid_Data_Block09_Datum03_Byte00_Animated : packoffset(c48);
  float _Unigram_Letter_Grid_Data_Block09_Datum04_Byte00_Animated : packoffset(c49);

  float _Unigram_Letter_Grid_Data_Block10_Datum00_Byte00_Animated : packoffset(c50);
  float _Unigram_Letter_Grid_Data_Block10_Datum01_Byte00_Animated : packoffset(c51);
  float _Unigram_Letter_Grid_Data_Block10_Datum02_Byte00_Animated : packoffset(c52);
  float _Unigram_Letter_Grid_Data_Block10_Datum03_Byte00_Animated : packoffset(c53);
  float _Unigram_Letter_Grid_Data_Block10_Datum04_Byte00_Animated : packoffset(c54);
  float _Unigram_Letter_Grid_Data_Block11_Datum00_Byte00_Animated : packoffset(c55);
  float _Unigram_Letter_Grid_Data_Block11_Datum01_Byte00_Animated : packoffset(c56);
  float _Unigram_Letter_Grid_Data_Block11_Datum02_Byte00_Animated : packoffset(c57);
  float _Unigram_Letter_Grid_Data_Block11_Datum03_Byte00_Animated : packoffset(c58);
  float _Unigram_Letter_Grid_Data_Block11_Datum04_Byte00_Animated : packoffset(c59);

  float _Unigram_Letter_Grid_Data_Block12_Datum00_Byte00_Animated : packoffset(c60);
  float _Unigram_Letter_Grid_Data_Block12_Datum01_Byte00_Animated : packoffset(c61);
  float _Unigram_Letter_Grid_Data_Block12_Datum02_Byte00_Animated : packoffset(c62);
  float _Unigram_Letter_Grid_Data_Block12_Datum03_Byte00_Animated : packoffset(c63);
  float _Unigram_Letter_Grid_Data_Block12_Datum04_Byte00_Animated : packoffset(c64);
  float _Unigram_Letter_Grid_Data_Block13_Datum00_Byte00_Animated : packoffset(c65);
  float _Unigram_Letter_Grid_Data_Block13_Datum01_Byte00_Animated : packoffset(c66);
  float _Unigram_Letter_Grid_Data_Block13_Datum02_Byte00_Animated : packoffset(c67);
  float _Unigram_Letter_Grid_Data_Block13_Datum03_Byte00_Animated : packoffset(c68);
  float _Unigram_Letter_Grid_Data_Block13_Datum04_Byte00_Animated : packoffset(c69);

  float _Unigram_Letter_Grid_Data_Block14_Datum00_Byte00_Animated : packoffset(c70);
  float _Unigram_Letter_Grid_Data_Block14_Datum01_Byte00_Animated : packoffset(c71);
  float _Unigram_Letter_Grid_Data_Block14_Datum02_Byte00_Animated : packoffset(c72);
  float _Unigram_Letter_Grid_Data_Block14_Datum03_Byte00_Animated : packoffset(c73);
  float _Unigram_Letter_Grid_Data_Block14_Datum04_Byte00_Animated : packoffset(c74);
  float _Unigram_Letter_Grid_Data_Block15_Datum00_Byte00_Animated : packoffset(c75);
  float _Unigram_Letter_Grid_Data_Block15_Datum01_Byte00_Animated : packoffset(c76);
  float _Unigram_Letter_Grid_Data_Block15_Datum02_Byte00_Animated : packoffset(c77);
  float _Unigram_Letter_Grid_Data_Block15_Datum03_Byte00_Animated : packoffset(c78);
  float _Unigram_Letter_Grid_Data_Block15_Datum04_Byte00_Animated : packoffset(c79);

  float _Unigram_Letter_Grid_Data_Block16_Datum00_Byte00_Animated : packoffset(c80);
  float _Unigram_Letter_Grid_Data_Block16_Datum01_Byte00_Animated : packoffset(c81);
  float _Unigram_Letter_Grid_Data_Block16_Datum02_Byte00_Animated : packoffset(c82);
  float _Unigram_Letter_Grid_Data_Block16_Datum03_Byte00_Animated : packoffset(c83);
  float _Unigram_Letter_Grid_Data_Block16_Datum04_Byte00_Animated : packoffset(c84);
  float _Unigram_Letter_Grid_Data_Block17_Datum00_Byte00_Animated : packoffset(c85);
  float _Unigram_Letter_Grid_Data_Block17_Datum01_Byte00_Animated : packoffset(c86);
  float _Unigram_Letter_Grid_Data_Block17_Datum02_Byte00_Animated : packoffset(c87);
  float _Unigram_Letter_Grid_Data_Block17_Datum03_Byte00_Animated : packoffset(c88);
  float _Unigram_Letter_Grid_Data_Block17_Datum04_Byte00_Animated : packoffset(c89);

  float _Unigram_Letter_Grid_Data_Block18_Datum00_Byte00_Animated : packoffset(c90);
  float _Unigram_Letter_Grid_Data_Block18_Datum01_Byte00_Animated : packoffset(c91);
  float _Unigram_Letter_Grid_Data_Block18_Datum02_Byte00_Animated : packoffset(c92);
  float _Unigram_Letter_Grid_Data_Block18_Datum03_Byte00_Animated : packoffset(c93);
  float _Unigram_Letter_Grid_Data_Block18_Datum04_Byte00_Animated : packoffset(c94);
  float _Unigram_Letter_Grid_Data_Block19_Datum00_Byte00_Animated : packoffset(c95);
  float _Unigram_Letter_Grid_Data_Block19_Datum01_Byte00_Animated : packoffset(c96);
  float _Unigram_Letter_Grid_Data_Block19_Datum02_Byte00_Animated : packoffset(c97);
  float _Unigram_Letter_Grid_Data_Block19_Datum03_Byte00_Animated : packoffset(c98);
  float _Unigram_Letter_Grid_Data_Block19_Datum04_Byte00_Animated : packoffset(c99);

  float _Unigram_Letter_Grid_Data_Block20_Datum00_Byte00_Animated : packoffset(c100);
  float _Unigram_Letter_Grid_Data_Block20_Datum01_Byte00_Animated : packoffset(c101);
  float _Unigram_Letter_Grid_Data_Block20_Datum02_Byte00_Animated : packoffset(c102);
  float _Unigram_Letter_Grid_Data_Block20_Datum03_Byte00_Animated : packoffset(c103);
  float _Unigram_Letter_Grid_Data_Block20_Datum04_Byte00_Animated : packoffset(c104);
  float _Unigram_Letter_Grid_Data_Block21_Datum00_Byte00_Animated : packoffset(c105);
  float _Unigram_Letter_Grid_Data_Block21_Datum01_Byte00_Animated : packoffset(c106);
  float _Unigram_Letter_Grid_Data_Block21_Datum02_Byte00_Animated : packoffset(c107);
  float _Unigram_Letter_Grid_Data_Block21_Datum03_Byte00_Animated : packoffset(c108);
  float _Unigram_Letter_Grid_Data_Block21_Datum04_Byte00_Animated : packoffset(c109);

  float _Unigram_Letter_Grid_Data_Block22_Datum00_Byte00_Animated : packoffset(c110);
  float _Unigram_Letter_Grid_Data_Block22_Datum01_Byte00_Animated : packoffset(c111);
  float _Unigram_Letter_Grid_Data_Block22_Datum02_Byte00_Animated : packoffset(c112);
  float _Unigram_Letter_Grid_Data_Block22_Datum03_Byte00_Animated : packoffset(c113);
  float _Unigram_Letter_Grid_Data_Block22_Datum04_Byte00_Animated : packoffset(c114);
  float _Unigram_Letter_Grid_Data_Block23_Datum00_Byte00_Animated : packoffset(c115);
  float _Unigram_Letter_Grid_Data_Block23_Datum01_Byte00_Animated : packoffset(c116);
  float _Unigram_Letter_Grid_Data_Block23_Datum02_Byte00_Animated : packoffset(c117);
  float _Unigram_Letter_Grid_Data_Block23_Datum03_Byte00_Animated : packoffset(c118);
  float _Unigram_Letter_Grid_Data_Block23_Datum04_Byte00_Animated : packoffset(c119);

  float _Unigram_Letter_Grid_Data_Block24_Datum00_Byte00_Animated : packoffset(c120);
  float _Unigram_Letter_Grid_Data_Block24_Datum01_Byte00_Animated : packoffset(c121);
  float _Unigram_Letter_Grid_Data_Block24_Datum02_Byte00_Animated : packoffset(c122);
  float _Unigram_Letter_Grid_Data_Block24_Datum03_Byte00_Animated : packoffset(c123);
  float _Unigram_Letter_Grid_Data_Block24_Datum04_Byte00_Animated : packoffset(c124);
  float _Unigram_Letter_Grid_Data_Block25_Datum00_Byte00_Animated : packoffset(c125);
  float _Unigram_Letter_Grid_Data_Block25_Datum01_Byte00_Animated : packoffset(c126);
  float _Unigram_Letter_Grid_Data_Block25_Datum02_Byte00_Animated : packoffset(c127);
  float _Unigram_Letter_Grid_Data_Block25_Datum03_Byte00_Animated : packoffset(c128);
  float _Unigram_Letter_Grid_Data_Block25_Datum04_Byte00_Animated : packoffset(c129);

  float _Unigram_Letter_Grid_Data_Block26_Datum00_Byte00_Animated : packoffset(c130);
  float _Unigram_Letter_Grid_Data_Block26_Datum01_Byte00_Animated : packoffset(c131);
  float _Unigram_Letter_Grid_Data_Block26_Datum02_Byte00_Animated : packoffset(c132);
  float _Unigram_Letter_Grid_Data_Block26_Datum03_Byte00_Animated : packoffset(c133);
  float _Unigram_Letter_Grid_Data_Block26_Datum04_Byte00_Animated : packoffset(c134);
  float _Unigram_Letter_Grid_Data_Block27_Datum00_Byte00_Animated : packoffset(c135);
  float _Unigram_Letter_Grid_Data_Block27_Datum01_Byte00_Animated : packoffset(c136);
  float _Unigram_Letter_Grid_Data_Block27_Datum02_Byte00_Animated : packoffset(c137);
  float _Unigram_Letter_Grid_Data_Block27_Datum03_Byte00_Animated : packoffset(c138);
  float _Unigram_Letter_Grid_Data_Block27_Datum04_Byte00_Animated : packoffset(c139);

  float _Unigram_Letter_Grid_Data_Block28_Datum00_Byte00_Animated : packoffset(c140);
  float _Unigram_Letter_Grid_Data_Block28_Datum01_Byte00_Animated : packoffset(c141);
  float _Unigram_Letter_Grid_Data_Block28_Datum02_Byte00_Animated : packoffset(c142);
  float _Unigram_Letter_Grid_Data_Block28_Datum03_Byte00_Animated : packoffset(c143);
  float _Unigram_Letter_Grid_Data_Block28_Datum04_Byte00_Animated : packoffset(c144);
  float _Unigram_Letter_Grid_Data_Block29_Datum00_Byte00_Animated : packoffset(c145);
  float _Unigram_Letter_Grid_Data_Block29_Datum01_Byte00_Animated : packoffset(c146);
  float _Unigram_Letter_Grid_Data_Block29_Datum02_Byte00_Animated : packoffset(c147);
  float _Unigram_Letter_Grid_Data_Block29_Datum03_Byte00_Animated : packoffset(c148);
  float _Unigram_Letter_Grid_Data_Block29_Datum04_Byte00_Animated : packoffset(c149);

  float _Unigram_Letter_Grid_Data_Block30_Datum00_Byte00_Animated : packoffset(c150);
  float _Unigram_Letter_Grid_Data_Block30_Datum01_Byte00_Animated : packoffset(c151);
  float _Unigram_Letter_Grid_Data_Block30_Datum02_Byte00_Animated : packoffset(c152);
  float _Unigram_Letter_Grid_Data_Block30_Datum03_Byte00_Animated : packoffset(c153);
  float _Unigram_Letter_Grid_Data_Block30_Datum04_Byte00_Animated : packoffset(c154);
  float _Unigram_Letter_Grid_Data_Block31_Datum00_Byte00_Animated : packoffset(c155);
  float _Unigram_Letter_Grid_Data_Block31_Datum01_Byte00_Animated : packoffset(c156);
  float _Unigram_Letter_Grid_Data_Block31_Datum02_Byte00_Animated : packoffset(c157);
  float _Unigram_Letter_Grid_Data_Block31_Datum03_Byte00_Animated : packoffset(c158);
  float _Unigram_Letter_Grid_Data_Block31_Datum04_Byte00_Animated : packoffset(c159);

  float _Unigram_Letter_Grid_Data_Block32_Datum00_Byte00_Animated : packoffset(c160);
  float _Unigram_Letter_Grid_Data_Block32_Datum01_Byte00_Animated : packoffset(c161);
  float _Unigram_Letter_Grid_Data_Block32_Datum02_Byte00_Animated : packoffset(c162);
  float _Unigram_Letter_Grid_Data_Block32_Datum03_Byte00_Animated : packoffset(c163);
  float _Unigram_Letter_Grid_Data_Block32_Datum04_Byte00_Animated : packoffset(c164);
  float _Unigram_Letter_Grid_Data_Block33_Datum00_Byte00_Animated : packoffset(c165);
  float _Unigram_Letter_Grid_Data_Block33_Datum01_Byte00_Animated : packoffset(c166);
  float _Unigram_Letter_Grid_Data_Block33_Datum02_Byte00_Animated : packoffset(c167);
  float _Unigram_Letter_Grid_Data_Block33_Datum03_Byte00_Animated : packoffset(c168);
  float _Unigram_Letter_Grid_Data_Block33_Datum04_Byte00_Animated : packoffset(c169);

  float _Unigram_Letter_Grid_Data_Block34_Datum00_Byte00_Animated : packoffset(c170);
  float _Unigram_Letter_Grid_Data_Block34_Datum01_Byte00_Animated : packoffset(c171);
  float _Unigram_Letter_Grid_Data_Block34_Datum02_Byte00_Animated : packoffset(c172);
  float _Unigram_Letter_Grid_Data_Block34_Datum03_Byte00_Animated : packoffset(c173);
  float _Unigram_Letter_Grid_Data_Block34_Datum04_Byte00_Animated : packoffset(c174);
  float _Unigram_Letter_Grid_Data_Block35_Datum00_Byte00_Animated : packoffset(c175);
  float _Unigram_Letter_Grid_Data_Block35_Datum01_Byte00_Animated : packoffset(c176);
  float _Unigram_Letter_Grid_Data_Block35_Datum02_Byte00_Animated : packoffset(c177);
  float _Unigram_Letter_Grid_Data_Block35_Datum03_Byte00_Animated : packoffset(c178);
  float _Unigram_Letter_Grid_Data_Block35_Datum04_Byte00_Animated : packoffset(c179);

  float _Unigram_Letter_Grid_Data_Block36_Datum00_Byte00_Animated : packoffset(c180);
  float _Unigram_Letter_Grid_Data_Block36_Datum01_Byte00_Animated : packoffset(c181);
  float _Unigram_Letter_Grid_Data_Block36_Datum02_Byte00_Animated : packoffset(c182);
  float _Unigram_Letter_Grid_Data_Block36_Datum03_Byte00_Animated : packoffset(c183);
  float _Unigram_Letter_Grid_Data_Block36_Datum04_Byte00_Animated : packoffset(c184);
  float _Unigram_Letter_Grid_Data_Block37_Datum00_Byte00_Animated : packoffset(c185);
  float _Unigram_Letter_Grid_Data_Block37_Datum01_Byte00_Animated : packoffset(c186);
  float _Unigram_Letter_Grid_Data_Block37_Datum02_Byte00_Animated : packoffset(c187);
  float _Unigram_Letter_Grid_Data_Block37_Datum03_Byte00_Animated : packoffset(c188);
  float _Unigram_Letter_Grid_Data_Block37_Datum04_Byte00_Animated : packoffset(c189);

  float _Unigram_Letter_Grid_Data_Block38_Datum00_Byte00_Animated : packoffset(c190);
  float _Unigram_Letter_Grid_Data_Block38_Datum01_Byte00_Animated : packoffset(c191);
  float _Unigram_Letter_Grid_Data_Block38_Datum02_Byte00_Animated : packoffset(c192);
  float _Unigram_Letter_Grid_Data_Block38_Datum03_Byte00_Animated : packoffset(c193);
  float _Unigram_Letter_Grid_Data_Block38_Datum04_Byte00_Animated : packoffset(c194);
  float _Unigram_Letter_Grid_Data_Block39_Datum00_Byte00_Animated : packoffset(c195);
  float _Unigram_Letter_Grid_Data_Block39_Datum01_Byte00_Animated : packoffset(c196);
  float _Unigram_Letter_Grid_Data_Block39_Datum02_Byte00_Animated : packoffset(c197);
  float _Unigram_Letter_Grid_Data_Block39_Datum03_Byte00_Animated : packoffset(c198);
  float _Unigram_Letter_Grid_Data_Block39_Datum04_Byte00_Animated : packoffset(c199);
}
#endif  // ULG_D0

#if defined(ULG_D1)
cbuffer UnigramLetterGridDataByte01_Animated
{
  float _Unigram_Letter_Data_Byte01[ULG_NUM_BLOCKS * ULG_BLOCK_WIDTH] : packoffset(c0);

  float _Unigram_Letter_Grid_Data_Block00_Datum00_Byte01_Animated : packoffset(c0);
  float _Unigram_Letter_Grid_Data_Block00_Datum01_Byte01_Animated : packoffset(c1);
  float _Unigram_Letter_Grid_Data_Block00_Datum02_Byte01_Animated : packoffset(c2);
  float _Unigram_Letter_Grid_Data_Block00_Datum03_Byte01_Animated : packoffset(c3);
  float _Unigram_Letter_Grid_Data_Block00_Datum04_Byte01_Animated : packoffset(c4);
  float _Unigram_Letter_Grid_Data_Block01_Datum00_Byte01_Animated : packoffset(c5);
  float _Unigram_Letter_Grid_Data_Block01_Datum01_Byte01_Animated : packoffset(c6);
  float _Unigram_Letter_Grid_Data_Block01_Datum02_Byte01_Animated : packoffset(c7);
  float _Unigram_Letter_Grid_Data_Block01_Datum03_Byte01_Animated : packoffset(c8);
  float _Unigram_Letter_Grid_Data_Block01_Datum04_Byte01_Animated : packoffset(c9);

  float _Unigram_Letter_Grid_Data_Block02_Datum00_Byte01_Animated : packoffset(c10);
  float _Unigram_Letter_Grid_Data_Block02_Datum01_Byte01_Animated : packoffset(c11);
  float _Unigram_Letter_Grid_Data_Block02_Datum02_Byte01_Animated : packoffset(c12);
  float _Unigram_Letter_Grid_Data_Block02_Datum03_Byte01_Animated : packoffset(c13);
  float _Unigram_Letter_Grid_Data_Block02_Datum04_Byte01_Animated : packoffset(c14);
  float _Unigram_Letter_Grid_Data_Block03_Datum00_Byte01_Animated : packoffset(c15);
  float _Unigram_Letter_Grid_Data_Block03_Datum01_Byte01_Animated : packoffset(c16);
  float _Unigram_Letter_Grid_Data_Block03_Datum02_Byte01_Animated : packoffset(c17);
  float _Unigram_Letter_Grid_Data_Block03_Datum03_Byte01_Animated : packoffset(c18);
  float _Unigram_Letter_Grid_Data_Block03_Datum04_Byte01_Animated : packoffset(c19);

  float _Unigram_Letter_Grid_Data_Block04_Datum00_Byte01_Animated : packoffset(c20);
  float _Unigram_Letter_Grid_Data_Block04_Datum01_Byte01_Animated : packoffset(c21);
  float _Unigram_Letter_Grid_Data_Block04_Datum02_Byte01_Animated : packoffset(c22);
  float _Unigram_Letter_Grid_Data_Block04_Datum03_Byte01_Animated : packoffset(c23);
  float _Unigram_Letter_Grid_Data_Block04_Datum04_Byte01_Animated : packoffset(c24);
  float _Unigram_Letter_Grid_Data_Block05_Datum00_Byte01_Animated : packoffset(c25);
  float _Unigram_Letter_Grid_Data_Block05_Datum01_Byte01_Animated : packoffset(c26);
  float _Unigram_Letter_Grid_Data_Block05_Datum02_Byte01_Animated : packoffset(c27);
  float _Unigram_Letter_Grid_Data_Block05_Datum03_Byte01_Animated : packoffset(c28);
  float _Unigram_Letter_Grid_Data_Block05_Datum04_Byte01_Animated : packoffset(c29);

  float _Unigram_Letter_Grid_Data_Block06_Datum00_Byte01_Animated : packoffset(c30);
  float _Unigram_Letter_Grid_Data_Block06_Datum01_Byte01_Animated : packoffset(c31);
  float _Unigram_Letter_Grid_Data_Block06_Datum02_Byte01_Animated : packoffset(c32);
  float _Unigram_Letter_Grid_Data_Block06_Datum03_Byte01_Animated : packoffset(c33);
  float _Unigram_Letter_Grid_Data_Block06_Datum04_Byte01_Animated : packoffset(c34);
  float _Unigram_Letter_Grid_Data_Block07_Datum00_Byte01_Animated : packoffset(c35);
  float _Unigram_Letter_Grid_Data_Block07_Datum01_Byte01_Animated : packoffset(c36);
  float _Unigram_Letter_Grid_Data_Block07_Datum02_Byte01_Animated : packoffset(c37);
  float _Unigram_Letter_Grid_Data_Block07_Datum03_Byte01_Animated : packoffset(c38);
  float _Unigram_Letter_Grid_Data_Block07_Datum04_Byte01_Animated : packoffset(c39);

  float _Unigram_Letter_Grid_Data_Block08_Datum00_Byte01_Animated : packoffset(c40);
  float _Unigram_Letter_Grid_Data_Block08_Datum01_Byte01_Animated : packoffset(c41);
  float _Unigram_Letter_Grid_Data_Block08_Datum02_Byte01_Animated : packoffset(c42);
  float _Unigram_Letter_Grid_Data_Block08_Datum03_Byte01_Animated : packoffset(c43);
  float _Unigram_Letter_Grid_Data_Block08_Datum04_Byte01_Animated : packoffset(c44);
  float _Unigram_Letter_Grid_Data_Block09_Datum00_Byte01_Animated : packoffset(c45);
  float _Unigram_Letter_Grid_Data_Block09_Datum01_Byte01_Animated : packoffset(c46);
  float _Unigram_Letter_Grid_Data_Block09_Datum02_Byte01_Animated : packoffset(c47);
  float _Unigram_Letter_Grid_Data_Block09_Datum03_Byte01_Animated : packoffset(c48);
  float _Unigram_Letter_Grid_Data_Block09_Datum04_Byte01_Animated : packoffset(c49);

  float _Unigram_Letter_Grid_Data_Block10_Datum00_Byte01_Animated : packoffset(c50);
  float _Unigram_Letter_Grid_Data_Block10_Datum01_Byte01_Animated : packoffset(c51);
  float _Unigram_Letter_Grid_Data_Block10_Datum02_Byte01_Animated : packoffset(c52);
  float _Unigram_Letter_Grid_Data_Block10_Datum03_Byte01_Animated : packoffset(c53);
  float _Unigram_Letter_Grid_Data_Block10_Datum04_Byte01_Animated : packoffset(c54);
  float _Unigram_Letter_Grid_Data_Block11_Datum00_Byte01_Animated : packoffset(c55);
  float _Unigram_Letter_Grid_Data_Block11_Datum01_Byte01_Animated : packoffset(c56);
  float _Unigram_Letter_Grid_Data_Block11_Datum02_Byte01_Animated : packoffset(c57);
  float _Unigram_Letter_Grid_Data_Block11_Datum03_Byte01_Animated : packoffset(c58);
  float _Unigram_Letter_Grid_Data_Block11_Datum04_Byte01_Animated : packoffset(c59);

  float _Unigram_Letter_Grid_Data_Block12_Datum00_Byte01_Animated : packoffset(c60);
  float _Unigram_Letter_Grid_Data_Block12_Datum01_Byte01_Animated : packoffset(c61);
  float _Unigram_Letter_Grid_Data_Block12_Datum02_Byte01_Animated : packoffset(c62);
  float _Unigram_Letter_Grid_Data_Block12_Datum03_Byte01_Animated : packoffset(c63);
  float _Unigram_Letter_Grid_Data_Block12_Datum04_Byte01_Animated : packoffset(c64);
  float _Unigram_Letter_Grid_Data_Block13_Datum00_Byte01_Animated : packoffset(c65);
  float _Unigram_Letter_Grid_Data_Block13_Datum01_Byte01_Animated : packoffset(c66);
  float _Unigram_Letter_Grid_Data_Block13_Datum02_Byte01_Animated : packoffset(c67);
  float _Unigram_Letter_Grid_Data_Block13_Datum03_Byte01_Animated : packoffset(c68);
  float _Unigram_Letter_Grid_Data_Block13_Datum04_Byte01_Animated : packoffset(c69);

  float _Unigram_Letter_Grid_Data_Block14_Datum00_Byte01_Animated : packoffset(c70);
  float _Unigram_Letter_Grid_Data_Block14_Datum01_Byte01_Animated : packoffset(c71);
  float _Unigram_Letter_Grid_Data_Block14_Datum02_Byte01_Animated : packoffset(c72);
  float _Unigram_Letter_Grid_Data_Block14_Datum03_Byte01_Animated : packoffset(c73);
  float _Unigram_Letter_Grid_Data_Block14_Datum04_Byte01_Animated : packoffset(c74);
  float _Unigram_Letter_Grid_Data_Block15_Datum00_Byte01_Animated : packoffset(c75);
  float _Unigram_Letter_Grid_Data_Block15_Datum01_Byte01_Animated : packoffset(c76);
  float _Unigram_Letter_Grid_Data_Block15_Datum02_Byte01_Animated : packoffset(c77);
  float _Unigram_Letter_Grid_Data_Block15_Datum03_Byte01_Animated : packoffset(c78);
  float _Unigram_Letter_Grid_Data_Block15_Datum04_Byte01_Animated : packoffset(c79);

  float _Unigram_Letter_Grid_Data_Block16_Datum00_Byte01_Animated : packoffset(c80);
  float _Unigram_Letter_Grid_Data_Block16_Datum01_Byte01_Animated : packoffset(c81);
  float _Unigram_Letter_Grid_Data_Block16_Datum02_Byte01_Animated : packoffset(c82);
  float _Unigram_Letter_Grid_Data_Block16_Datum03_Byte01_Animated : packoffset(c83);
  float _Unigram_Letter_Grid_Data_Block16_Datum04_Byte01_Animated : packoffset(c84);
  float _Unigram_Letter_Grid_Data_Block17_Datum00_Byte01_Animated : packoffset(c85);
  float _Unigram_Letter_Grid_Data_Block17_Datum01_Byte01_Animated : packoffset(c86);
  float _Unigram_Letter_Grid_Data_Block17_Datum02_Byte01_Animated : packoffset(c87);
  float _Unigram_Letter_Grid_Data_Block17_Datum03_Byte01_Animated : packoffset(c88);
  float _Unigram_Letter_Grid_Data_Block17_Datum04_Byte01_Animated : packoffset(c89);

  float _Unigram_Letter_Grid_Data_Block18_Datum00_Byte01_Animated : packoffset(c90);
  float _Unigram_Letter_Grid_Data_Block18_Datum01_Byte01_Animated : packoffset(c91);
  float _Unigram_Letter_Grid_Data_Block18_Datum02_Byte01_Animated : packoffset(c92);
  float _Unigram_Letter_Grid_Data_Block18_Datum03_Byte01_Animated : packoffset(c93);
  float _Unigram_Letter_Grid_Data_Block18_Datum04_Byte01_Animated : packoffset(c94);
  float _Unigram_Letter_Grid_Data_Block19_Datum00_Byte01_Animated : packoffset(c95);
  float _Unigram_Letter_Grid_Data_Block19_Datum01_Byte01_Animated : packoffset(c96);
  float _Unigram_Letter_Grid_Data_Block19_Datum02_Byte01_Animated : packoffset(c97);
  float _Unigram_Letter_Grid_Data_Block19_Datum03_Byte01_Animated : packoffset(c98);
  float _Unigram_Letter_Grid_Data_Block19_Datum04_Byte01_Animated : packoffset(c99);

  float _Unigram_Letter_Grid_Data_Block20_Datum00_Byte01_Animated : packoffset(c100);
  float _Unigram_Letter_Grid_Data_Block20_Datum01_Byte01_Animated : packoffset(c101);
  float _Unigram_Letter_Grid_Data_Block20_Datum02_Byte01_Animated : packoffset(c102);
  float _Unigram_Letter_Grid_Data_Block20_Datum03_Byte01_Animated : packoffset(c103);
  float _Unigram_Letter_Grid_Data_Block20_Datum04_Byte01_Animated : packoffset(c104);
  float _Unigram_Letter_Grid_Data_Block21_Datum00_Byte01_Animated : packoffset(c105);
  float _Unigram_Letter_Grid_Data_Block21_Datum01_Byte01_Animated : packoffset(c106);
  float _Unigram_Letter_Grid_Data_Block21_Datum02_Byte01_Animated : packoffset(c107);
  float _Unigram_Letter_Grid_Data_Block21_Datum03_Byte01_Animated : packoffset(c108);
  float _Unigram_Letter_Grid_Data_Block21_Datum04_Byte01_Animated : packoffset(c109);

  float _Unigram_Letter_Grid_Data_Block22_Datum00_Byte01_Animated : packoffset(c110);
  float _Unigram_Letter_Grid_Data_Block22_Datum01_Byte01_Animated : packoffset(c111);
  float _Unigram_Letter_Grid_Data_Block22_Datum02_Byte01_Animated : packoffset(c112);
  float _Unigram_Letter_Grid_Data_Block22_Datum03_Byte01_Animated : packoffset(c113);
  float _Unigram_Letter_Grid_Data_Block22_Datum04_Byte01_Animated : packoffset(c114);
  float _Unigram_Letter_Grid_Data_Block23_Datum00_Byte01_Animated : packoffset(c115);
  float _Unigram_Letter_Grid_Data_Block23_Datum01_Byte01_Animated : packoffset(c116);
  float _Unigram_Letter_Grid_Data_Block23_Datum02_Byte01_Animated : packoffset(c117);
  float _Unigram_Letter_Grid_Data_Block23_Datum03_Byte01_Animated : packoffset(c118);
  float _Unigram_Letter_Grid_Data_Block23_Datum04_Byte01_Animated : packoffset(c119);

  float _Unigram_Letter_Grid_Data_Block24_Datum00_Byte01_Animated : packoffset(c120);
  float _Unigram_Letter_Grid_Data_Block24_Datum01_Byte01_Animated : packoffset(c121);
  float _Unigram_Letter_Grid_Data_Block24_Datum02_Byte01_Animated : packoffset(c122);
  float _Unigram_Letter_Grid_Data_Block24_Datum03_Byte01_Animated : packoffset(c123);
  float _Unigram_Letter_Grid_Data_Block24_Datum04_Byte01_Animated : packoffset(c124);
  float _Unigram_Letter_Grid_Data_Block25_Datum00_Byte01_Animated : packoffset(c125);
  float _Unigram_Letter_Grid_Data_Block25_Datum01_Byte01_Animated : packoffset(c126);
  float _Unigram_Letter_Grid_Data_Block25_Datum02_Byte01_Animated : packoffset(c127);
  float _Unigram_Letter_Grid_Data_Block25_Datum03_Byte01_Animated : packoffset(c128);
  float _Unigram_Letter_Grid_Data_Block25_Datum04_Byte01_Animated : packoffset(c129);

  float _Unigram_Letter_Grid_Data_Block26_Datum00_Byte01_Animated : packoffset(c130);
  float _Unigram_Letter_Grid_Data_Block26_Datum01_Byte01_Animated : packoffset(c131);
  float _Unigram_Letter_Grid_Data_Block26_Datum02_Byte01_Animated : packoffset(c132);
  float _Unigram_Letter_Grid_Data_Block26_Datum03_Byte01_Animated : packoffset(c133);
  float _Unigram_Letter_Grid_Data_Block26_Datum04_Byte01_Animated : packoffset(c134);
  float _Unigram_Letter_Grid_Data_Block27_Datum00_Byte01_Animated : packoffset(c135);
  float _Unigram_Letter_Grid_Data_Block27_Datum01_Byte01_Animated : packoffset(c136);
  float _Unigram_Letter_Grid_Data_Block27_Datum02_Byte01_Animated : packoffset(c137);
  float _Unigram_Letter_Grid_Data_Block27_Datum03_Byte01_Animated : packoffset(c138);
  float _Unigram_Letter_Grid_Data_Block27_Datum04_Byte01_Animated : packoffset(c139);

  float _Unigram_Letter_Grid_Data_Block28_Datum00_Byte01_Animated : packoffset(c140);
  float _Unigram_Letter_Grid_Data_Block28_Datum01_Byte01_Animated : packoffset(c141);
  float _Unigram_Letter_Grid_Data_Block28_Datum02_Byte01_Animated : packoffset(c142);
  float _Unigram_Letter_Grid_Data_Block28_Datum03_Byte01_Animated : packoffset(c143);
  float _Unigram_Letter_Grid_Data_Block28_Datum04_Byte01_Animated : packoffset(c144);
  float _Unigram_Letter_Grid_Data_Block29_Datum00_Byte01_Animated : packoffset(c145);
  float _Unigram_Letter_Grid_Data_Block29_Datum01_Byte01_Animated : packoffset(c146);
  float _Unigram_Letter_Grid_Data_Block29_Datum02_Byte01_Animated : packoffset(c147);
  float _Unigram_Letter_Grid_Data_Block29_Datum03_Byte01_Animated : packoffset(c148);
  float _Unigram_Letter_Grid_Data_Block29_Datum04_Byte01_Animated : packoffset(c149);

  float _Unigram_Letter_Grid_Data_Block30_Datum00_Byte01_Animated : packoffset(c150);
  float _Unigram_Letter_Grid_Data_Block30_Datum01_Byte01_Animated : packoffset(c151);
  float _Unigram_Letter_Grid_Data_Block30_Datum02_Byte01_Animated : packoffset(c152);
  float _Unigram_Letter_Grid_Data_Block30_Datum03_Byte01_Animated : packoffset(c153);
  float _Unigram_Letter_Grid_Data_Block30_Datum04_Byte01_Animated : packoffset(c154);
  float _Unigram_Letter_Grid_Data_Block31_Datum00_Byte01_Animated : packoffset(c155);
  float _Unigram_Letter_Grid_Data_Block31_Datum01_Byte01_Animated : packoffset(c156);
  float _Unigram_Letter_Grid_Data_Block31_Datum02_Byte01_Animated : packoffset(c157);
  float _Unigram_Letter_Grid_Data_Block31_Datum03_Byte01_Animated : packoffset(c158);
  float _Unigram_Letter_Grid_Data_Block31_Datum04_Byte01_Animated : packoffset(c159);

  float _Unigram_Letter_Grid_Data_Block32_Datum00_Byte01_Animated : packoffset(c160);
  float _Unigram_Letter_Grid_Data_Block32_Datum01_Byte01_Animated : packoffset(c161);
  float _Unigram_Letter_Grid_Data_Block32_Datum02_Byte01_Animated : packoffset(c162);
  float _Unigram_Letter_Grid_Data_Block32_Datum03_Byte01_Animated : packoffset(c163);
  float _Unigram_Letter_Grid_Data_Block32_Datum04_Byte01_Animated : packoffset(c164);
  float _Unigram_Letter_Grid_Data_Block33_Datum00_Byte01_Animated : packoffset(c165);
  float _Unigram_Letter_Grid_Data_Block33_Datum01_Byte01_Animated : packoffset(c166);
  float _Unigram_Letter_Grid_Data_Block33_Datum02_Byte01_Animated : packoffset(c167);
  float _Unigram_Letter_Grid_Data_Block33_Datum03_Byte01_Animated : packoffset(c168);
  float _Unigram_Letter_Grid_Data_Block33_Datum04_Byte01_Animated : packoffset(c169);

  float _Unigram_Letter_Grid_Data_Block34_Datum00_Byte01_Animated : packoffset(c170);
  float _Unigram_Letter_Grid_Data_Block34_Datum01_Byte01_Animated : packoffset(c171);
  float _Unigram_Letter_Grid_Data_Block34_Datum02_Byte01_Animated : packoffset(c172);
  float _Unigram_Letter_Grid_Data_Block34_Datum03_Byte01_Animated : packoffset(c173);
  float _Unigram_Letter_Grid_Data_Block34_Datum04_Byte01_Animated : packoffset(c174);
  float _Unigram_Letter_Grid_Data_Block35_Datum00_Byte01_Animated : packoffset(c175);
  float _Unigram_Letter_Grid_Data_Block35_Datum01_Byte01_Animated : packoffset(c176);
  float _Unigram_Letter_Grid_Data_Block35_Datum02_Byte01_Animated : packoffset(c177);
  float _Unigram_Letter_Grid_Data_Block35_Datum03_Byte01_Animated : packoffset(c178);
  float _Unigram_Letter_Grid_Data_Block35_Datum04_Byte01_Animated : packoffset(c179);

  float _Unigram_Letter_Grid_Data_Block36_Datum00_Byte01_Animated : packoffset(c180);
  float _Unigram_Letter_Grid_Data_Block36_Datum01_Byte01_Animated : packoffset(c181);
  float _Unigram_Letter_Grid_Data_Block36_Datum02_Byte01_Animated : packoffset(c182);
  float _Unigram_Letter_Grid_Data_Block36_Datum03_Byte01_Animated : packoffset(c183);
  float _Unigram_Letter_Grid_Data_Block36_Datum04_Byte01_Animated : packoffset(c184);
  float _Unigram_Letter_Grid_Data_Block37_Datum00_Byte01_Animated : packoffset(c185);
  float _Unigram_Letter_Grid_Data_Block37_Datum01_Byte01_Animated : packoffset(c186);
  float _Unigram_Letter_Grid_Data_Block37_Datum02_Byte01_Animated : packoffset(c187);
  float _Unigram_Letter_Grid_Data_Block37_Datum03_Byte01_Animated : packoffset(c188);
  float _Unigram_Letter_Grid_Data_Block37_Datum04_Byte01_Animated : packoffset(c189);

  float _Unigram_Letter_Grid_Data_Block38_Datum00_Byte01_Animated : packoffset(c190);
  float _Unigram_Letter_Grid_Data_Block38_Datum01_Byte01_Animated : packoffset(c191);
  float _Unigram_Letter_Grid_Data_Block38_Datum02_Byte01_Animated : packoffset(c192);
  float _Unigram_Letter_Grid_Data_Block38_Datum03_Byte01_Animated : packoffset(c193);
  float _Unigram_Letter_Grid_Data_Block38_Datum04_Byte01_Animated : packoffset(c194);
  float _Unigram_Letter_Grid_Data_Block39_Datum00_Byte01_Animated : packoffset(c195);
  float _Unigram_Letter_Grid_Data_Block39_Datum01_Byte01_Animated : packoffset(c196);
  float _Unigram_Letter_Grid_Data_Block39_Datum02_Byte01_Animated : packoffset(c197);
  float _Unigram_Letter_Grid_Data_Block39_Datum03_Byte01_Animated : packoffset(c198);
  float _Unigram_Letter_Grid_Data_Block39_Datum04_Byte01_Animated : packoffset(c199);
}
#endif  // ULG_D1

void PreventCbufferElision(v2f i, inout float a) {
  // Hack to prevent cbuffer from getting optimized out.
  [branch]
  if (i.uv01.x < 0) {
    a = 0;
#if defined(ULG_VP)
    // Add pairs of products since each pair compiles down to a single `mad`
    // instruction. This reduces the instruction count of this function by
    // ~50%. (Thank you d4rkpl4y3r for this tip!)
    a +=
      _Unigram_Letter_Grid_Block00_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block01_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block02_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block03_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block04_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block05_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block06_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block07_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block08_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block09_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block10_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block11_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block12_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block13_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block14_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block15_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block16_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block17_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block18_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block19_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block20_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block21_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block22_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block23_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block24_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block25_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block26_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block27_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block28_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block29_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block30_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block31_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block32_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block33_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block34_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block35_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block36_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block37_Visual_Pointer_Animated +
      _Unigram_Letter_Grid_Block38_Visual_Pointer_Animated *
      _Unigram_Letter_Grid_Block39_Visual_Pointer_Animated;
#endif  // ULG_VP
#if defined(ULG_D0)
    a +=
      _Unigram_Letter_Grid_Data_Block00_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block00_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block00_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block00_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block00_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block01_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block01_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block01_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block01_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block01_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block02_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block02_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block02_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block02_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block02_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block03_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block03_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block03_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block03_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block03_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block04_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block04_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block04_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block04_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block04_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block05_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block05_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block05_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block05_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block05_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block06_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block06_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block06_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block06_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block06_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block07_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block07_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block07_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block07_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block07_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block08_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block08_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block08_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block08_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block08_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block09_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block09_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block09_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block09_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block09_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block10_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block10_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block10_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block10_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block10_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block11_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block11_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block11_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block11_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block11_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block12_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block12_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block12_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block12_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block12_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block13_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block13_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block13_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block13_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block13_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block14_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block14_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block14_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block14_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block14_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block15_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block15_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block15_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block15_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block15_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block16_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block16_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block16_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block16_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block16_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block17_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block17_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block17_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block17_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block17_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block18_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block18_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block18_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block18_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block18_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block19_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block19_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block19_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block19_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block19_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block20_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block20_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block20_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block20_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block20_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block21_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block21_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block21_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block21_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block21_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block22_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block22_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block22_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block22_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block22_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block23_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block23_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block23_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block23_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block23_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block24_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block24_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block24_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block24_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block24_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block25_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block25_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block25_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block25_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block25_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block26_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block26_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block26_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block26_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block26_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block27_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block27_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block27_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block27_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block27_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block28_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block28_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block28_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block28_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block28_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block29_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block29_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block29_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block29_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block29_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block30_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block30_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block30_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block30_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block30_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block31_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block31_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block31_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block31_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block31_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block32_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block32_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block32_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block32_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block32_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block33_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block33_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block33_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block33_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block33_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block34_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block34_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block34_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block34_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block34_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block35_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block35_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block35_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block35_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block35_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block36_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block36_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block36_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block36_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block36_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block37_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block37_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block37_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block37_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block37_Datum04_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block38_Datum00_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block38_Datum01_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block38_Datum02_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block38_Datum03_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block38_Datum04_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block39_Datum00_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block39_Datum01_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block39_Datum02_Byte00_Animated +
      _Unigram_Letter_Grid_Data_Block39_Datum03_Byte00_Animated *
      _Unigram_Letter_Grid_Data_Block39_Datum04_Byte00_Animated;
#endif  // ULG_D0
#if defined(ULG_D1)
    a +=
      _Unigram_Letter_Grid_Data_Block00_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block00_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block00_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block00_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block00_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block01_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block01_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block01_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block01_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block01_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block02_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block02_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block02_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block02_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block02_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block03_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block03_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block03_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block03_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block03_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block04_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block04_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block04_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block04_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block04_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block05_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block05_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block05_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block05_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block05_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block06_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block06_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block06_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block06_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block06_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block07_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block07_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block07_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block07_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block07_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block08_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block08_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block08_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block08_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block08_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block09_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block09_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block09_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block09_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block09_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block10_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block10_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block10_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block10_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block10_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block11_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block11_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block11_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block11_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block11_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block12_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block12_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block12_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block12_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block12_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block13_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block13_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block13_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block13_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block13_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block14_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block14_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block14_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block14_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block14_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block15_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block15_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block15_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block15_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block15_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block16_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block16_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block16_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block16_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block16_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block17_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block17_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block17_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block17_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block17_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block18_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block18_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block18_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block18_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block18_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block19_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block19_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block19_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block19_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block19_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block20_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block20_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block20_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block20_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block20_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block21_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block21_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block21_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block21_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block21_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block22_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block22_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block22_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block22_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block22_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block23_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block23_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block23_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block23_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block23_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block24_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block24_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block24_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block24_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block24_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block25_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block25_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block25_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block25_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block25_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block26_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block26_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block26_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block26_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block26_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block27_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block27_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block27_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block27_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block27_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block28_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block28_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block28_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block28_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block28_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block29_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block29_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block29_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block29_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block29_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block30_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block30_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block30_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block30_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block30_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block31_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block31_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block31_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block31_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block31_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block32_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block32_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block32_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block32_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block32_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block33_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block33_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block33_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block33_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block33_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block34_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block34_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block34_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block34_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block34_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block35_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block35_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block35_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block35_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block35_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block36_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block36_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block36_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block36_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block36_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block37_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block37_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block37_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block37_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block37_Datum04_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block38_Datum00_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block38_Datum01_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block38_Datum02_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block38_Datum03_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block38_Datum04_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block39_Datum00_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block39_Datum01_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block39_Datum02_Byte01_Animated +
      _Unigram_Letter_Grid_Data_Block39_Datum03_Byte01_Animated *
      _Unigram_Letter_Grid_Data_Block39_Datum04_Byte01_Animated;
#endif  // ULG_D1
  }
}

#if defined(ULG_D0) && defined(ULG_D1)
void GetBlock(uint which_block, out uint data[ULG_BLOCK_WIDTH]) {
  [loop]
  for (uint i = 0; i < ULG_BLOCK_WIDTH; i++) {
    data[i]  = ((uint) floor(_Unigram_Letter_Data_Byte00[which_block * ULG_BLOCK_WIDTH + i]+FUDGE_AMOUNT));
    data[i] |= ((uint) floor(_Unigram_Letter_Data_Byte01[which_block * ULG_BLOCK_WIDTH + i]+FUDGE_AMOUNT)) << 8;
  }
}
#endif

#if defined(ULG_VP)
// Get the tokens that cover `screen_ptr`. Also return `block_ptr`, the
// location where this block of tokens begins.
void GetTokens(uint screen_ptr,
    out uint block_ptr,
    out uint tokens[ULG_BLOCK_WIDTH],
    out uint which_block) {
  block_ptr = floor(_Unigram_Letter_Visual_Pointers[0]+FUDGE_AMOUNT);
  which_block = 0;
  [loop]
  for (uint i = 1; i < ULG_NUM_BLOCKS; i++) {
    uint next_ptr = floor(_Unigram_Letter_Visual_Pointers[i]+FUDGE_AMOUNT);
    if (block_ptr < next_ptr) {
      // Case 1: visual pointers are increasing
      if (screen_ptr >= block_ptr && screen_ptr < next_ptr) {
        break;
      }
    } else {
      // Case 2: visual pointer went backwards. This happens when we page long
      // data, wrapping around finite number of blocks.
      if (screen_ptr >= block_ptr || screen_ptr < next_ptr) {
        break;
      }
    }
    block_ptr = next_ptr;
    which_block = i;
  }
  GetBlock(which_block, tokens);
}
#endif

uint2 FoldIndex(uint flat_idx, uint2 img_res) {
  return uint2(flat_idx % img_res.x, floor(flat_idx / img_res.x));
}

uint UnfoldIndex(uint2 coord, uint2 img_res) {
  return coord[0] + coord[1] * img_res.x;
}

float2 GetUnigramLutUV(uint idx)
{
  // Remap from [0,  65535] to [0, 511] x [0,511].
  // Note that the LUT is square.
  uint2 idx_2d = FoldIndex(idx, _Unigram_Letter_Grid_LUT_TexelSize.z);
  // Remap onto [0, 1] x [0, 1].
  float2 uv = idx_2d * _Unigram_Letter_Grid_LUT_TexelSize.xy;
  // Center the UV coordinate in its texel.
  uv += _Unigram_Letter_Grid_LUT_TexelSize.xy * 0.5;
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

#if defined(ULG_VP) && defined(ULG_D0) && defined(ULG_D1)
// Get the character which covers the screen position.
uint GetChar(uint screen_ptr, out uint which_block, out uint which_datum) {
  uint block_ptr;
  uint tokens[ULG_BLOCK_WIDTH];
  GetTokens(screen_ptr, block_ptr, tokens, which_block);
  // Begin scanning at the start of the block.
  uint start = block_ptr;
  // The current token is rendered starting at this location.
  // In other words, it covers [token_ptr, token_ptr + token_length)
  uint token_ptr = block_ptr;
  // Wrap the block pointer around the board.
  const uint BOARD_SIZE = _Unigram_Letter_Grid_Res_X * _Unigram_Letter_Grid_Res_Y;
  token_ptr = token_ptr % BOARD_SIZE;
  uint token_offset;
  uint token_length = 0;
  bool got_match = false;
  [loop]
  for (uint i = 0; i < ULG_BLOCK_WIDTH; i++) {
    which_datum = i;
    TokenLengthOffset(tokens[i], token_length, token_offset);
    if (token_length == 0) {
      continue;
    }
    if (screen_ptr >= token_ptr && screen_ptr < token_ptr + token_length) {
      got_match = true;
      break;
    }
    // Edge case: the token pointer may be partially outside of the visible
    // part of the board.
    if (screen_ptr + BOARD_SIZE >= token_ptr &&
        screen_ptr + BOARD_SIZE < token_ptr + token_length) {
      got_match = true;
      break;
    }

    token_ptr += token_length;
    token_ptr = token_ptr % BOARD_SIZE;
  }
  // Edge case: no match
  if (!got_match) {
    return ' ';
  }
  uint nth_char = (screen_ptr >= token_ptr) ? screen_ptr - token_ptr : (screen_ptr + BOARD_SIZE) - token_ptr;
  return GetTokenChar(token_offset, nth_char);
}
#endif

struct UnigramLetterGridOutput {
  float4 albedo;
  float metallic;
  float roughness;
  float3 emission;
};

UnigramLetterGridOutput UnigramLetterGrid(v2f i, bool facing) {
  UnigramLetterGridOutput output;

  int2 cell_pos;
  int2 font_res = int2(round(_Unigram_Letter_Grid_Tex_Res_X), round(_Unigram_Letter_Grid_Tex_Res_Y));
  int2 grid_res = int2(round(_Unigram_Letter_Grid_Res_X), round(_Unigram_Letter_Grid_Res_Y));
  float2 cell_uv;  // uv within each letter cell

  float4 scoff = _Unigram_Letter_Grid_UV_Scale_Offset;
  float2 uv = i.uv01.xy;
  uv.x = facing ? uv.x : 1.0 - uv.x;
  uv = ((uv - 0.5) - scoff.zw) * scoff.xy + 0.5;

  bool in_box = getBoxLoc(uv, 0, 1, grid_res, _Unigram_Letter_Grid_Padding, cell_pos, cell_uv);
  cell_pos.y = (grid_res.y - cell_pos.y) - 1;

  uint flat_cell_pos = UnfoldIndex(cell_pos, grid_res);

  uint which_block, which_datum;
  float c = GetChar(flat_cell_pos, which_block, which_datum);

  float3 msd = renderInBox(c, uv, cell_uv, _Unigram_Letter_Grid_Glyphs, font_res).rgb;
  float sd = median(msd);

  // Calculate screen pixel range
  float screen_px_range;
  {
    float2 tex_size = float2(_Unigram_Letter_Grid_Glyphs_TexelSize.zw);
    float2 real_cell_size = floor(tex_size / grid_res);  // size of cell in texels
    float2 unit_range = _Unigram_Letter_Grid_Screen_Px_Range / real_cell_size;
    float2 screen_tex_size = 1 / fwidth(cell_uv);
    screen_px_range = max(1.0 * dot(unit_range, screen_tex_size), _Unigram_Letter_Grid_Min_Screen_Px_Range);
  }

  float screen_px_distance = screen_px_range * (sd - _Unigram_Letter_Grid_Alpha_Threshold);
  float op = clamp(screen_px_distance + 0.5, 0, 1);

  // Apply blending to output
  output.albedo.a = 1;
  PreventCbufferElision(i, output.albedo.a);
  output.albedo = float4(float3(1,1,1), output.albedo.a * op * in_box);
  output.metallic = 0;
  output.roughness = 1;
  output.emission = 0;

  // Visualize which block is being rendered.
  {
    float eps = 1.2E-1;
    bool in_range = (cell_uv.x < eps || cell_uv.y < eps || 1.0 - cell_uv.x < eps || 1.0 - cell_uv.y < eps);
    if (in_range)
    {
      float hue = which_datum * 0.3f;
      hue += (which_block % 2) * 0.5f;
      hue = frac(hue);
      hue *= TAU;
      output.albedo.rgb = OKLCHtoLRGB(float3(0.8, 0.2, hue));
      output.albedo.a = 1;
    }
  }

  return output;
}

#endif  // _UNIGRAM_LETTER_GRID
#endif  // __UNIGRAM_LETTER_GRID_INC

