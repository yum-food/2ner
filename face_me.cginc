#ifndef __FACE_ME_INC
#define __FACE_ME_INC

#include "cnlohr.cginc"
#include "interpolators.cginc"

// Rotate the object's position and normal so that it always faces the camera.
void face_me(inout appdata v) {
  [branch]
  if (_Face_Me_Enabled_Dynamic) {
    float3 object_center = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
    // Get forward axis of object coordinate system, i.e. the orientation of
    // the hip bone.
    // Then project it onto the xz plane.
    float3 forward_axis = mul(unity_ObjectToWorld, float3(0, 0, 1));
    forward_axis.y = 0;
    forward_axis = normalize(forward_axis);
    float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
    float3 rd = normalize(object_center - getCenterCamPos());
    // We apply a factor of -1 to shift the result forward by a phase shift of pi.
    float cos_t = -dot(normalize(rd.xz), forward_axis.xz);
    // We want to get sin(t) using the identity:
    //   || a x b || = || a || || b || sin(t)
    // For normal vectors, this simplifies to:
    //   || a x b || = sin(t)
    // The issue is that the norm operator loses the sign.
    // We can estimate the sign by assuming that `rd` and `forward_axis` are on
    // the xz plane.
    // If that's the case, then the cross product is necessarily constrained to
    // the y axis.
    float sin_t_sign = sign(cross(rd, forward_axis).y);
    // Here we use the identity:
    //   sin(t) = sqrt(1 - cos(t)^2)
    // We simply apply the sign correction `sin_t_sign` to the result.
    // We then invert it, since the goal is not to amplify the rotation, but
    // to negate it.
    // Finally, we add a phase correction to make the abomination face us.
    float sin_t = -sqrt(1 - cos_t * cos_t) * sin_t_sign;

    // Double the angle using double-angle formulas
    if (isVR()) {
        float sin_2t = 2 * sin_t * cos_t;
        float cos_2t = cos_t * cos_t - sin_t * sin_t;  // or: 2 * cos_t * cos_t - 1
        sin_t = sin_2t;
        cos_t = cos_2t;
    }

    // Use the doubled angle values in your rotation matrix
    float2x2 face_me_rot = float2x2(cos_t, -sin_t, sin_t, cos_t);
    float2x2 face_me_rot_inv = float2x2(cos_t, sin_t, -sin_t, cos_t);
    worldPos.xz = mul(face_me_rot, (worldPos.xz - object_center.xz)) + object_center.xz;
    v.vertex = mul(unity_WorldToObject, worldPos);

    float3 world_normal = UnityObjectToWorldNormal(v.normal);
    world_normal.xz = mul(face_me_rot_inv, world_normal.xz);
    v.normal = normalize(mul(unity_WorldToObject, world_normal));

    float3 world_tangent = UnityObjectToWorldDir(v.tangent.xyz);
    world_tangent.xz = mul(face_me_rot_inv, world_tangent.xz);
    v.tangent.xyz = normalize(mul(unity_WorldToObject, world_tangent));
  }
}

#endif  // __FACE_ME_INC

