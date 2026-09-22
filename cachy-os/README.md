# Instalar Cachy-OS desde 0

## Instalar

- [ Cachy OS ](https://cachyos.org/download)
- Crear una unidad USB booteable con el ISO. [ Ventoy ](https://www.ventoy.net/en/index.html)
- Configurar el BIOS para arrancar desde la unidad USB.
- Iniciar el instalador.
- Seguir los pasos del instalador.

## Drivers y actualización
- Actualizar sistema
```bash
sudo pacman -Syu
```

## Audio (si no funciona)
```bash
sudo pacman -Rdd pulseaudio-jack && sudo pacman -S pipewire-pulse pipewire-alsa pipewire-jack wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```
### Si el audio no funciona, editar hyprland.lua y agregar en start:
```lua
hl.on("hyprland.start", function () 
  hl.exec_cmd("sh -c 'sleep 5 && pactl set-card-profile alsa_card.pci-0000_00_1f.3 off && sleep 1 && pactl set-card-profile alsa_card.pci-0000_00_1f.3 output:analog-stereo'")
end)
```

## Aplicaciones
### Software general
```bash
# Sublime text
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
sudo pacman -Syu sublime-text

# Discord
sudo pacman -S discord

# Flatpak
sudo pacman -S flatpak

# Rustdesk flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.rustdesk.RustDesk

# Onlyoffice flatpak
flatpak install flathub org.onlyoffice.desktopeditors
```

### Instalar antigravity
```bash

# Descomprimir y mover antigravity a /opt
sudo tar -xzf Antigravity-*.tar.gz -C /opt/

# Renombrar carpeta
sudo mv /opt/Antigravity\ IDE/ /opt/Antigravity_IDE
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

Nota: En arch hay que editar `/etc/httpd/conf/httpd.conf`
Y mover el workdir hasta el final del archivo
```text
DocumentRoot "/mnt/ddrive/html"
<Directory "/mnt/ddrive/html">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Require all granted
</Directory>
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

### Configurar Git
```bash
#Configurar name, email
git config --global user.name "[NAME]"
git config --global user.email "[EMAIL_ADDRESS]"
```

### Instalar composer
```bash
sudo pacman -S php composer
```

### Instalar NodeJs y npm
```bash
sudo pacman -S fnm
echo 'fnm env --use-on-cd | source' >> ~/.config/fish/config.fish
exec fish #Recargar terminal


fnm current #Ver versión actual
fnm ls-remote #Listar versiones disponibles
fnm install --latest #Instalar última versión
fnm use 26.9 && fnm default 26.9  #User y poner default

```