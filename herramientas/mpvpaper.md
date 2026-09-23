# mpvpaper

## Instalación
```bash
# Clone
git clone --single-branch https://github.com/GhostNaN/mpvpaper
# Build
cd mpvpaper
meson setup build --prefix=/usr/local
ninja -C build
# Install
ninja -C build install
```

## Ejecutar
```bash
mpvpaper -n 300 -o "no-audio --loop-playlist --shuffle" ALL <PATH_TO_VIDEOS>
```

### Opciones
- `n`: Número de segundos entre cada cambio de video.
- `o`: Opciones de mpv.
- `ALL`: Todos los monitores.
- `<PATH_TO_VIDEOS>`: Ruta de los videos.

## Crear script que lo ejecute automáticamente
```bash
echo "#!/bin/bash
pkill mpvpaper
mpvpaper -n 300 -o \"no-audio --loop-playlist --shuffle\" ALL <PATH_TO_VIDEOS> & disown" > ~/.local/bin/mpvpaper_start.sh

chmod +x ~/.local/bin/mpvpaper_start.sh
```


