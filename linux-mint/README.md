# Instalar Linux Mint desde 0

## Instalar

- Descargar el ISO.
- Crear una unidad USB booteable con el ISO. [ Ventoy ](https://www.ventoy.net/en/index.html)
- Configurar el BIOS para arrancar desde la unidad USB.
- Iniciar el instalador.
- Seguir los pasos del instalador.


## Drivers y actualización
- Actualizar sistema
```bash
sudo apt update && sudo apt upgrade
```

- Instalar codecs de audio y vídeo
```bash
sudo apt install libavcodec-extra ubuntu-restricted-extras
```

- Instalar controladores privativos
```bash
sudo apt install nvidia-driver
```

### Drivers de audio (Situacional)
Si los drivers de vídeo no funcionan bien poner pulseaudio:
```bash
sudo apt purge pipewire-alsa pipewire-pulse wireplumber
sudo apt install pulseaudio pulseaudio-utils
systemctl --user enable pulseaudio
systemctl --user start pulseaudio
```
## Aplicaciones
### Software general
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

### Instalar antigravity
```bash

# Descomprimir y mover antigravity a /opt
sudo tar -xzf Antigravity-*.tar.gz -C /opt/

# Renombrar carpeta
sudo mv /opt/Antigravity\ IDE/ /opt/Antigravity_IDE

# Crear archivo .desktop
cat << 'EOF' > ~/.local/share/applications/antigravity-ide.desktop
[Desktop Entry]
Name=Antigravity IDE
Comment=Antigravity IDE - Entorno de desarrollo
GenericName=IDE
Exec="/opt/Antigravity_IDE/antigravity-ide" %F
Icon=/opt/Antigravity_IDE/resources/app/resources/linux/code.png
Type=Application
Terminal=false
StartupNotify=true
StartupWMClass=Antigravity
Categories=Development;IDE;TextEditor;
MimeType=application/x-antigravity-workspace;
EOF

# Dar permisos de ejecución
chmod +x ~/.local/share/applications/antigravity-ide.desktop

# Copiar icono
cp /opt/Antigravity_IDE/resources/app/resources/linux/code.png ~/.local/share/icons/
```

### Copiar launchers a .local/share/applications
```bash
# Copiar aplicaciones
cp /usr/share/applications/* ~/.local/share/applications/
cp /var/lib/flatpak/exports/share/applications/*.desktop ~/.local/share/applications/

# Dar permisos de ejecución
chmod +x ~/.local/share/applications/*.desktop
```

## Configurar entorno
### Montar disco duro externo.
```bash
sudo mkdir -p /mnt/ddrive
#Obtener id de los discos
sudo blkid
# Editar /etc/fstab:
sudo bash -c "cat >> /etc/fstab" << 'EOF'

# Montar discos secundarios
UUID=f5dccb35-07d3-4128-8c3c-ef986092bb31  /mnt/ddrive  ext4  defaults  0  2
UUID=12C89A82C89A63AF /mnt/ddrive2 auto defaults,windows_names,uid=1000,gid=1000 0 0
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

Nota: Si una aplicación cambia de ID
Por ejemplo Antigravity, hay que editar el archivo .desktop y cambiar el ID.

1. Obtener el ID con `xprop WM_CLASS`.
2. Editar el archivo .desktop que se encuentra en `~/.local/share/applications/` y cambiar o agregar `StartupWMClass=ID`.

### Mostrar solo dos carpetas en la terminal
```bash
cat >> ~/.bashrc << 'EOF'

PROMPT_DIRTRIM=2

EOF
```

### Paquete de íconos
```bash
sudo tar -xzf utils/00Okuttama.tar.gz -C /usr/share/icons/
```


### Configurar Cinnamenu-metro
[Cinnamenu-metro](https://github.com/cpxcristian/Cinnamenu-metro)
1. Instalar la applet.
2. Copiar aplicacionnes (si no están en ~/.local/share/applications/).
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

### Crear usuario de red de samba
```bash
sudo usermod -aG sambashare $USER
sudo smbpasswd -a $USER
sudo smbpasswd -e $USER
```

## Entorno de trabajo
### Instalar Entorno Apache
```bash
# Ejecutar script para instalar
bash scripts/apache.sh

# Cambiar directorio de trabajo. Puede recibir de parámetro la nueva ruta. Valor por defecto: /mnt/ddrive/html
bash scripts/change_workdir.sh
```

### Instalar PHP version manager

```bash
# Ejecutar script para instalar la librería y agregar las ufnciones install-php-version y switch-php a .bashrc
bash scripts/install_pvm.sh

#Para instalar una versión de PHP.
install-php-version 5.6
install-php-version 7.4

#Para cambiar de versión de PHP.
switch-php 5.6
switch-php 7.4
```

### Instalar Git
```bash
sudo apt install git -y

#Configurar name, email
git config --global user.name "[NAME]"
git config --global user.email "[EMAIL_ADDRESS]"
```

### Instalar NodeJs y npm
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
nvm install --lts
```