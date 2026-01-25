#ifndef __FILAMENTED_INC
#define __FILAMENTED_INC

#include "SharedSamplingLib.hlsl"
#include "SharedFilteringLib.hlsl"

#include "UnityImageBasedLighting.cginc"
#include "UnityStandardUtils.cginc"

#include "data.cginc"
#include "math.cginc"

// I made changes to this code.

/*
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

Unity Built-in Shaders   

Copyright (c) 2016 Unity Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// Check if Bakery is available
#if defined(_BAKERY_RNM) || defined(_BAKERY_SH) || defined(_BAKERY_MONOSH)
    #define USING_BAKERY 1
#endif

// Bakery textures (Unity auto-binds these)
#if defined(_BAKERY_RNM) || defined(_BAKERY_SH) || defined(_BAKERY_MONOSH)
TEXTURE2D(_RNM0);
TEXTURE2D(_RNM1);
TEXTURE2D(_RNM2);
SAMPLER(sampler_RNM0);
#endif



#define MIN_PERCEPTUAL_ROUGHNESS 0.045

UNITY_DECLARE_TEX2D_FLOAT(_DFG);

// Filamented defines for spherical harmonics
#define SPHERICAL_HARMONICS_DEFAULT         0
#define SPHERICAL_HARMONICS_GEOMETRICS      1
#define SPHERICAL_HARMONICS_ZH3             2
#define SPHERICAL_HARMONICS SPHERICAL_HARMONICS_ZH3
#define SPHERICAL_HARMONICS_USE_L2          0

// Light struct from filamented
struct Light {
    float4 colorIntensity;
    float3 l;
    float attenuation;
    float NoL;
    float3 worldPosition;
};

// Helper functions
half getExposureOcclusionBias()
{
    return 1.0/(_ExposureOcclusion);
}

bool getIsBakeryVertexMode()
{
#if defined(USING_BAKERY_VERTEXLM)
    #define BAKERYMODE_DEFAULT 0
    #define BAKERYMODE_VERTEXLM 1.0f
    #define BAKERYMODE_RNM 2.0f
    #define BAKERYMODE_SH 3.0f
    return (bakeryLightmapMode == BAKERYMODE_VERTEXLM);
#endif
    return false;
}

half getLightVolumeSurfaceBias()
{
    #if defined(_VRCLV)
    return _VRCLVSurfaceBias;
    #else
    return 0;
    #endif
}

// Geomerics spherical harmonics evaluation
float shEvaluateDiffuseL1Geomerics_local(float L0, float3 L1, float3 n)
{
    float R0 = max(L0, 0);
    float3 R1 = 0.5f * L1;
    float lenR1 = length(R1);
    float q = dot(normalize(R1), n) * 0.5 + 0.5;
    q = saturate(q);
    float p = 1.0f + 2.0f * lenR1 / R0;
    float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);
    return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
}

// ZH3 constants and functions
const static float L0IrradianceToRadiance = 2 * sqrt(UNITY_PI);
const static float L1IrradianceToRadiance = sqrt(3 * UNITY_PI);
const static float4 L0L1IrradianceToRadiance = float4(L0IrradianceToRadiance, L1IrradianceToRadiance, L1IrradianceToRadiance, L1IrradianceToRadiance);

float SHEvalLinearL0L1_ZH3Hallucinate(float4 sh, float3 normal)
{
    float4 radiance = sh * L0L1IrradianceToRadiance;
    float3 zonalAxis = float3(radiance.w, radiance.y, radiance.z);
    float l1Length = length(zonalAxis);
    zonalAxis /= l1Length;
    float ratio = l1Length / radiance.x;
    float zonalL2Coeff = radiance.x * ratio * (0.08 + 0.6 * ratio);
    float fZ = dot(zonalAxis, normal);
    float zhNormal = sqrt(5.0f / (16.0f * UNITY_PI)) * (3.0f * fZ * fZ - 1.0f);
    float result = dot(sh, float4(1, float3(normal.y, normal.z, normal.x)));
    result += 0.25f * zhNormal * zonalL2Coeff;
    return result;
}

float3 SHEvalLinearL0L1_ZH3Hallucinate(float3 normal)
{
    float3 shL0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) +
        float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
    float3 shL1_1 = float3(unity_SHAr.y, unity_SHAg.y, unity_SHAb.y);
    float3 shL1_2 = float3(unity_SHAr.z, unity_SHAg.z, unity_SHAb.z);
    float3 shL1_3 = float3(unity_SHAr.x, unity_SHAg.x, unity_SHAb.x);

    float3 result = 0.0;
    float4 a = float4(shL0.r, shL1_1.r, shL1_2.r, shL1_3.r);
    float4 b = float4(shL0.g, shL1_1.g, shL1_2.g, shL1_3.g);
    float4 c = float4(shL0.b, shL1_1.b, shL1_2.b, shL1_3.b);
    result.r = SHEvalLinearL0L1_ZH3Hallucinate(a, normal);
    result.g = SHEvalLinearL0L1_ZH3Hallucinate(b, normal);
    result.b = SHEvalLinearL0L1_ZH3Hallucinate(c, normal);
    return result;
}

float3 Irradiance_SphericalHarmonics(const float3 n, const bool useL2) {
    float3 finalSH = float3(0,0,0); 

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_DEFAULT)
        finalSH = SHEvalLinearL0L1(half4(n, 1.0));
    #endif

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_GEOMETRICS)
        float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
        float3 L0L2 = float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
        L0 = (useL2) ? L0+L0L2 : L0-L0L2;
        finalSH.r = shEvaluateDiffuseL1Geomerics_local(L0.r, unity_SHAr.xyz, n);
        finalSH.g = shEvaluateDiffuseL1Geomerics_local(L0.g, unity_SHAg.xyz, n);
        finalSH.b = shEvaluateDiffuseL1Geomerics_local(L0.b, unity_SHAb.xyz, n);
    #endif

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_ZH3)
        finalSH = SHEvalLinearL0L1_ZH3Hallucinate(half4(n, 1.0));
    #endif

    #if (SPHERICAL_HARMONICS_USE_L2 == 1)
        if (useL2) finalSH += SHEvalLinearL2(half4(n, 1.0));
    #endif    

    return finalSH;
}

float3 Irradiance_SphericalHarmonics(const float3 n) {
    return Irradiance_SphericalHarmonics(n, true);
}

#if UNITY_LIGHT_PROBE_PROXY_VOLUME
half3 Irradiance_SampleProbeVolume (half4 normal, float3 worldPos)
{
    const float transformToLocal = unity_ProbeVolumeParams.y;
    const float texelSizeX = unity_ProbeVolumeParams.z;

    float3 position = (transformToLocal == 1.0f) ? mul(unity_ProbeVolumeWorldToObject, float4(worldPos, 1.0)).xyz : worldPos;
    float3 texCoord = (position - unity_ProbeVolumeMin.xyz) * unity_ProbeVolumeSizeInv.xyz;
    texCoord.x = texCoord.x * 0.25f;

    float texCoordX = clamp(texCoord.x, 0.5f * texelSizeX, 0.25f - 0.5f * texelSizeX);

    texCoord.x = texCoordX;
    half4 SHAr = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    texCoord.x = texCoordX + 0.25f;
    half4 SHAg = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    texCoord.x = texCoordX + 0.5f;
    half4 SHAb = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, texCoord);

    half3 x1;

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_DEFAULT)
        x1.r = dot(SHAr, normal);
        x1.g = dot(SHAg, normal);
        x1.b = dot(SHAb, normal);
    #endif

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_GEOMETRICS)
        x1.r = shEvaluateDiffuseL1Geomerics_local(SHAr.w, SHAr.rgb, normal);
        x1.g = shEvaluateDiffuseL1Geomerics_local(SHAg.w, SHAg.rgb, normal);
        x1.b = shEvaluateDiffuseL1Geomerics_local(SHAb.w, SHAb.rgb, normal);
    #endif

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_ZH3)
        x1.r = SHEvalLinearL0L1_ZH3Hallucinate(float4(SHAr.w, SHAr.rgb), normal);
        x1.g = SHEvalLinearL0L1_ZH3Hallucinate(float4(SHAg.w, SHAg.rgb), normal);
        x1.b = SHEvalLinearL0L1_ZH3Hallucinate(float4(SHAb.w, SHAb.rgb), normal);
    #endif

    return x1;
}
#endif

#if defined(_VRCLV)
half3 Irradiance_SampleVRCLightVolume(half3 normal, float3 worldPos, out Light derivedLight)
{
    derivedLight = (Light)0;
    float3 samplePos = worldPos + normal * getLightVolumeSurfaceBias();
    
    float3 L0, L1r, L1g, L1b;
    LightVolumeSH(samplePos, L0, L1r, L1g, L1b);

    half3 irradiance = 0.0;

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_DEFAULT)
        irradiance.r = dot(L1r, normal.xyz) + L0.r;
        irradiance.g = dot(L1g, normal.xyz) + L0.g;
        irradiance.b = dot(L1b, normal.xyz) + L0.b;
    #endif

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_GEOMETRICS)
        irradiance.r = shEvaluateDiffuseL1Geomerics_local(L0.r, L1r, normal.xyz);
        irradiance.g = shEvaluateDiffuseL1Geomerics_local(L0.g, L1g, normal.xyz);
        irradiance.b = shEvaluateDiffuseL1Geomerics_local(L0.b, L1b, normal.xyz);
    #endif

    #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_ZH3)
        irradiance.r = shEvaluateDiffuseL1Geomerics_local(L0.r, L1r, normal.xyz);
        irradiance.g = shEvaluateDiffuseL1Geomerics_local(L0.g, L1g, normal.xyz);
        irradiance.b = shEvaluateDiffuseL1Geomerics_local(L0.b, L1b, normal.xyz);
    #endif
    
    #if defined(LIGHTMAP_SPECULAR)
    float3 nL1x = float3(L1r[0], L1g[0], L1b[0]);
    float3 nL1y = float3(L1r[1], L1g[1], L1b[1]);
    float3 nL1z = float3(L1r[2], L1g[2], L1b[2]);
    float3 dominantDir = float3(luminance(nL1x), luminance(nL1y), luminance(nL1z));

    derivedLight.l = dominantDir;
    half directionality = max(FLT_EPS, length(derivedLight.l));
    derivedLight.l /= directionality;

    derivedLight.colorIntensity = float4(irradiance * directionality, 1.0);
    derivedLight.attenuation = directionality;
    derivedLight.NoL = saturate(dot(normal, derivedLight.l));
    #endif

    return irradiance;
}

half3 Irradiance_SampleVRCLightVolumeAdditive(half3 normal, float3 worldPos, out Light derivedLight)
{
    derivedLight = (Light)0;

    if (!_UdonLightVolumeEnabled || _UdonLightVolumeAdditiveCount == 0) return 0;
    
    float3 L0, L1r, L1g, L1b;
    LightVolumeAdditiveSH(worldPos, L0, L1r, L1g, L1b);

    half3 irradiance = 0.0;
    irradiance.r = dot(L1r, normal.xyz) + L0.r;
    irradiance.g = dot(L1g, normal.xyz) + L0.g;
    irradiance.b = dot(L1b, normal.xyz) + L0.b;
    
    #if defined(LIGHTMAP_SPECULAR)
    float3 nL1x = float3(L1r[0], L1g[0], L1b[0]);
    float3 nL1y = float3(L1r[1], L1g[1], L1b[1]);
    float3 nL1z = float3(L1r[2], L1g[2], L1b[2]);
    float3 dominantDir = float3(luminance(nL1x), luminance(nL1y), luminance(nL1z));

    derivedLight.l = dominantDir;
    half directionality = max(FLT_EPS, length(derivedLight.l));
    derivedLight.l /= directionality;

    derivedLight.colorIntensity = float4(irradiance * directionality, 1.0);
    derivedLight.attenuation = directionality;
    derivedLight.NoL = saturate(dot(normal, derivedLight.l));
    #endif

    return irradiance;
}
#endif

half3 Irradiance_SphericalHarmonicsUnity (half3 normal, half3 ambient, float3 worldPos, out Light derivedLight)
{
    half3 ambient_contrib = 0.0;
    derivedLight = (Light)0;

#if defined(_VRCLV)
    #if UNITY_LIGHT_PROBE_PROXY_VOLUME
        if (unity_ProbeVolumeParams.x == 1.0)
            ambient_contrib = Irradiance_SampleProbeVolume(half4(normal, 1.0), worldPos);
        else
            ambient_contrib = Irradiance_SampleVRCLightVolume(normal, worldPos, derivedLight);
    #else
        ambient_contrib = Irradiance_SampleVRCLightVolume(normal, worldPos, derivedLight);
    #endif

    ambient += max(half3(0, 0, 0), ambient_contrib);

    #ifdef UNITY_COLORSPACE_GAMMA
        ambient = LinearToGammaSpace (ambient);
    #endif

    return ambient;
#else

    #if UNITY_SAMPLE_FULL_SH_PER_PIXEL
        #if UNITY_LIGHT_PROBE_PROXY_VOLUME
            if (unity_ProbeVolumeParams.x == 1.0)
                ambient_contrib = Irradiance_SampleProbeVolume(half4(normal, 1.0), worldPos);
            else
                ambient_contrib = Irradiance_SphericalHarmonics(normal, true);
        #else
            ambient_contrib = Irradiance_SphericalHarmonics(normal, true);
        #endif

            ambient += max(half3(0, 0, 0), ambient_contrib);

        #ifdef UNITY_COLORSPACE_GAMMA
            ambient = LinearToGammaSpace(ambient);
        #endif
    #elif (SHADER_TARGET < 30) || UNITY_STANDARD_SIMPLE
        // Completely per-vertex
    #else
        #if UNITY_LIGHT_PROBE_PROXY_VOLUME
            if (unity_ProbeVolumeParams.x == 1.0)
                ambient_contrib = Irradiance_SampleProbeVolume (half4(normal, 1.0), worldPos);
            else
                ambient_contrib = Irradiance_SphericalHarmonics(normal, false);
        #else
            ambient_contrib = Irradiance_SphericalHarmonics(normal, false);
        #endif

        ambient = max(half3(0, 0, 0), ambient+ambient_contrib);
        #ifdef UNITY_COLORSPACE_GAMMA
            ambient = LinearToGammaSpace (ambient);
        #endif
    #endif

    return ambient;
#endif
}

float4 SampleLightmapBicubic(float2 uv)
{
    #if defined(SHADER_API_D3D11)
        float width, height;
        unity_Lightmap.GetDimensions(width, height);
        float4 unity_Lightmap_TexelSize = float4(width, height, 1.0/width, 1.0/height);
        return SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(unity_Lightmap, samplerunity_Lightmap),
            uv, unity_Lightmap_TexelSize);
    #else
        return SAMPLE_TEXTURE2D(unity_Lightmap, samplerunity_Lightmap, uv);
    #endif
}

float4 SampleLightmapDirBicubic(float2 uv)
{
    #if defined(SHADER_API_D3D11) && false
        float width, height;
        unity_LightmapInd.GetDimensions(width, height);
        float4 unity_LightmapInd_TexelSize = float4(width, height, 1.0/width, 1.0/height);
        return SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(unity_LightmapInd, samplerunity_Lightmap),
            uv, unity_LightmapInd_TexelSize);
    #else
        return SAMPLE_TEXTURE2D(unity_LightmapInd, samplerunity_Lightmap, uv);
    #endif
}

float4 SampleDynamicLightmapBicubic(float2 uv)
{
    #if defined(SHADER_API_D3D11)
        float width, height;
        unity_DynamicLightmap.GetDimensions(width, height);
        float4 unity_DynamicLightmap_TexelSize = float4(width, height, 1.0/width, 1.0/height);
        return SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(unity_DynamicLightmap, samplerunity_DynamicLightmap),
            uv, unity_DynamicLightmap_TexelSize);
    #else
        return SAMPLE_TEXTURE2D(unity_DynamicLightmap, samplerunity_DynamicLightmap, uv);
    #endif
}

float4 SampleDynamicLightmapDirBicubic(float2 uv)
{
    #if defined(SHADER_API_D3D11) && false
        float width, height;
        unity_DynamicDirectionality.GetDimensions(width, height);
        float4 unity_DynamicDirectionality_TexelSize = float4(width, height, 1.0/width, 1.0/height);
        return SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(unity_DynamicDirectionality, samplerunity_DynamicLightmap),
            uv, unity_DynamicDirectionality_TexelSize);
    #else
        return SAMPLE_TEXTURE2D(unity_DynamicDirectionality, samplerunity_DynamicLightmap, uv);
    #endif
}

inline float3 DecodeDirectionalLightmapSpecular(half3 color, half4 dirTex, half3 normalWorld, 
    const bool isRealtimeLightmap, fixed4 realtimeNormalTex, out Light o_light)
{
    o_light = (Light)0;
    o_light.colorIntensity = float4(color, 1.0);
    o_light.l = dirTex.xyz * 2 - 1;

    half directionality = max(0.001, length(o_light.l));
    o_light.l /= directionality;

    #ifdef DYNAMICLIGHTMAP_ON
    if (isRealtimeLightmap)
    {
        half3 realtimeNormal = realtimeNormalTex.xyz * 2 - 1;
        o_light.colorIntensity /= max(0.125, dot(realtimeNormal, o_light.l));
    }
    #endif

    half3 ambient = o_light.colorIntensity * (1 - directionality);
    o_light.colorIntensity = o_light.colorIntensity * directionality;
    o_light.attenuation = directionality;
    o_light.NoL = saturate(dot(normalWorld, o_light.l));

    return color;
}

#if defined(USING_BAKERY) && defined(LIGHTMAP_ON)
float3 DecodeRNMLightmap(half3 color, half2 lightmapUV, half3 normalTangent, float3x3 tangentToWorld, out Light o_light)
{
    const float rnmBasis0 = float3(0.816496580927726f, 0, 0.5773502691896258f);
    const float rnmBasis1 = float3(-0.4082482904638631f, 0.7071067811865475f, 0.5773502691896258f);
    const float rnmBasis2 = float3(-0.4082482904638631f, -0.7071067811865475f, 0.5773502691896258f);

    float3 irradiance;
    o_light = (Light)0;

    #if defined(SHADER_API_D3D11)
        float width, height;
        _RNM0.GetDimensions(width, height);
        float4 rnm_TexelSize = float4(width, height, 1.0/width, 1.0/height);
        
        float3 rnm0 = DecodeLightmap(SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(_RNM0, sampler_RNM0), lightmapUV, rnm_TexelSize));
        float3 rnm1 = DecodeLightmap(SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(_RNM1, sampler_RNM0), lightmapUV, rnm_TexelSize));
        float3 rnm2 = DecodeLightmap(SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(_RNM2, sampler_RNM0), lightmapUV, rnm_TexelSize));
    #else
        float3 rnm0 = DecodeLightmap(SAMPLE_TEXTURE2D(_RNM0, sampler_RNM0, lightmapUV));
        float3 rnm1 = DecodeLightmap(SAMPLE_TEXTURE2D(_RNM1, sampler_RNM0, lightmapUV));
        float3 rnm2 = DecodeLightmap(SAMPLE_TEXTURE2D(_RNM2, sampler_RNM0, lightmapUV));
    #endif

    normalTangent.g *= -1;

    irradiance =  saturate(dot(rnmBasis0, normalTangent)) * rnm0
                + saturate(dot(rnmBasis1, normalTangent)) * rnm1
                + saturate(dot(rnmBasis2, normalTangent)) * rnm2;

    #if defined(LIGHTMAP_SPECULAR)
    float3 dominantDirT = rnmBasis0 * luminance(rnm0) +
                          rnmBasis1 * luminance(rnm1) +
                          rnmBasis2 * luminance(rnm2);

    float3 dominantDirTN = normalize(dominantDirT);
    float3 specColor = saturate(dot(rnmBasis0, dominantDirTN)) * rnm0 +
                       saturate(dot(rnmBasis1, dominantDirTN)) * rnm1 +
                       saturate(dot(rnmBasis2, dominantDirTN)) * rnm2;                        

    o_light.l = normalize(mul(tangentToWorld, dominantDirT));
    half directionality = max(0.001, length(o_light.l));
    o_light.l /= directionality;

    o_light.colorIntensity = float4(specColor * directionality, 1.0);
    o_light.attenuation = directionality;
    o_light.NoL = saturate(dot(normalTangent, dominantDirTN));
    #endif

    return irradiance;
}

float3 DecodeSHLightmap(half3 L0, half2 lightmapUV, half3 normalWorld, out Light o_light)
{
    float3 irradiance;
    o_light = (Light)0;

    #if defined(SHADER_API_D3D11)
        float width, height;
        _RNM0.GetDimensions(width, height);
        float4 rnm_TexelSize = float4(width, height, 1.0/width, 1.0/height);
        
        float3 nL1x = SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(_RNM0, sampler_RNM0), lightmapUV, rnm_TexelSize);
        float3 nL1y = SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(_RNM1, sampler_RNM0), lightmapUV, rnm_TexelSize);
        float3 nL1z = SampleTexture2DBicubicFilter(TEXTURE2D_ARGS(_RNM2, sampler_RNM0), lightmapUV, rnm_TexelSize);
    #else
        float3 nL1x = SAMPLE_TEXTURE2D(_RNM0, sampler_RNM0, lightmapUV);
        float3 nL1y = SAMPLE_TEXTURE2D(_RNM1, sampler_RNM0, lightmapUV);
        float3 nL1z = SAMPLE_TEXTURE2D(_RNM2, sampler_RNM0, lightmapUV);
    #endif

    nL1x = nL1x * 2 - 1;
    nL1y = nL1y * 2 - 1;
    nL1z = nL1z * 2 - 1;
    float3 L1x = nL1x * L0 * 2;
    float3 L1y = nL1y * L0 * 2;
    float3 L1z = nL1z * L0 * 2;

    #ifdef BAKERY_SHNONLINEAR
        float lumaL0 = dot(L0, float(1));
        float lumaL1x = dot(L1x, float(1));
        float lumaL1y = dot(L1y, float(1));
        float lumaL1z = dot(L1z, float(1));

        float lumaSH = shEvaluateDiffuseL1Geomerics_local(lumaL0, float3(lumaL1x, lumaL1y, lumaL1z), normalWorld);

        #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_ZH3)
            lumaSH = SHEvalLinearL0L1_ZH3Hallucinate(float4(lumaL0, lumaL1y, lumaL1z, lumaL1x), normalWorld);
        #endif

        irradiance = L0 + normalWorld.x * L1x + normalWorld.y * L1y + normalWorld.z * L1z;
        float regularLumaSH = dot(irradiance, 1);
        irradiance *= lerp(1, lumaSH / regularLumaSH, saturate(regularLumaSH*16));
    #else
        irradiance = L0 + normalWorld.x * L1x + normalWorld.y * L1y + normalWorld.z * L1z;
    #endif

    #if defined(LIGHTMAP_SPECULAR)
    float3 dominantDir = float3(luminance(nL1x), luminance(nL1y), luminance(nL1z));

    o_light.l = dominantDir;
    half directionality = max(0.001, length(o_light.l));
    o_light.l /= directionality;

    o_light.colorIntensity = float4(irradiance * directionality, 1.0);
    o_light.attenuation = directionality;
    o_light.NoL = saturate(dot(normalWorld, o_light.l));
    #endif

    return irradiance;
}

float3 DecodeSHLightmapVertex(half3 L0, half3 ambientSH[3], half3 normalWorld, out Light o_light)
{
    float3 irradiance;
    o_light = (Light)0;

    float3 nL1x = ambientSH[0];
    float3 nL1y = ambientSH[1];
    float3 nL1z = ambientSH[2];

    nL1x = nL1x * 2 - 1;
    nL1y = nL1y * 2 - 1;
    nL1z = nL1z * 2 - 1;
    float3 L1x = nL1x * L0 * 2;
    float3 L1y = nL1y * L0 * 2;
    float3 L1z = nL1z * L0 * 2;

    #ifdef BAKERY_SHNONLINEAR
        float lumaL0 = dot(L0, float(1));
        float lumaL1x = dot(L1x, float(1));
        float lumaL1y = dot(L1y, float(1));
        float lumaL1z = dot(L1z, float(1));
        float lumaSH = shEvaluateDiffuseL1Geomerics_local(lumaL0, float3(lumaL1x, lumaL1y, lumaL1z), normalWorld);

        #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_ZH3)
            lumaSH = SHEvalLinearL0L1_ZH3Hallucinate(float4(lumaL0, lumaL1y, lumaL1z, lumaL1x), normalWorld);
        #endif

        irradiance = L0 + normalWorld.x * L1x + normalWorld.y * L1y + normalWorld.z * L1z;
        float regularLumaSH = dot(irradiance, 1);
        irradiance *= lerp(1, lumaSH / regularLumaSH, saturate(regularLumaSH*16));
    #else
        irradiance = L0 + normalWorld.x * L1x + normalWorld.y * L1y + normalWorld.z * L1z;
    #endif

    #if defined(LIGHTMAP_SPECULAR)
    float3 dominantDir = float3(luminance(nL1x), luminance(nL1y), luminance(nL1z));

    o_light.l = dominantDir;
    half directionality = max(0.001, length(o_light.l));
    o_light.l /= directionality;

    o_light.colorIntensity = float4(irradiance * directionality, 1.0);
    o_light.attenuation = directionality;
    o_light.NoL = saturate(dot(normalWorld, o_light.l));
    #endif

    return irradiance;
}
#endif

#if defined(_BAKERY_MONOSH)
float3 DecodeMonoSHLightmap(half3 L0, half3 dominantDir, half3 normalWorld, out Light o_light, const bool remapDir = true)
{
    o_light = (Light)0;

    float3 nL1 = remapDir? dominantDir * 2 - 1 : dominantDir;
    float3 L1x = nL1.x * L0 * 2;
    float3 L1y = nL1.y * L0 * 2;
    float3 L1z = nL1.z * L0 * 2;

    float3 sh;

    #if BAKERY_SHNONLINEAR
        float lumaL0 = dot(L0, 1);
        float lumaL1x = dot(L1x, 1);
        float lumaL1y = dot(L1y, 1);
        float lumaL1z = dot(L1z, 1);
        float lumaSH = shEvaluateDiffuseL1Geomerics_local(lumaL0, float3(lumaL1x, lumaL1y, lumaL1z), normalWorld);

        #if (SPHERICAL_HARMONICS == SPHERICAL_HARMONICS_ZH3)
            lumaSH = SHEvalLinearL0L1_ZH3Hallucinate(float4(lumaL0, lumaL1y, lumaL1z, lumaL1x), normalWorld);
        #endif

        sh = L0 + normalWorld.x * L1x + normalWorld.y * L1y + normalWorld.z * L1z;
        float regularLumaSH = dot(sh, 1);

        sh *= lerp(1, lumaSH / regularLumaSH, saturate(regularLumaSH*16));
    #else
        sh = L0 + normalWorld.x * L1x + normalWorld.y * L1y + normalWorld.z * L1z;
    #endif

    #if defined(LIGHTMAP_SPECULAR)
    dominantDir = nL1;

    o_light.l = dominantDir;
    half directionality = max(0.001, length(o_light.l));
    o_light.l /= directionality;

    o_light.colorIntensity = float4(L0 * directionality, 1.0);
    o_light.attenuation = directionality;
    o_light.NoL = saturate(dot(normalWorld, o_light.l));
    #endif

    return sh;
}
#endif

float IrradianceToExposureOcclusion(float3 irradiance)
{
    return saturate(length(irradiance + FLT_EPS) * getExposureOcclusionBias());
}

float3 PrefilteredDFG_LUT(float lod, float NoV) {
	return UNITY_SAMPLE_TEX2D(_DFG, float2(NoV, lod));
}

float3 specularDFG(const float3 dfg, const float3 f0) {
	return lerp(dfg.xxx, dfg.yyy, f0);
}

float D_GGX(float roughness, float NoH, const float3 h) {
	// Walter et al. 2007, "Microfacet Models for Refraction through Rough Surfaces"

	// In mediump, there are two problems computing 1.0 - NoH^2
	// 1) 1.0 - NoH^2 suffers floating point cancellation when NoH^2 is close to 1 (highlights)
	// 2) NoH doesn't have enough precision around 1.0
	// Both problem can be fixed by computing 1-NoH^2 in highp and providing NoH in highp as well

	// However, we can do better using Lagrange's identity:
	//      ||a x b||^2 = ||a||^2 ||b||^2 - (a . b)^2
	// since N and H are unit vectors: ||N x H||^2 = 1.0 - NoH^2
	// This computes 1.0 - NoH^2 directly (which is close to zero in the highlights and has
	// enough precision).
	// Overall this yields better performance, keeping all computations in mediump
	// Not available without reworking to pass NxH to the function
	float oneMinusNoHSquared = 1.0 - NoH * NoH;
	float a = NoH * roughness;
	float k = roughness / (oneMinusNoHSquared + a * a);
	float d = k * k * (1.0 / PI);
	return d;
}

// t = tangent vector, b = bitangent vector
float D_GGX_Anisotropic(float at, float ab, float NoH,
        const float3 h,
        const float3 t, const float3 b) {
    float ToH = dot(t, h);
    float BoH = dot(b, h);
    float a2 = at * ab;
    float3 v = float3(ab * ToH, at * BoH, a2 * NoH);
    float v2 = dot(v, v);
    float w2 = a2 / v2;
    return a2 * w2 * w2 * (1.0 / PI);
}

float F_Schlick(float f0, float VoH) {
	return f0 + (1.0 - f0) * pow5(1.0 - VoH);
}

float F_Schlick(float f0, float f90, float VoH) {
    // Schlick 1994, "An Inexpensive BRDF Model for Physically-Based Rendering"
    return f0 + (f90 - f0) * pow5(1.0 - VoH);
}

float3 F_Schlick(const float3 f0, float VoH) {
    float f = pow5(1.0 - VoH);
    return f + f0 * (1.0 - f);
}

float3 F_Schlick(const float3 f0, float f90, float VoH) {
    // Schlick 1994, "An Inexpensive BRDF Model for Physically-Based Rendering"
    return f0 + (f90 - f0) * pow5(1.0 - VoH);
}

float Fd_Lambert() {
    return 1.0 / PI;
}

float Fd_Burley(float roughness, float NoV, float NoL, float LoH) {
    // Burley 2012, "Physically-Based Shading at Disney"
    float f90 = 0.5 + 2.0 * roughness * LoH * LoH;
    float lightScatter = F_Schlick(1.0, f90, NoL);
    float viewScatter = F_Schlick(1.0, f90, NoV);
    return lightScatter * viewScatter * (1.0 / PI);
}

float V_SmithGGXCorrelated(float roughness, float NoV, float NoL) {
	// Heitz 2014, "Understanding the Masking-Shadowing Function in Microfacet-Based BRDFs"
	float a2 = roughness * roughness;
	float lambdaV = NoL * sqrt((NoV - a2 * NoV) * NoV + a2);
	float lambdaL = NoV * sqrt((NoL - a2 * NoL) * NoL + a2);
	float v = 0.5 / (lambdaV + lambdaL);
	return v;
}

float V_SmithGGXCorrelated_Fast(float roughness, float NoV, float NoL) {
    // Hammon 2017, "PBR Diffuse Lighting for GGX+Smith Microsurfaces"
    float v = 0.5 / lerp(2.0 * NoL * NoV, NoL + NoV, roughness);
    return v;
}

float V_SmithGGXCorrelated_Anisotropic(float at, float ab, float ToV, float BoV,
        float ToL, float BoL, float NoV, float NoL) {
    float lambdaV = NoL * length(float3(at * ToV, ab * BoV, NoV));
    float lambdaL = NoV * length(float3(at * ToL, ab * BoL, NoL));
    float v = 0.5 / (lambdaV + lambdaL);
    return saturate(v);
}

float perceptualRoughnessToRoughness(float perceptualRoughness) {
    return perceptualRoughness * perceptualRoughness;
}

float roughnessToPerceptualRoughness(float roughness) {
    return sqrt(roughness);
}

float normalFiltering(float perceptualRoughness, const float3 worldNormal) {
    // Kaplanyan 2016, "Stable specular highlights"
    // Tokuyoshi 2017, "Error Reduction and Simplification for Shading Anti-Aliasing"
    // Tokuyoshi and Kaplanyan 2019, "Improved Geometric Specular Antialiasing"

    // This implementation is meant for deferred rendering in the original paper but
    // we use it in forward rendering as well (as discussed in Tokuyoshi and Kaplanyan
    // 2019). The main reason is that the forward version requires an expensive transform
    // of the half vector by the tangent frame for every light. This is therefore an
    // approximation but it works well enough for our needs and provides an improvement
    // over our original implementation based on Vlachos 2015, "Advanced VR Rendering".

    float3 du = ddx(worldNormal);
    float3 dv = ddy(worldNormal);

    float variance = _specularAntiAliasingVariance * (dot(du, du) + dot(dv, dv));

    float roughness = perceptualRoughnessToRoughness(perceptualRoughness);
    float kernelRoughness = min(2.0 * variance, _specularAntiAliasingThreshold);
    float squareRoughness = saturate(roughness * roughness + kernelRoughness);

    return roughnessToPerceptualRoughness(sqrt(squareRoughness));
}

float3 energyCompensation(float3 dfg, float3 f0)
{
  // Energy compensation for multiple scattering in a microfacet model
  // See "Multiple-Scattering Microfacet BSDFs with the Smith Model"
  return 1.0 + f0 * (1.0 / dfg.yyy - 1.0);
}

half3 Unity_GlossyEnvironment_local (UNITY_ARGS_TEXCUBE(tex), half4 hdr, Unity_GlossyEnvironmentData glossIn)
{
	half perceptualRoughness = glossIn.roughness /* perceptualRoughness */ ;

	// Workaround for issue where objects are blurrier than they should be
	// due to specular AA.
	float roughnessAdjustment = 1-perceptualRoughness;
	roughnessAdjustment = MIN_PERCEPTUAL_ROUGHNESS * roughnessAdjustment * roughnessAdjustment;
	perceptualRoughness = perceptualRoughness - roughnessAdjustment;

	// Unity derivation
	perceptualRoughness = perceptualRoughness*(1.7 - 0.7 * perceptualRoughness);
	// Filament derivation
	// perceptualRoughness = perceptualRoughness * (2.0 - perceptualRoughness);
	half mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);
	half3 R = glossIn.reflUVW;
	half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(tex, R, mip);

	return DecodeHDR(rgbm, hdr);
}

inline half3 UnityGI_prefilteredRadiance(const UnityGIInput data,
    const float perceptualRoughness, const float3 r) {
  half3 specular;

  Unity_GlossyEnvironmentData glossIn = (Unity_GlossyEnvironmentData)0;
  glossIn.roughness = perceptualRoughness;
  glossIn.reflUVW = r;

#ifdef UNITY_SPECCUBE_BOX_PROJECTION
  // we will tweak reflUVW in glossIn directly (as we pass it to Unity_GlossyEnvironment twice for probe0 and pr            obe1), so keep original to pass into BoxProjectedCubemapDirection
	half3 originalReflUVW = glossIn.reflUVW;
	glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW,
			data.worldPos, data.probePosition[0], data.boxMin[0], data.boxMax[0]);
#endif

#ifdef _GLOSSYREFLECTIONS_OFF
    specular = unity_IndirectSpecColor.rgb;
#else
  half3 env0 = Unity_GlossyEnvironment_local (UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], glossIn);
#ifdef UNITY_SPECCUBE_BLENDING
  const float kBlendFactor = 0.99999;
  float blendLerp = data.boxMin[0].w;
  UNITY_BRANCH
    if (blendLerp < kBlendFactor)
    {
#ifdef UNITY_SPECCUBE_BOX_PROJECTION
      glossIn.reflUVW = BoxProjectedCubemapDirection (originalReflUVW, data.worldPos, data.probePosition                        [1], data.boxMin[1], data.boxMax[1]);
#endif  // UNITY_SPECCUBE_BOX_PROJECTION

      half3 env1 = Unity_GlossyEnvironment_local (UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1,unity_SpecCube0                    ), data.probeHDR[1], glossIn);
      specular = lerp(env1, env0, blendLerp);                                                                           }
    else
    {
      specular = env0;
    }
#else
  specular = env0;
#endif  // UNITY_SPECCUBE_BLENDING
#endif  // _GLOSSYREFLECTIONS_OFF

  return specular;
}

// R dither mask
float noiseR2(float2 pixel) {
  const float a1 = 0.75487766624669276;
  const float a2 = 0.569840290998;
  return frac(a1 * float(pixel.x) + a2 * float(pixel.y));
}

// Return light probes or lightmap.
// Port of UnityGI_Irradiance without ShadingParams
float3 UnityGI_Irradiance(
    float3 worldNormal, 
    float3 worldPos,
    float4 lightmapUV,
    float3 ambient,
    float attenuation,
    float3 tangentNormal,
    float3x3 tangentToWorld,
    #if defined(USING_BAKERY_VERTEXLMSH)
        float3 ambientSH[3],
    #elif defined(USING_BAKERY_VERTEXLMDIR)
        float3 ambientDir,
    #endif
    out float occlusion, 
    out Light derivedLight)
{
    float3 irradiance = ambient;
    float3 irradianceForAO; 
    occlusion = 1.0;
    derivedLight = (Light)0;

    #if UNITY_SHOULD_SAMPLE_SH
        irradiance += Irradiance_SphericalHarmonicsUnity(worldNormal, ambient, worldPos, derivedLight);
    #endif

    irradianceForAO = irradiance;

    // Should be stripped out at compile time if vertex LM mode is disabled.
    if (getIsBakeryVertexMode() == false)
    {
    #if defined(LIGHTMAP_ON)
        // Baked lightmaps
        half4 bakedColorTex = SampleLightmapBicubic(lightmapUV.xy);
        half3 bakedColor = DecodeLightmap(bakedColorTex);

        #ifdef DIRLIGHTMAP_COMBINED
            fixed4 bakedDirTex = SampleLightmapDirBicubic(lightmapUV.xy);

            // Bakery's MonoSH mode replaces the regular directional lightmap
            #if defined(_BAKERY_MONOSH)
                irradiance = DecodeMonoSHLightmap(bakedColor, bakedDirTex, worldNormal, derivedLight);

                irradianceForAO = irradiance;

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                #endif
            #else
                irradiance = DecodeDirectionalLightmap(bakedColor, bakedDirTex, worldNormal);

                irradianceForAO = irradiance;

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                #endif

                #if defined(LIGHTMAP_SPECULAR) 
                    irradiance = DecodeDirectionalLightmapSpecular(bakedColor, bakedDirTex, worldNormal, false, 0, derivedLight);
                #endif
            #endif

        #else // not directional lightmap

            #if defined(USING_BAKERY)
                #if defined(_BAKERY_RNM)
                // bakery rnm mode
                irradiance = DecodeRNMLightmap(0, lightmapUV.xy, tangentNormal, tangentToWorld, derivedLight);
                #endif

                #if defined(_BAKERY_SH)
                // bakery sh mode
                irradiance = DecodeSHLightmap(bakedColor, lightmapUV.xy, worldNormal, derivedLight);
                #endif

                irradianceForAO = irradiance;

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                #endif

            #else

                irradiance += bakedColor;

                irradianceForAO = irradiance;

                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                #endif
            #endif

        #endif
    #endif
    }

    #if defined(USING_BAKERY_VERTEXLM)
    if (getIsBakeryVertexMode() == true)
    {
        // Lightmap colour is already stored in ambient.
        // If directionality is on, then ambientDir contains directionality.
        // If SH is on, then ambientSH[3] contains the SH data.
        half4 bakedColorTex = float4(ambient, 1.0);

        #if defined(USING_BAKERY_VERTEXLMSH)
            irradiance = DecodeSHLightmapVertex(ambient, ambientSH, worldNormal, derivedLight);
            irradianceForAO = irradiance;
            #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
            #endif
        #else
            #if defined(USING_BAKERY_VERTEXLMDIR)
                #if defined(_BAKERY_MONOSH)
                    irradiance = DecodeMonoSHLightmap(ambient, ambientDir, worldNormal, derivedLight, false);
                    irradianceForAO = irradiance;
                    #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                        irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                    #endif
                #else
                    irradiance = DecodeDirectionalLightmap(ambient, ambientDir, worldNormal);
                    irradianceForAO = irradiance;
                    #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                        irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                    #endif
                    #if defined(LIGHTMAP_SPECULAR) 
                        irradiance = DecodeDirectionalLightmapSpecular(ambient, ambientDir, worldNormal, false, 0, derivedLight);
                    #endif
                #endif 
            #else
                // No directionality, just light colour.
                // Irradiance and IrradianceForAO already contain the irradiance, so just handle subtractive lighting. 
                #if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN)
                    irradiance = SubtractMainLightWithRealtimeAttenuationFromLightmap(irradiance, attenuation, bakedColorTex, worldNormal);
                #endif
            #endif
        #endif 
    }
    #endif

    #if defined(DYNAMICLIGHTMAP_ON)
        // Dynamic lightmaps
        fixed4 realtimeColorTex = SampleDynamicLightmapBicubic(lightmapUV.zw);
        half3 realtimeColor = DecodeRealtimeLightmap(realtimeColorTex);

        irradianceForAO += realtimeColor;

        #ifdef DIRLIGHTMAP_COMBINED
            half4 realtimeDirTex = SampleDynamicLightmapDirBicubic(lightmapUV.zw);
            irradiance += DecodeDirectionalLightmap(realtimeColor, realtimeDirTex, worldNormal);
        #else
            irradiance += realtimeColor;
        #endif
    #endif
    
    // VRC Light Volumes also have an additive component which can be added over lightmapping.
    #if defined(_VRCLV) && !UNITY_SHOULD_SAMPLE_SH
        Light volumeLight = (Light)0;
        irradiance += Irradiance_SampleVRCLightVolumeAdditive(worldNormal, worldPos, volumeLight);

        // Merge lights, weighing each light's contribution by their intensity
        float derivedLum = luminance(derivedLight.colorIntensity.rgb);
        float volumeLum = luminance(volumeLight.colorIntensity.rgb);
        float totalIntensity = derivedLum + volumeLum + FLT_EPS;
        float derivedWeight = derivedLum / totalIntensity;
        float volumeWeight = volumeLum / totalIntensity;

        derivedLight.l = normalize(derivedLight.l * derivedWeight + volumeLight.l * volumeWeight);
        derivedLight.colorIntensity = derivedLight.colorIntensity * derivedWeight + volumeLight.colorIntensity * volumeWeight;
        derivedLight.attenuation = derivedLight.attenuation * derivedWeight + volumeLight.attenuation * volumeWeight;
        derivedLight.NoL = derivedLight.NoL * derivedWeight + volumeLight.NoL * volumeWeight;
    #endif

    occlusion = IrradianceToExposureOcclusion(irradianceForAO);

    return irradiance;
}

// Simplified integration function using existing Unity/Bakery functions
float3 BakeryGI_Irradiance(
    float3 worldNormal,
    float3 worldPos,
    float4 lightmapUV,  // xy = uv0, zw = uv1
    float3 ambient,
    float attenuation,
    float3 tangentNormal,
    float3x3 tangentToWorld,
    out float occlusion,
    out Light derivedLight)
{
    // The existing UnityGI_Irradiance function already handles all Bakery modes correctly,
    // including MonoSH via the DecodeMonoSHLightmap function that's already defined above
    float3 ambientSH[3] = {float3(0,0,0), float3(0,0,0), float3(0,0,0)};
    float3 ambientDir = float3(0,0,0);
    
    return UnityGI_Irradiance(
        worldNormal,
        worldPos,
        lightmapUV,
        ambient,
        attenuation,
        tangentNormal,
        tangentToWorld,
        #if defined(USING_BAKERY_VERTEXLMSH)
            ambientSH,
        #elif defined(USING_BAKERY_VERTEXLMDIR)
            ambientDir,
        #endif
        occlusion,
        derivedLight
    );
}


#endif // __FILAMENTED_INC
