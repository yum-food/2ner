#!/usr/bin/env python3
# /// script
# requires-python = ">=3.9"
# dependencies = [
#     "numpy",
#     "openexr",
# ]
# ///
"""
Generate a DFG LUT (Look-Up Table) for PBR split-sum approximation.

This computes the pre-integrated BRDF for the GGX microfacet model,
storing scale and bias factors for the Fresnel term.

Output: DFG LUT as an EXR file with RG channels (scale, bias).
"""

import numpy as np

try:
    import OpenEXR
    import Imath
    HAS_OPENEXR = True
except ImportError:
    HAS_OPENEXR = False


def generate_hammersley_sequence(n):
    """Pre-compute Hammersley 2D sequence for n samples."""
    i = np.arange(n, dtype=np.uint32)

    # Reverse bits for radical inverse
    v = i.copy()
    v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1)
    v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2)
    v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4)
    v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8)
    v = (v >> 16) | (v << 16)

    e1 = i.astype(np.float32) / n
    e2 = v.astype(np.float64) / 0x100000000

    return e1, e2.astype(np.float32)


def generate_dfg_lut(width=64, height=32, num_samples=512):
    """
    Generate the full DFG LUT (vectorized).

    Compatible with HLSL: float2 dfg_uv = float2(NoV, roughness);
    X axis (U): NdotV (0 to 1)
    Y axis (V): roughness (0 to 1)
    """
    # Pre-compute Hammersley sequence
    e1, e2 = generate_hammersley_sequence(num_samples)
    phi = 2.0 * np.pi * e1
    cos_phi = np.cos(phi)
    sin_phi = np.sin(phi)

    # Create coordinate grids matching HLSL UV layout
    x = np.arange(width, dtype=np.float32)
    y = np.arange(height, dtype=np.float32)
    ndotv_arr = (x + 0.5) / width      # shape: (width,) - U axis
    roughness = (y + 0.5) / height     # shape: (height,) - V axis

    # Pre-compute roughness terms
    m = roughness * roughness
    m2 = m * m                         # shape: (height,)

    lut = np.zeros((height, width, 2), dtype=np.float32)

    for yi, (rough, rough_m2) in enumerate(zip(roughness, m2)):
        # GGX importance sampling - vectorized over samples and NdotV
        # cos_theta shape: (width, num_samples)
        denom = 1.0 + (rough_m2 - 1.0) * e2[np.newaxis, :]
        cos_theta = np.sqrt((1.0 - e2[np.newaxis, :]) / denom)
        sin_theta = np.sqrt(1.0 - cos_theta * cos_theta)

        # Half vector in tangent space
        hx = sin_theta * cos_phi[np.newaxis, :]
        hy = sin_theta * sin_phi[np.newaxis, :]
        hz = cos_theta

        # View vector in tangent space (varies per column)
        ndotv = ndotv_arr[:, np.newaxis]  # shape: (width, 1)
        vx = np.sqrt(1.0 - ndotv * ndotv)
        vz = ndotv

        # V dot H
        vdh = vx * hx + vz * hz

        # Light vector (reflect view around half)
        lx = 2.0 * vdh * hx - vx
        lz = 2.0 * vdh * hz - vz

        ndotl = np.maximum(lz, 0.0)
        ndoth = np.maximum(hz, 0.0)
        vdoth = np.maximum(vdh, 0.0)

        # Visibility function (Smith GGX correlated)
        vis_v = ndotl * np.sqrt(ndotv * (ndotv - ndotv * rough_m2) + rough_m2)
        vis_l = ndotv * np.sqrt(ndotl * (ndotl - ndotl * rough_m2) + rough_m2)
        vis = 0.5 / (vis_v + vis_l + 1e-8)

        # Compute contribution
        ndotl_vis_pdf = ndotl * vis * (4.0 * vdoth / (ndoth + 1e-8))
        fresnel = (1.0 - vdoth) ** 5

        # Mask invalid samples
        mask = ndotl > 0.0
        scale_contrib = np.where(mask, ndotl_vis_pdf * (1.0 - fresnel), 0.0)
        bias_contrib = np.where(mask, ndotl_vis_pdf * fresnel, 0.0)

        # Sum over samples
        scale = np.sum(scale_contrib, axis=1) / num_samples
        bias = np.sum(bias_contrib, axis=1) / num_samples

        # Filament-compatible layout:
        # R = bias (F0-independent term)
        # G = scale + bias (reflectance when F0 = 1)
        # Used as: lerp(dfg.x, dfg.y, f0) = bias + f0 * scale
        lut[yi, :, 0] = bias
        lut[yi, :, 1] = scale + bias

        print(f"\rGenerating DFG LUT: {(yi + 1) / height * 100:.1f}%", end="", flush=True)

    print()
    # Flip vertically so V=0 (top) is high roughness, V=1 (bottom) is low roughness
    return np.flipud(lut)


def save_exr(filename, lut):
    """Save the DFG LUT as an EXR file."""
    if not HAS_OPENEXR:
        raise ImportError("OpenEXR module not available. Install with: pip install OpenEXR")

    height, width = lut.shape[:2]

    header = OpenEXR.Header(width, height)
    header['channels'] = {
        'R': Imath.Channel(Imath.PixelType(Imath.PixelType.FLOAT)),
        'G': Imath.Channel(Imath.PixelType(Imath.PixelType.FLOAT)),
    }

    r_channel = lut[:, :, 0].astype(np.float32).tobytes()
    g_channel = lut[:, :, 1].astype(np.float32).tobytes()

    exr = OpenEXR.OutputFile(filename, header)
    exr.writePixels({'R': r_channel, 'G': g_channel})
    exr.close()


def save_npy(filename, lut):
    """Save the DFG LUT as a numpy file (fallback)."""
    np.save(filename, lut)


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Generate DFG LUT for PBR rendering")
    parser.add_argument("-o", "--output", default="dfg_lut.exr", help="Output filename (default: dfg_lut.exr)")
    parser.add_argument("-W", "--width", type=int, default=64, help="LUT width (NdotV axis, default: 64)")
    parser.add_argument("-H", "--height", type=int, default=32, help="LUT height (roughness axis, default: 32)")
    parser.add_argument("-s", "--samples", type=int, default=512, help="Number of samples per texel (default: 512)")
    args = parser.parse_args()

    print(f"Generating {args.width}x{args.height} DFG LUT with {args.samples} samples per texel...")
    lut = generate_dfg_lut(args.width, args.height, args.samples)

    output = args.output
    if output.endswith(".exr"):
        if HAS_OPENEXR:
            save_exr(output, lut)
            print(f"Saved EXR: {output}")
        else:
            output = output.replace(".exr", ".npy")
            print("Warning: OpenEXR not available. Install with: pip install OpenEXR")
            save_npy(output, lut)
            print(f"Saved NumPy array instead: {output}")
    elif output.endswith(".npy"):
        save_npy(output, lut)
        print(f"Saved NumPy array: {output}")
    else:
        save_exr(output, lut)
        print(f"Saved: {output}")


if __name__ == "__main__":
    main()
