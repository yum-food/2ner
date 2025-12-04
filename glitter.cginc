#ifndef __GLITTER_INC
#define __GLITTER_INC

#include "math.cginc"
#include "pema99.cginc"
#include "quilez.cginc"

struct GlitterParams {
    float4 color;
    float2 uv_channel;
    uint layers;
    float cell_size;
    float size;
    float major_minor_ratio;
    float angle_randomization_range;
    float center_randomization_range;
    float size_randomization_range;
    float existence_chance;
#if defined(_GLITTER_ANGLE_LIMIT)
    float angle_limit;
    float angle_limit_transition_width;
#endif
#if defined(_GLITTER_MASK)
    float mask;
#endif
};

static const float2 glitter_offset_vectors[6] = {
    float2(0.0, 1.0),               // 0 degrees
    float2(0.866025, 0.5),          // 60 degrees
    float2(0.866025, -0.5),         // 120 degrees
    float2(0.0, -1.0),              // 180 degrees
    float2(-0.866025, -0.5),        // 240 degrees
    float2(-0.866025, 0.5)          // 300 degrees
};


float4 getGlitter(v2f i, GlitterParams params, float3 normal) {
  float c_acc = 0;
  [loop]
  for (uint layer_i = 0; layer_i < params.layers; layer_i++) {
    float2 uv = get_uv_by_channel(i, params.uv_channel);
    float2 p = uv + glitter_offset_vectors[layer_i] * params.cell_size * 0.5;

    float3 cell_id = float3(floor(p / params.cell_size), layer_i);
    float cell_rand = rand3(cell_id*.0001);
    float cell_rand2 = rand3((cell_id+1)*.0001);
    p = glsl_mod(p, params.cell_size);
    p -= params.cell_size * 0.5;
    // Apply center randomization
    p.x += (cell_rand * 2 - 1) * params.center_randomization_range * (params.cell_size * (1 - params.size)) * 0.5;
    // Apply angle randomization
    float2x2 p_rot = float2x2(
      cos(cell_rand * TAU * params.angle_randomization_range), -sin(cell_rand * TAU * params.angle_randomization_range),
      sin(cell_rand * TAU * params.angle_randomization_range), cos(cell_rand * TAU * params.angle_randomization_range)
    );
    p = mul(p_rot, p);

    // Draw ellipses
    // First arg is position to evaluate distance at. We project onto z=0.
    // Second arg is the size of the ellipse. We set z to cell size because I
    // think setting it to 0 would probably create fucked up curvature.
    float3 size = float3(params.size * float2(params.major_minor_ratio, 1) * params.cell_size * 0.5, params.cell_size);
    // Apply size randomization
    size *= (1 - cell_rand * params.size_randomization_range);
    // TODO find a good 2d ellipse sdf
    float d = distance_from_ellipsoid(float3(p, 0), size);
    // TODO antialias using fwidth
    float c = (d < 0) * params.color.a;
    c *= (cell_rand2 < params.existence_chance);
    c_acc = c + (1 - c) * c_acc;
  }
#if defined(_GLITTER_ANGLE_LIMIT)
  float VdotN = dot(-normalize(i.eyeVec.xyz), normal);
  float angle_mask = smoothstep(
    cos(params.angle_limit * PI), 
    cos(params.angle_limit * (1 - params.angle_limit_transition_width) * PI), 
    VdotN);
  c_acc *= angle_mask;
#endif
#if defined(_GLITTER_MASK)
  c_acc *= params.mask;
#endif
  return float4(params.color.rgb, c_acc);
}

#endif // __GLITTER_INC


