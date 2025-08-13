#ifndef __TROCHOID_MATH
#define __TROCHOID_MATH

#if defined(_TROCHOID)

#include "globals.cginc"

#define PI 3.14159265
#define TAU PI * 2.0

float3 _trochoid_map(float theta, float r0, float vert_z)
{
  r0 = pow(r0, _Trochoid_r_Power);
  r0 *= 100;

  float R = _Trochoid_R;
  float r = _Trochoid_r;
  float d = _Trochoid_d;

  theta *= max(R, r) * _Trochoid_theta_k;
  float theta_t = theta + _Time[2] * _Trochoid_t_k;

  float x = (R - r) * cos(theta_t) + d * cos((R - r) * theta_t / r);
  float y = (R - r) * sin(theta_t) - d * sin((R - r) * theta_t / r);
  float z = vert_z + cos(theta_t * 5) * .1 + theta * .0002;

  float3 result = float3(x, y, z) * r0;
  float3 trochoid_scale = float3(_Trochoid_X_Scale, _Trochoid_Y_Scale, _Trochoid_Z_Scale);
  result *= trochoid_scale;
  return result;
}

float3 trochoid_map(float3 pos)
{
  float theta = atan2(pos.y, pos.x);
  float r0 = length(pos.xy) * theta;
  float z = pos.z;
  float3 result = _trochoid_map(theta, r0, z);
  return result;
}

float3 trochoid_normal(float3 pos)
{
    // Parameters of the trochoid
    float R = _Trochoid_R;
    float r = _Trochoid_r;
    float d = _Trochoid_d;
    float theta_k = max(R, r) * _Trochoid_theta_k;
    float t_k = _Trochoid_t_k;
    float time = _Time[2];
    float r_power = _Trochoid_r_Power;

    // Intermediate variables based on input position
    float r_orig = max(length(pos.xy), 1e-5); // Avoid division by zero
    float theta = atan2(pos.y, pos.x);
    
    float r0 = r_orig * theta;
    float theta_scaled = theta * theta_k;
    float theta_t = theta_scaled + time * t_k;

    // Components of the trochoid function before final scaling
    float C1 = cos(theta_t);
    float S1 = sin(theta_t);
    float common_factor = (R - r) / r;
    float C2 = cos(common_factor * theta_t);
    float S2 = sin(common_factor * theta_t);

    float p_x = (R - r) * C1 + d * C2;
    float p_y = (R - r) * S1 - d * S2;
    float p_z = pos.z + cos(theta_t * 5.0) * 0.1 + theta * 0.0002;

    // Partial derivatives of the components with respect to theta_t
    float dp_x_dt = -(R - r) * S1 - d * common_factor * S2;
    float dp_y_dt =  (R - r) * C1 - d * common_factor * C2;
    float dp_z_dt = -sin(theta_t * 5.0) * 5.0 * 0.1;

    // Partial derivatives of intermediate variables w.r.t. pos.x and pos.y
    float d_theta_dx = -pos.y / (r_orig * r_orig);
    float d_theta_dy =  pos.x / (r_orig * r_orig);
    float d_r_orig_dx = pos.x / r_orig;
    float d_r_orig_dy = pos.y / r_orig;

    // The r0-dependent scaling factor and its derivative
    float F = 100.0 * pow(r0, r_power);
    float dF_dr0 = 100.0 * r_power * pow(r0, r_power - 1.0);

    // Chain rule for tangents
    // Tangent with respect to pos.x
    float d_r0_dx = d_r_orig_dx * theta + r_orig * d_theta_dx;
    float d_theta_t_dx = d_theta_dx * theta_k;
    float dF_dx = dF_dr0 * d_r0_dx;

    float dp_x_dx = dp_x_dt * d_theta_t_dx;
    float dp_y_dx = dp_y_dt * d_theta_t_dx;
    float dp_z_dx = dp_z_dt * d_theta_t_dx + 0.0002 * d_theta_dx;
    
    float3 trochoid_scale = float3(_Trochoid_X_Scale, _Trochoid_Y_Scale, _Trochoid_Z_Scale);
    float3 T_x = trochoid_scale * (dF_dx * float3(p_x, p_y, p_z) + F * float3(dp_x_dx, dp_y_dx, dp_z_dx));

    // Tangent with respect to pos.y
    float d_r0_dy = d_r_orig_dy * theta + r_orig * d_theta_dy;
    float d_theta_t_dy = d_theta_dy * theta_k;
    float dF_dy = dF_dr0 * d_r0_dy;
    
    float dp_x_dy = dp_x_dt * d_theta_t_dy;
    float dp_y_dy = dp_y_dt * d_theta_t_dy;
    float dp_z_dy = dp_z_dt * d_theta_t_dy + 0.0002 * d_theta_dy;

    float3 T_y = trochoid_scale * (dF_dy * float3(p_x, p_y, p_z) + F * float3(dp_x_dy, dp_y_dy, dp_z_dy));
    
    return normalize(cross(T_x, T_y));
}

#endif  // _TROCHOID

#endif  // __TROCHOID_MATH

