#!/usr/bin/env python3

"""
Script: video_compress.py
Descripción: Compresor de vídeos con formato .mp4 optimizado para animación.
Autor: cpxcristian
Fecha: 2026-05-10
"""

import subprocess
import pathlib
import argparse
import os.path

def get_profile(profile_name, input_file, output_file, scale_filter):
    if profile_name == 'h265':
        return [
            'ffmpeg', '-i', str(input_file),
            '-vf', scale_filter,
            '-c:v', 'libx265',
            '-crf', '28',
            '-preset', 'slow',
            '-tune', 'animation',
            '-pix_fmt', 'yuv420p10le',
            '-c:a', 'copy',
            str(output_file)
        ]
    elif profile_name == 'av1':
        return [
            'ffmpeg', '-y', '-i', str(input_file),
            '-vf', scale_filter,
            '-c:v', 'libsvtav1',
            '-crf', '26',
            '-preset', '4',
            '-pix_fmt', 'yuv420p10le',
            '-svtav1-params', 'tune=0',
            '-c:a', 'copy',
            str(output_file)
        ]

def main(width, height, profile):
    output_dir = pathlib.Path('output')
    output_dir.mkdir(exist_ok=True)
    scale_filter = f"scale='min({width},iw)':-2,setsar=1:1"

    for file_path in pathlib.Path('.').glob('*.mp4'):
        output_file = output_dir / f"{file_path.stem}.mp4"
        
        if file_path.stem.endswith('_new'):
            continue
        
        if os.path.exists(output_file):
            continue

        print(f"Converting: {file_path.name} to {width}x{height}...")

        command = get_profile(profile, file_path, output_file, scale_filter)

        try:
            subprocess.run(command, check=True)
            print(f"✓ Finished: {output_file}")
            
            os.remove(file_path)
            print(f"✅ Éxito: {file_path} eliminado.")
        except subprocess.CalledProcessError as e:
            print(f"✗ Error converting {file_path.name}: {e}")

    print("\nAll conversions complete!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Conversor de video MP4 con FFmpeg")
    parser.add_argument("--size", type=str, default="1280x720", help="Default: 1280x720")
    parser.add_argument("--profile", type=str, default="av1", help="Profile: h265 or av1")
    args = parser.parse_args()
    size = args.size
    profile = args.profile
    width = size.split('x')[0] or 1280
    height = size.split('x')[1] or 720

    main(width, height, profile)
