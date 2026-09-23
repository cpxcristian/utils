#!/bin/sh

TARGET_DIR="/home/cristian/.config/fastfetch"
SOURCE_DIR="$TARGET_DIR/FastCat-main/Large-Themes"
# 1. Limpiar archivos anteriores
rm -f $TARGET_DIR/config.jsonc $TARGET_DIR/ascii.txt $TARGET_DIR/anchor.txt

# 2. Definir la ruta base de los temas


randomTheme=$(ls "$SOURCE_DIR" | sort -R | head -n 1)

# 4. Copiar los archivos del tema elegido a la carpeta destino
cp "$SOURCE_DIR/$randomTheme/fastfetch/"* /home/cristian/.config/fastfetch/

fastfetch

