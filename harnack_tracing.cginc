#ifndef __HARNACK_TRACING_INC
#define __HARNACK_TRACING_INC

#include "cnlohr.cginc"
#include "globals.cginc"
#include "interpolators.cginc"

#if defined(_HARNACK_TRACING)

#define MAX_ITERATIONS 100
#define UNIT_SHIFT 5.0
#define WALL_THICKNESS 0.1

#define SPHERE_RADIUS 0.49
#define OUTER_RADIUS (SPHERE_RADIUS + 0.5)

float gyroid(float3 pos);
float3 gyroid_gradient(float3 pos);
bool harnackTrace(float3 ro, float3 rd, out float t, out float3 pos, out float3 normal, float tMax);
bool intersectSphere(float3 ro, float3 rd, float3 center, float radius, out float t0, out float t1);
float getRadius(float3 p);
float getMaxStep4D(float fx, float R, float levelset, float shift);
bool closeToLevelset(float f, float levelset, float tol, float gradNorm);
bool betweenLevelsets(float f, float loBound, float hiBound, float tol, float gradNorm);

struct HarnackTracingOutput {
  float4 color;
  float3 worldPos;  // intersection point in world space
  float3 normal;    // normal in world space
};

// Gyroid function implementation
float gyroid(float3 pos) {
    float timeOffset = 2.0 * PI * _Harnack_Tracing_Gyroid_Speed * _Time.y;
    float3 p = _Harnack_Tracing_Gyroid_Scale * pos + float3(0.0, timeOffset, 0.0);
    return sin(p.x) * cos(p.y) + sin(p.y) * cos(p.z) + sin(p.z) * cos(p.x);
}

// Gradient of gyroid function
float3 gyroid_gradient(float3 pos) {
    float timeOffset = 2.0 * PI * _Harnack_Tracing_Gyroid_Speed * _Time.y;
    float3 p = _Harnack_Tracing_Gyroid_Scale * pos + float3(0.0, timeOffset, 0.0);
    return float3(
        cos(p.x) * cos(p.y) - sin(p.z) * sin(p.x),
        cos(p.y) * cos(p.z) - sin(p.x) * sin(p.y),
        cos(p.z) * cos(p.x) - sin(p.y) * sin(p.z)
    ) * _Harnack_Tracing_Gyroid_Scale;
}

// Get radius from point to outer boundary
float getRadius(float3 p) {
    return OUTER_RADIUS - length(p);
}

// Calculate if point is close to levelset
bool closeToLevelset(float f, float levelset, float tol, float gradNorm) {
    return abs(f - levelset) < tol;
}

// Calculate if point is between levelsets (for wall thickness)
bool betweenLevelsets(float f, float loBound, float hiBound, float tol, float gradNorm) {
    return max(loBound - f, f - hiBound) < tol;
}

// Sphere intersection test
bool intersectSphere(float3 ro, float3 rd, float3 center, float radius, out float t0, out float t1) {
    float3 oc = ro - center;
    float b = dot(oc, rd);
    float c = dot(oc, oc) - radius * radius;
    float h = b * b - c;
    
    if (h < 0.0) return false;
    
    h = sqrt(h);
    t0 = -b - h;
    t1 = -b + h;
    
    return true;
}

// Calculate maximum step size for Harnack tracing
float getMaxStep4D(float fx, float R, float levelset, float shift) {
    float a = (fx + shift) / (levelset + shift);
    float u = pow(3.0 * sqrt(3.0 * pow(a, 3.0) + 81.0 * pow(a, 2.0)) + 27.0 * a, 1.0 / 3.0);
    return R * abs(u / 3.0 - a / u - 1.0);
}

// Main Harnack tracing function
bool harnackTrace(float3 ro, float3 rd, out float t, out float3 pos, out float3 normal, float tMax) {
    t = 0.0;
    float levelset = sin(_Harnack_Tracing_Gyroid_Speed * _Time.y);
    
    // Early sphere intersection test
    float t0, t1;
    if (!intersectSphere(ro, rd, float3(0,0,0), SPHERE_RADIUS, t0, t1) || tMax < 0.0) 
        return false;
    
    // Optimize bounds
    t = max(t0, 0.0);
    tMax = min(t1, tMax);
    
    // Check immediate intersection
    pos = ro + t0 * rd;
    float val = gyroid(pos);
    float3 gradF = gyroid_gradient(pos);
    if (betweenLevelsets(val, levelset - WALL_THICKNESS, levelset + WALL_THICKNESS, 0.025, length(gradF))) {
        normal = normalize(gradF);
        return true;
    }

    float t_overstep = 0.0;
    
    [loop]
    for (int iters = 0; iters < MAX_ITERATIONS && t < tMax; iters++) {
        pos = ro + t * rd + t_overstep * rd;
        
        val = gyroid(pos);
        gradF = gyroid_gradient(pos);
        
        float offset_levelset = clamp(val, levelset - WALL_THICKNESS, levelset + WALL_THICKNESS);
        
        float R = getRadius(pos);
        float shift = exp(sqrt(2.0) * R) * UNIT_SHIFT;
        float r = getMaxStep4D(val, R, offset_levelset, shift);
        
        if (r >= t_overstep && closeToLevelset(val, offset_levelset, 0.025, length(gradF))) {
            normal = normalize(gradF);
            return true;
        }
        
        float stepSize = (r >= t_overstep) ? t_overstep + r : 0.0;
        t_overstep = (r >= t_overstep) ? r * 0.75 : 0.0;
        t += stepSize;
    }
     
    normal = float3(0,0,0);
    return false;
}

HarnackTracingOutput HarnackTracing(v2f i) {
  HarnackTracingOutput o = (HarnackTracingOutput)0;
  
#if defined(_HARNACK_TRACING_GYROID)
  float3 worldRo = _WorldSpaceCameraPos;
  float3 ro = mul(unity_WorldToObject, float4(worldRo, 1.0)).xyz;
  
  float3 worldRd = normalize(i.worldPos - worldRo);
  float3 rd = normalize(mul((float3x3)unity_WorldToObject, worldRd));
  
  float t;
  float3 pos;
  float3 normal;
  
  bool hit = harnackTrace(ro, rd, t, pos, normal, 100.0);
  
  if (hit) {
    o.color = 1;
    o.worldPos = mul(unity_ObjectToWorld, float4(pos, 1.0)).xyz;
    o.normal = normalize(mul(transpose((float3x3)unity_WorldToObject), normal));
  }
#endif
  
  return o;
}

#endif  // _HARNACK_TRACING

#endif  // __HARNACK_TRACING_INC
