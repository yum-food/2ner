#ifndef __DATA_INC
#define __DATA_INC

struct YumPbr {
  float4 albedo;
  float3 normal;
  float3 emission;
  float smoothness;
  float roughness;
  float roughness_perceptual;
  float metallic;
  float ao;
};

#endif  // __DATA_INC

