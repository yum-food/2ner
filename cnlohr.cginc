#ifndef __CNLOHR_INC
#define __CNLOHR_INC

#include "globals.cginc"
#include "interpolators.cginc"

/*
 * MIT License
 *
 * NOTE: Much content here is originally from others.  Content in third party
 * folder may not be fully MIT-licensable. 
 *
 * Copyright (c) 2021 cnlohr, et. al.
 *
 * All other content in this repository falls under the following terms:
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE
 * SOFTWARE.
 */

// Source:
// https://github.com/cnlohr/shadertrixx?tab=readme-ov-file#eye-center-position
bool isMirror() { return _VRChatMirrorMode != 0; }

// Source:
// https://github.com/cnlohr/shadertrixx?tab=readme-ov-file#eye-center-position
float3 getCenterCamPos() {
#if defined(USING_STEREO_MATRICES) || defined(UNITY_SINGLE_PASS_STEREO)
  return (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * 0.5;
#else
  return isMirror() ? _VRChatMirrorCameraPos : _WorldSpaceCameraPos.xyz;
#endif
}

bool isVR() {
#if defined(USING_STEREO_MATRICES)
  return true;
#else
  return false;
#endif
}

float GetLinearZFromZDepth_WorksWithMirrors(float zDepthFromMap, float2 screenUV)
{
	#if defined(UNITY_REVERSED_Z)
		zDepthFromMap = 1 - zDepthFromMap;

		// When using a mirror, the far plane is whack.  This just checks for it and aborts.
		if( zDepthFromMap >= 1.0 ) return _ProjectionParams.z;
	#endif

	float4 clipPos = float4(screenUV.xy, zDepthFromMap, 1.0);
	clipPos.xyz = 2.0f * clipPos.xyz - 1.0f;
	float4 camPos = mul(unity_CameraInvProjection, clipPos);
	return -camPos.z / camPos.w;
}

void GetScreenUVAndPerspectiveFactor(float3 worldPos, float4 clipPos, out float2 screen_uv, out float perspective_factor) {
    float3 full_vec_eye_to_geometry = worldPos - _WorldSpaceCameraPos;
    float perspective_divide = 1.0f / clipPos.w;
    perspective_factor = length(full_vec_eye_to_geometry * perspective_divide);
    screen_uv = ComputeScreenPos(clipPos).xy;
}

#if defined(_SSAO)
float GetDepthOfWorldPos(float3 worldPos, out float2 debug)
{
  float3 objPos = mul(unity_WorldToObject, float4(worldPos, 1));
  float4 clipPos = UnityObjectToClipPos(objPos);
  float4 screenPos = ComputeScreenPos(clipPos);
  const float2 screen_uv = screenPos.xy / screenPos.w;

  float zDepthFromMap = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screen_uv);
  float linearZ =
    GetLinearZFromZDepth_WorksWithMirrors(zDepthFromMap, screen_uv);
  linearZ = min(1E3, linearZ);

	debug = screen_uv;
  return linearZ;
}
#endif

#endif  // __CNLOHR_INC
