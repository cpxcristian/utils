#!/usr/bin/env python3

"""
Script: set_icon.py
Descripción: Coloca dentro de los directorios deseados un archivo llamado "folder.jpg", en un directorio superior ejecuta este script y listo.
Autor: cpxcristian
Fecha: 2026-06-29
"""

import os
import subprocess
from pathlib import Path

def apply_icons():
    current_route = Path.cwd()
    print(f"Buscando carpetas en: {current_route}\n")

    # Extensiones de imagen soportadas en orden de preferencia
    extensions = ['.png', '.jpg', '.jpeg']

    # Recorre solo los elementos del primer nivel del directorio actual
    for element in current_route.iterdir():
        if element.is_dir():
            dir_name = element.name
            found_icon = None

            # Busca si existe folder.png, folder.jpg o folder.jpeg
            for ext in extensions:
                ruta_posible_icono = element / f"folder{ext}"
                if ruta_posible_icono.exists() and ruta_posible_icono.is_file():
                    found_icon = ruta_posible_icono
                    break  # Detiene la búsqueda si encuentra el formato preferido

            if found_icon:
                # Convierte las rutas a formato absoluto y texto
                ruta_carpeta_str = str(element.resolve())
                ruta_icono_uri = found_icon.resolve().as_uri()

                # Construye el comando GIO
                comando = [
                    "gio", "set", "-t", "string", 
                    ruta_carpeta_str, 
                    "metadata::custom-icon", 
                    ruta_icono_uri
                ]

                try:
                    # Ejecuta el comando en el sistema
                    subprocess.run(comando, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                    print(f"✓ Ícono aplicado a: {dir_name} ({found_icon.name})")
                except subprocess.CalledProcessError:
                    print(f"✗ Error al aplicar ícono en: {dir_name}")
            else:
                print(f"• Sin archivo de ícono: {dir_name}")

    print("\nProceso terminado. Si no ves los cambios, recarga con F5 o reinicia Nemo.")

if __name__ == "__main__":
    apply_icons()
