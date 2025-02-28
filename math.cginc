#ifndef __MATH_INC
#define __MATH_INC

#include "pema99.cginc"

#define PI 3.14159265358979323846264
#define TAU (2 * PI)
#define HALF_PI (PI * 0.5)
#define PHI 1.618033989
#define SQRT_2_RCP 0.707106781

float pow5(float x)
{
  float tmp = x * x;
  return (tmp * tmp) * x;
}

float wrapNoL(float NoL, float factor) {
		// https://www.iro.umontreal.ca/~derek/files/jgt_wrap_final.pdf
    return pow(max(1E-4, (NoL + factor) / (1 + factor)), 1 + factor);
}

float halfLambertianNoL(float NoL) {
		// https://www.iro.umontreal.ca/~derek/files/jgt_wrap_final.pdf
    float tmp = (NoL + 1)  * 0.5;
    return tmp * tmp;
}

float rand1(float p)
{
  return frac(sin(p) * 43758.5453123);
}

float rand2(float2 p)
{
  return frac(sin(dot(p, float2(12.9898, 78.233))) * 43758.5453123);
}

inline float rand3_dot(float3 p)
{
  return dot(p, float3(151.0, 157.0, 163.0));
}

float3 rand3_hash(float3 p)
{
    // Improved Murmurhash3 by Squirrel Eiserloh (GDC 2017)
    p = float3(dot(p, float3(127.1, 311.7, 74.7)),
               dot(p, float3(269.5, 183.3, 246.1)),
               dot(p, float3(113.5, 271.9, 124.6)));
    return -1.0 + 2.0 * frac(sin(p) * 43758.5453123);
}

float rand3(float3 p)
{
    return frac(rand3_hash(p).x);
}

float2 domainWarp1(float x, uint octaves, float strength, float scale)
{
  [loop]
  for (uint i = 0; i < octaves; i++) {
    x += strength * frac(sin(float2(
      dot(x * scale, float2(12.9898, 78.233)),
      dot(x * scale + 1, float2(12.9898, 78.233))) * 43758.5453123));
  }
  return x;
}

float2 domainWarp2(float2 uv, uint octaves, float strength, float scale)
{
  uv *= 0.001;
  [loop]
  for (uint i = 0; i < octaves; i++) {
    uv += strength * frac(sin(float2(
      dot(uv * scale, float2(12.9898, 78.233)),
      dot(uv * scale, float2(36.7539, 50.3658))) * 43758.5453123));
  }
  uv *= 1000;
  return uv;
}

float determinant(float3x3 m)
{
  return (m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
            - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]))
            + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
}

float3x3 inverse(float3x3 m)
{
  float det = determinant(m);

  float3x3 adj;
  adj[0][0] =  (m[1][1] * m[2][2] - m[1][2] * m[2][1]);
  adj[0][1] = -(m[0][1] * m[2][2] - m[0][2] * m[2][1]);
  adj[0][2] =  (m[0][1] * m[1][2] - m[0][2] * m[1][1]);
  
  adj[1][0] = -(m[1][0] * m[2][2] - m[1][2] * m[2][0]);
  adj[1][1] =  (m[0][0] * m[2][2] - m[0][2] * m[2][0]);
  adj[1][2] = -(m[0][0] * m[1][2] - m[0][2] * m[1][0]);
  
  adj[2][0] =  (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
  adj[2][1] = -(m[0][0] * m[2][1] - m[0][1] * m[2][0]);
  adj[2][2] =  (m[0][0] * m[1][1] - m[0][1] * m[1][0]);

  return adj * (1.0 / det);
}

float3 domainWarp3(float3 pos, uint octaves, float strength, float scale, float offset)
{
  [loop]
  for (uint i = 0; i < octaves; i++) {
    pos += strength * frac(sin(float3(
      rand3_dot(pos * scale + offset),
      rand3_dot(pos * scale + offset + 1),
      rand3_dot(pos * scale + offset + 2)) * 43758.5453123));
  }
  return pos;
}

void domainWarp3Normals(inout float3 normal, inout float3 tangent, float3 basePos, uint octaves, float strength, float scale, float offset)
{
    // Use the actual vertex position for correct derivative evaluation.
    float3 p = basePos;
    
    // Start with the identity matrix for the total Jacobian.
    float3x3 J = float3x3(
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
    );
    
    const float k = 43758.5453123;
    // Updated constant vector to match that of rand3_dot (used in domainWarp3)
    const float3 c = float3(151.0, 157.0, 163.0);
    
    for (uint i = 0; i < octaves; i++)
    {
        // Compute the vector v using the same offsetting as in domainWarp3.
        float3 v = float3(
            dot(p * scale + float3(offset, offset, offset), c),
            dot(p * scale + float3(offset + 1.0, offset + 1.0, offset + 1.0), c),
            dot(p * scale + float3(offset + 2.0, offset + 2.0, offset + 2.0), c)
        );
        
        // Compute the warp offset with frac.
        float3 f_val = frac(sin(v) * k);
        float3 warpOffset = strength * f_val;
        
        // Compute the derivative (Jacobian) of the offset.
        float3 cos_v = cos(v);
        float3x3 D = float3x3(
            strength * k * scale * cos_v.x * c.x, strength * k * scale * cos_v.x * c.y, strength * k * scale * cos_v.x * c.z,
            strength * k * scale * cos_v.y * c.x, strength * k * scale * cos_v.y * c.y, strength * k * scale * cos_v.y * c.z,
            strength * k * scale * cos_v.z * c.x, strength * k * scale * cos_v.z * c.y, strength * k * scale * cos_v.z * c.z
        );
        
        // The per–octave Jacobian is I + D.
        float3x3 iterJacobian = float3x3(
            1.0 + D[0][0],        D[0][1],        D[0][2],
                   D[1][0], 1.0 + D[1][1],        D[1][2],
                   D[2][0],        D[2][1], 1.0 + D[2][2]
        );
        
        // Chain this iteration's Jacobian.
        J = mul(iterJacobian, J);
        
        // Update p for the next iteration.
        p += warpOffset;
    }
    
    // Transform the normal via the inverse-transpose of the total Jacobian.
    float3x3 invTransJ = transpose(inverse(J));
    normal = normalize(mul(invTransJ, normal));
    
    // Transform the tangent via the forward total Jacobian.
    tangent = normalize(mul(J, tangent));
}

// Alpha blend `dst` onto `src`.
// Imagine two transparent planes. We're rendering a situation where you're
// looking through `front` at `behind`.
float4 alphaBlend(float4 behind, float4 front) {
  return float4(front.rgb * front.a + behind.rgb * (1 - front.a), front.a + behind.a * (1 - front.a));
}

// Reoriented normal mapping
// https://blog.selfshadow.com/publications/blending-in-detail/
// Inputs are in tangent space.
float3 blendNormalsHill12(float3 n0, float3 n1) {
  n0.z += 1.0;
  n1.xy = -n1.xy;
  
  return normalize(n0 * dot(n0, n1) - n1 * n0.z);
}

#endif  // __MATH_INC


