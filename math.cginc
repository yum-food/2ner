#ifndef __MATH_INC
#define __MATH_INC

#define PI 3.14159265358979323846264
#define TAU (2 * PI)

float pow5(float x)
{
  float tmp = x * x;
  return (tmp * tmp) * x;
}

#endif  // __MATH_INC


