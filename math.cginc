#ifndef __MATH_INC
#define __MATH_INC

#define PI 3.14159265358979323846264
#define TAU (2 * PI)

float pow5(float x)
{
  float tmp = x * x;
  return (tmp * tmp) * x;
}

float wrapNoL(float NoL, float factor) {
		// https://www.iro.umontreal.ca/~derek/files/jgt_wrap_final.pdf
    return pow(max(1E-4, (NoL + factor) / (1 + factor)), 1 + factor);
}

#endif  // __MATH_INC


