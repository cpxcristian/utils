#!/usr/bin/env python3

"""
Script: video_compress.py
Descripción: Escala (reducir) imágenes. Recibe el parámetro "size" que es el valor máximo que ancho y alto que tendrá la imagen.
Autor: cpxcristian
Fecha: 2026-05-10
"""

import subprocess
import pathlib
import argparse
import os

def main(width, height):
    # Crear la carpeta de salida si no existe para evitar errores
    output_dir = pathlib.Path('output')
    output_dir.mkdir(exist_ok=True)

    # El filtro scale usa :force_original_aspect_ratio para mantener proporciones
    # El valor -1 o -2 en height calcula la altura automáticamente
    scale_filter = f"scale={width}:{width}:force_original_aspect_ratio=decrease,scale=w='if(gt(iw,ih),{width},-2)':h='if(gt(ih,iw),{width},-2)'"
    extensions = {'.png', '.jpg', '.jpeg', '.gif'}

    for file_path in pathlib.Path('.').iterdir():
        if file_path.suffix.lower() not in extensions:
            continue

        output_file = output_dir / f"{file_path.stem}.jpg"
        
        if output_file.exists():
            continue

        print(f"Converting: {file_path.name} to max width {width}...")

        # Eliminamos '-c:a copy' porque las imágenes no tienen audio
        command = [
            'ffmpeg', '-y', '-i', str(file_path),
            '-vf', scale_filter,
            str(output_file)
        ]

        try:
            # capture_output ayuda a que la terminal no se llene de texto innecesario
            subprocess.run(command, check=True, capture_output=True)
            print(f"✓ Finished: {output_file}")
            os.remove(file_path)
            print(f"✅ Éxito: {file_path} eliminado.")
        except subprocess.CalledProcessError as e:
            print(f"✗ Error converting {file_path.name}: {e.stderr.decode()}")

    print("\nAll conversions complete!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Conversor de imágenes con FFmpeg")
    parser.add_argument("--size", type=str, default="2400x2400", help="Formato: ANCHOxALTO")
    args = parser.parse_args()
    
    try:
        width, height = args.size.split('x')
    except ValueError:
        width, height = 2400, 2400

    main(width, height)
