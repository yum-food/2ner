#!/usr/bin/env python3

import os
import argparse
import time
import numpy as np
from multiprocessing import Pool, cpu_count
# pip3 install imageio[freeimage]
import imageio.plugins.freeimage
import imageio.v2 as imageio
from scipy.special import sph_harm_y


def blur_hdr_spherical_harmonic(hdr_path: str, blur_radius_deg: float, output_path: str = None):
    """
    Applies an isotropic Gaussian blur to an HDR environment map using spherical harmonics.
    
    Args:
        hdr_path: Path to the input HDR file
        blur_radius_deg: Blur radius in degrees
        output_path: Optional output path
    """
    total_start = time.time()
    
    if not os.path.exists(hdr_path):
        raise FileNotFoundError(f"File not found: {hdr_path}")
    
    # Load HDR
    print("Loading HDR image...")
    start = time.time()
    equirect_img = load_hdr(hdr_path)
    print(f"  Loading took: {time.time() - start:.2f}s")
    
    h, w, _ = equirect_img.shape
    print(f"  Image size: {w}x{h}")
    print(f"  Value range: min={equirect_img.min():.3f}, max={equirect_img.max():.3f}")
    
    # Convert blur radius to radians
    sigma_rad = np.deg2rad(blur_radius_deg)
    
    # Determine SH bandwidth based on blur radius
    # Rule of thumb: l_max ≈ 3/sigma for good frequency capture
    if sigma_rad > 0:
        l_max = max(1, int(np.ceil(3.0 / sigma_rad)))
        # Cap at reasonable value to avoid excessive computation
        l_max = min(l_max, 50)
    else:
        l_max = 50  # No blur, use higher bandwidth
    
    print(f"\nUsing spherical harmonic bandwidth: L_max = {l_max}")
    print(f"Total coefficients per channel: {(l_max + 1)**2}")
    
    # Project to spherical harmonics
    print("\nProjecting to spherical harmonics...")
    start = time.time()
    sh_coeffs = project_to_sh(equirect_img, l_max)
    print(f"  Projection took: {time.time() - start:.2f}s")
    
    # Apply Gaussian filter in SH domain
    if sigma_rad > 0:
        print(f"\nApplying Gaussian blur (σ = {blur_radius_deg}°)...")
        start = time.time()
        sh_coeffs = apply_sh_gaussian_filter(sh_coeffs, sigma_rad)
        print(f"  Filtering took: {time.time() - start:.2f}s")
    else:
        print("\nSkipping blur (radius = 0)")
    
    # Reconstruct from spherical harmonics
    print("\nReconstructing from spherical harmonics...")
    start = time.time()
    blurred_img = reconstruct_from_sh(sh_coeffs, w, h)
    print(f"  Reconstruction took: {time.time() - start:.2f}s")
    
    print(f"  Output value range: min={blurred_img.min():.3f}, max={blurred_img.max():.3f}")
    
    # Save output
    if output_path is None:
        base_name = os.path.splitext(hdr_path)[0]
        output_path = f"{base_name}_blurred_{int(blur_radius_deg)}deg.hdr"
    
    print(f"\nSaving to: {output_path}")
    start = time.time()
    save_hdr(output_path, blurred_img)
    print(f"  Saving took: {time.time() - start:.2f}s")
    
    print(f"\nTotal time: {time.time() - total_start:.2f}s")
    print("Done.")


def load_hdr(path):
    """Load HDR image with proper float support."""
    try:
        # Try FreeImage plugin first
        from imageio.plugins import freeimage
        img = freeimage.read(path)
    except:
        try:
            # Try standard imageio
            img = imageio.imread(path, format='HDR')
        except:
            img = imageio.imread(path)
    
    # Ensure float32
    if img.dtype != np.float32:
        img = img.astype(np.float32)
        if img.max() > 1.0:
            img /= 255.0
    
    return img


def save_hdr(path, img):
    """Save HDR image."""
    img = np.clip(img, 0, None).astype(np.float32)
    
    try:
        if path.lower().endswith('.hdr'):
            imageio.imwrite(path, img, format='HDR')
        else:
            imageio.imwrite(path, img)
    except Exception as e:
        # Fallback
        imageio.imwrite(path, img)


def get_sh_index(l, m):
    """Convert (l,m) to linear index for SH coefficient storage."""
    return l * (l + 1) + m


def eval_sh(l, m, theta, phi):
    """
    Evaluate real spherical harmonic Y_lm(theta, phi).
    theta: azimuth [0, 2π]
    phi: inclination from north pole [0, π]
    """
    # scipy uses physics convention: sph_harm_y(l, m, polar, azimuth)
    # where polar is angle from z-axis
    if m > 0:
        return np.sqrt(2) * np.real(sph_harm_y(l, m, phi, theta))
    elif m < 0:
        return np.sqrt(2) * np.imag(sph_harm_y(l, -m, phi, theta))
    else:
        return np.real(sph_harm_y(l, 0, phi, theta))


def compute_sh_basis_vectorized(height, width, l_max):
    """
    Pre-compute all spherical harmonic basis functions for all pixels.
    Returns basis_functions[coeff_idx] = Y_lm for all pixels.
    """
    n_coeffs = (l_max + 1) ** 2
    
    # Create coordinate grids
    y_coords, x_coords = np.mgrid[0:height, 0:width]
    
    # Convert to spherical coordinates (using pixel centers)
    phi = np.pi * (y_coords + 0.5) / height         # inclination [0, π]
    theta = 2 * np.pi * (x_coords + 0.5) / width - np.pi   # azimuth [-π, π]
    
    # Pre-allocate basis functions array
    basis_functions = np.zeros((n_coeffs, height, width), dtype=np.float32)
    
    print(f"    Computing {n_coeffs} basis functions for {height}x{width} pixels...")
    
    # Use multiprocessing to compute basis functions in parallel
    n_workers = min(cpu_count(), n_coeffs)
    
    if n_workers > 1 and n_coeffs > 4:  # Only use multiprocessing for larger problems
        print(f"    Using {n_workers} CPU cores...")
        
        # Prepare work chunks
        work_items = []
        for l in range(l_max + 1):
            for m in range(-l, l + 1):
                coeff_idx = get_sh_index(l, m)
                work_items.append((coeff_idx, l, m, theta, phi))
        
        # Process in parallel
        with Pool(n_workers) as pool:
            results = pool.map(compute_single_basis, work_items)
        
        # Collect results
        for coeff_idx, basis in results:
            basis_functions[coeff_idx] = basis
    else:
        # Single-threaded fallback
        for l in range(l_max + 1):
            for m in range(-l, l + 1):
                coeff_idx = get_sh_index(l, m)
                
                if m > 0:
                    basis_functions[coeff_idx] = np.sqrt(2) * np.real(sph_harm_y(l, m, phi, theta))
                elif m < 0:
                    basis_functions[coeff_idx] = np.sqrt(2) * np.imag(sph_harm_y(l, -m, phi, theta))
                else:
                    basis_functions[coeff_idx] = np.real(sph_harm_y(l, 0, phi, theta))
    
    return basis_functions


def compute_single_basis(work_item):
    """Helper function for parallel basis computation."""
    coeff_idx, l, m, theta, phi = work_item
    
    if m > 0:
        basis = np.sqrt(2) * np.real(sph_harm_y(l, m, phi, theta))
    elif m < 0:
        basis = np.sqrt(2) * np.imag(sph_harm_y(l, -m, phi, theta))
    else:
        basis = np.real(sph_harm_y(l, 0, phi, theta))
    
    return coeff_idx, basis.astype(np.float32)


def project_to_sh(img, l_max):
    """Project equirectangular image to spherical harmonic coefficients."""
    h, w, channels = img.shape
    n_coeffs = (l_max + 1) ** 2
    
    print(f"  Pre-computing SH basis functions...")
    start = time.time()
    
    # Pre-compute all basis functions for all pixels
    basis_functions = compute_sh_basis_vectorized(h, w, l_max)
    
    print(f"  Basis computation took: {time.time() - start:.2f}s")
    print(f"  Projecting to coefficients...")
    start = time.time()
    
    # Compute solid angle weights
    y_indices = np.arange(h)
    theta_values = np.pi * (y_indices + 0.5) / h         # polar angle θ
    sin_theta = np.sin(theta_values)                      # always ≥ 0
    d_omega = (2 * np.pi / w) * (np.pi / h)               # Δφ · Δθ
    
    # Broadcast solid-angle per-row to a (h,w) grid
    solid_angles = d_omega * np.outer(sin_theta, np.ones(w))  # Shape: (h, w)
    
    # Vectorized projection using matrix operations
    coeffs = np.zeros((n_coeffs, channels), dtype=np.float64)
    
    # Flatten image and solid angles for easier computation
    img_flat = img.reshape(-1, channels)  # (h*w, channels)
    solid_flat = solid_angles.flatten()   # (h*w,)
    
    # Apply solid angle weighting to image
    weighted_img = img_flat * solid_flat[:, np.newaxis]  # (h*w, channels)
    
    # Flatten all basis functions for matrix multiplication
    basis_flat = basis_functions.reshape(n_coeffs, -1)  # (n_coeffs, h*w)
    
    # Matrix multiplication: coeffs = basis_flat @ weighted_img
    coeffs = basis_flat @ weighted_img  # (n_coeffs, channels)
    
    print(f"  Projection took: {time.time() - start:.2f}s")
    return coeffs


def apply_sh_gaussian_filter(coeffs, sigma_rad):
    """Apply Gaussian filter in spherical harmonic domain."""
    n_coeffs = coeffs.shape[0]
    l_max = int(np.sqrt(n_coeffs)) - 1
    
    filtered_coeffs = coeffs.copy()
    
    for l in range(l_max + 1):
        # Gaussian filter transfer function
        k = np.exp(-0.5 * l * (l + 1) * sigma_rad * sigma_rad)
        
        for m in range(-l, l + 1):
            idx = get_sh_index(l, m)
            filtered_coeffs[idx] *= k
    
    return filtered_coeffs


def reconstruct_from_sh(coeffs, width, height):
    """Reconstruct equirectangular image from spherical harmonic coefficients."""
    n_coeffs, channels = coeffs.shape
    l_max = int(np.sqrt(n_coeffs)) - 1
    
    print(f"  Pre-computing SH basis functions...")
    start = time.time()
    
    # Pre-compute all basis functions
    basis_functions = compute_sh_basis_vectorized(height, width, l_max)
    
    print(f"  Basis computation took: {time.time() - start:.2f}s")
    print(f"  Reconstructing image...")
    start = time.time()
    
    # Vectorized reconstruction using matrix operations
    img = np.zeros((height, width, channels), dtype=np.float32)
    
    # Reshape basis functions for matrix multiplication
    basis_flat = basis_functions.reshape(n_coeffs, -1)  # (n_coeffs, h*w)
    
    # Matrix multiplication: img_flat = coeffs.T @ basis_flat
    img_flat = coeffs.T @ basis_flat  # (channels, h*w)
    
    # Reshape back to image format
    img = img_flat.T.reshape(height, width, channels)  # (h, w, channels)
    
    print(f"  Reconstruction took: {time.time() - start:.2f}s")
    return img


def main():
    parser = argparse.ArgumentParser(
        description="Apply mathematically correct Gaussian blur to HDR panoramas using spherical harmonics",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    
    parser.add_argument(
        "input",
        help="Path to input HDR file"
    )
    
    parser.add_argument(
        "-r", "--radius",
        type=float,
        default=10.0,
        help="Blur radius in degrees"
    )
    
    parser.add_argument(
        "-o", "--output",
        help="Output file path (default: input_blurred_{radius}deg.hdr)"
    )
    
    args = parser.parse_args()
    
    try:
        blur_hdr_spherical_harmonic(args.input, args.radius, args.output)
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0


if __name__ == '__main__':
    # Ensure multiprocessing works on Windows
    from multiprocessing import freeze_support
    freeze_support()
    exit(main())
