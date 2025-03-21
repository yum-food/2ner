#ifndef __FALSE_COLOR_VISUALIZATION_INC
#define __FALSE_COLOR_VISUALIZATION_INC

#include "features.cginc"
#include "globals.cginc"
#include "math.cginc"

float3 visualizeInFalseColor(float3 color)
{
#if defined(_FALSE_COLOR_VISUALIZATION)
    [branch]
    if (_False_Color_Visualization_Luminance) {
        color.xyz = luminance(color);
    } else if (_False_Color_Visualization_Luminance_Bounded) {
        color.xyz = luminance(color);
        // Sotalo suggests keeping albedo within the range 0.015% to 90%. He
        // might have meant any(color < blah), but I think this makes more
        // sense. I.e. it takes into account perceptual bias.
        color.xyz =
            color.x < 00.015 * 0.01 ? float3(1, 0, 0) :
            color.x > 90.000 * 0.01 ? float3(0, 0, 1) : color.xyz;
    }
#endif // _FALSE_COLOR_VISUALIZATION
return color;
}

#endif // __FALSE_COLOR_VISUALIZATION_INC

