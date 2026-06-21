# Instalar Linux Mint desde 0

## Instalar

- Descargar el ISO.
- Crear una unidad USB booteable con el ISO. [ Ventoy ](https://www.ventoy.net/en/index.html)
- Configurar el BIOS para arrancar desde la unidad USB.
- Iniciar el instalador.
- Seguir los pasos del instalador.


## Drivers y actualización
- Actualizar sistema `sudo apt update && sudo apt upgrade`
- Instalar codecs de audio y vídeo `sudo apt install libavcodec-extra ubuntu-restricted-extras`
- Instalar controladores privativos `sudo apt install nvidia-driver`

### Situacional
Si los drivers de vídeo no funcionan bien poner pulseaudio:
```bash
sudo apt purge pipewire-alsa pipewire-pulse wireplumber
sudo apt install pulseaudio pulseaudio-utils
systemctl --user enable pulseaudio
systemctl --user start pulseaudio
```

## Software para trabajo
```bash
# Terminal
sudo apt install tilix -y

# Sublime text
sudo apt install sublime-text

# Antigravity
sudo tar -xzf Antigravity-*.tar.gz -C /opt/

# Rustdesk flatpak
flatpak install flathub com.rustdesk.Rustdesk

# Discord flatpak
flatpak install flathub com.discordapp.Discord

# Onlyoffice flatpak
flatpak install flathub org.onlyoffice.desktopeditors
```

## Configurar entorno
### Montar disco duro externo.
```bash
sudo mkdir -p /mnt/ddrive
#Obtener id de los discos
sudo blkid
# Editar /etc/fstab:
sudo bash -c "cat >> /etc/fstab" << 'EOF'

# Montaje automático del disco secundario
UUID=3A7A50027A4FBA01 /mnt/ddrive ntfs-3g defaults,uid=1000,gid=1000,dmask=022,fmask=133 0 0
EOF

sudo mount -a
```

### Cambiar user-dirs
```bash
sudo sed -i "s|/home/cristian|/mnt/ddrive|g" ~/.config/user-dirs.dirs
# El resultado debe ser:
XDG_DESKTOP_DIR="/mnt/ddrive/Desktop"
XDG_DOWNLOAD_DIR="/mnt/ddrive/Downloads"
XDG_DOCUMENTS_DIR="/mnt/ddrive/Documents"
XDG_MUSIC_DIR="/mnt/ddrive/Music"
XDG_PICTURES_DIR="/mnt/ddrive/Pictures"
XDG_VIDEOS_DIR="/mnt/ddrive/Videos"
```
Además, en nemo ir a Bookmarks / Edit Bookmarks y cambiar las rutas a la nueva ubicación.

### Si una aplicación cambia de ID
Por ejemplo Antigravity, hay que editar el archivo .desktop y cambiar el ID.

1. Obtener el ID con `xprop WM_CLASS`.
2. Editar el archivo .desktop que se encuentra en `~/.local/share/applications/` y cambiar o agregar `StartupWMClass=ID`.


### Configurar Cinnamenu-metro
[Cinnamenu-metro](https://github.com/cpxcristian/Cinnamenu-metro)
1. Instalar la applet.
2. Copiar aplicacionnes.
```bash
# Copiar aplicaciones
cp /usr/share/applications/* ~/.local/share/applications/

# Dar permisos de ejecución
chmod +x ~/.local/share/applications/*.desktop
```
3. Agregar el applet de cinnamenu al panel y configurar para que inicie en favoritos.
4. Marcar las aplicaciones deseadas como favoritas.
5. Para crear grupos de aplicaciones editar el archivo .desktop y agregar:
```
CinnamenuCategory=MyGroup
CinnamenuPriority=10
```

## Instalar Entorno Apache
```bash
# Ejecutar script para instalar
bash apache.sh

# Cambiar directorio de trabajo. Puede recibir de parámetro la nueva ruta. Valor por defecto: /mnt/ddrive/html
bash change_workdir.sh
```

## Instalar PHP version manager

```bash
# Ejecutar script para instalar la librería y agregar las ufnciones install-php-version y switch-php a .bashrc
bash install_pvm.sh

#Para instalar una versión de PHP.
install-php-version 5.6
install-php-version 7.4

#Para cambiar de versión de PHP.
switch-php 5.6
switch-php 7.4
```