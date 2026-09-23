# fastfetch

## Instalación
```bash
sudo apt install fastfetch #Debian/Ubuntu
sudo pacman -S fastfetch #Arch/Manjaro/CachyOS
sudo dnf install fastfetch #Fedora
```

## Ejecutar al abrir terminal

Dependiendo de tu shell bash, zsh, fish, etc. se debe agregar fastfetch al final de los archivos de configuración:
```bash
# Bash
echo "fastfetch" >> ~/.bashrc

# Zsh
echo "fastfetch" >> ~/.zshrc

# Fish
echo "fastfetch" >> ~/.config/fish/config.fish
```

## Personalizar fastfetch

Fastfetch guarda la información en el archivo ~/.config/fastfetch/config.jsonc.
Así que puedes descargar alguna plantilla [Ejemplo plantilla de fastcat](https://github.com/m3tozz/FastCat/tree/main/Large-Themes/Anime-Girl/fastfetch) y solo reemplazar los archivos dentro de ~/.config/fastfetch/.
Después solo debes ejecutar otra vez `fastfetch` para ver los cambios.

### Ejemplo plantilla personalizada.
- [config.jsonc](/cachy-os/.config/fastfetch/config.jsonc)
- [ascii.txt](/cachy-os/.config/fastfetch/ascii.txt)

## Estructura del archivo config.jsonc

El archivo cuenta con 3 secciones principales:

### $schema
Define la ruta del esquema JSON para la validación del archivo.
```jsonc
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json"
}
```

### logo
En esta sección se define la imagen que se mostrará en la terminal.
Hay 2 formas de asigar una imagen:
1. Usar un nombre de los logos que ya tiene fastfetch
```jsonc
{
    "logo": "uwuntu"
}
```
2. Usar una imagen personalizada
```jsonc
{
    "logo": {
        "source": "~/.config/fastfetch/ascii.txt",
        "color": {
            "1": "35"
        }
    }
}
```

### modules
En esta sección se definen los módulos que se mostrarán en la terminal.
Al igual que con el logo, puedes usar un formato predeterminado o crear uno personalizado.

#### Formato predeterminado
```jsonc
{
    "modules": [
        "title",
        "break",
        "os",
        "host",
        "kernel",
        "uptime",
        "shell",
        "wm",
        "break",
        "display",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "colors"
    ]
}
```
#### Formato personalizado
```jsonc
{
    "modules": [
        "title",
        {
            "type": "custom",
            "format": "┌────────────────────────OS────────────────────────┐",
            "outputColor": "35"
        },
        { "type": "os",       "key": "🏴‍☠️ OS     ", "keyColor": "36" },
        { "type": "host",     "key": "🏗️ Host     ", "keyColor": "36" },
        { "type": "kernel",   "key": "🧬 Kernel  ", "keyColor": "36" },
        { "type": "uptime",   "key": "⏳ Uptime  ", "keyColor": "36" },
        { "type": "shell",    "key": "🐚 Shell   ", "keyColor": "36" },
        { "type": "wm",       "key": "🧭 WM      ", "keyColor": "36" },
        {
            "type": "custom",
            "format": "└──────────────────────────────────────────────────┘",
            "outputColor": "35"
        },
        {
            "type": "custom",
            "format": "┌─────────────────────HARDWARE─────────────────────┐",
            "outputColor": "35"
        },
        { "type": "display",  "key": "🖥️ Display  ", "keyColor": "blue" },
        { "type": "cpu",      "key": "⚙️ CPU      ", "format": "{1}", "keyColor": "blue" },
        { "type": "gpu",      "key": "⚡ GPU     ", "keyColor": "blue" },
        { "type": "memory",   "key": "🧠 Memory  ", "keyColor": "blue" },
        { "type": "disk",     "key": "🛖 Disk    ", "keyColor": "blue" },
        {
            "type": "custom",
            "format": "└──────────────────────────────────────────────────┘",
            "outputColor": "35"
        },
        {
            "type": "colors",
            "symbol": "circle"
        },
        {
            "type": "custom",
            "format": "────────────────────────────────────────────────────",
            "outputColor": "35"
        },
        {
            "type": "custom",
            "format": "\"(≧◡≦)\"",
            "outputColor": "34"
        }
    ]
}
```