#!/bin/bash

# Salir si un comando falla
set -e

# 1. Instalar PPA de PHP.
sudo add-apt-repository ppa:ondrej/php

# 2. Actualizar el sistema.
sudo apt update

# 3. Agregar función switch-php.
cat >> ~/.bashrc << 'EOF'

switch-php() {
    if [ ! -f "/usr/bin/php$1" ]; then
        echo "Error: PHP $1 no está instalado. Instálalo con: sudo apt install php$1"
        return 1
    fi

    echo "Cambiando a PHP $1..."
    sudo update-alternatives --set php /usr/bin/php$1 >/dev/null 2>&1
    if [ -f "/usr/bin/phar$1" ]; then
        sudo update-alternatives --set phar /usr/bin/phar$1 >/dev/null 2>&1
    fi

    local active_mods=$(a2query -m | grep -E '^php[0-9.]+' | awk '{print $1}')

    if [ ! -z "$active_mods" ]; then
        for mod in $active_mods; do
            sudo a2dismod $mod >/dev/null 2>&1
        done
    fi

    sudo a2enmod php$1
    sudo systemctl restart apache2

    hash -r

    echo "¡Listo! Versión actual:"
    php -v
}

install-php-version() {
    sudo apt install php$1 php$1-common php$1-cli php$1-curl php$1-mbstring php$1-mysql php$1-xml php$1-zip
    switch-php $1
}

EOF
