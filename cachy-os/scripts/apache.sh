#!/bin/bash

# Salir inmediatamente si un comando falla
set -e

echo "🚀 Iniciando instalación del entorno LAMP local en CachyOS..."

# 1. Actualizar sistema
sudo pacman -Syu --noconfirm

# 2. Instalar Apache y configurar Firewall (CachyOS/Arch no usa ufw por defecto, pero se incluye por paridad)
sudo pacman -S apache --noconfirm
if command -v ufw &> /dev/null; then
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
fi

# 3. Instalar MariaDB e inicializar su base de datos (Paso obligatorio en Arch)
sudo pacman -S mariadb --noconfirm
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "📦 Inicializando directorio de MariaDB..."
    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi
sudo systemctl start mariadb

# 4. Instalar PHP y extensiones comunes
sudo pacman -S php php-apache php-gd --noconfirm

# 5. Instalar phpMyAdmin
sudo pacman -S phpmyadmin --noconfirm

# 6. Configurar permisos para tu usuario local
# Nota: En Arch el grupo web por defecto es 'http', no 'www-data'
sudo chown -R $USER:http /srv/http
sudo chmod -R 755 /srv/http

# 7. Crear archivo de prueba phpinfo
echo "<?php phpinfo(); ?>" > /srv/http/phpinfo.php

# 8. Configurar phpMyAdmin y PHP en Apache
echo "🔗 Configurando Apache para PHP y phpMyAdmin..."

# Configurar el módulo de PHP en Apache reemplazando el módulo de eventos por mpm_prefork
sudo sed -i 's/LoadModule mpm_event_module/#LoadModule mpm_event_module/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/' /etc/httpd/conf/httpd.conf

# Añadir las líneas necesarias para cargar PHP al final del archivo si no existen
if ! grep -q "libphp.so" /etc/httpd/conf/httpd.conf; then
    echo -e "\n# Configuración de PHP\nLoadModule php_module modules/libphp.so\nAddHandler php-script .php\nInclude conf/extra/php_module.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

# Habilitar extensiones necesarias en php.ini (mysqli, iconv, bz2, pdo_mysql)
sudo sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini
sudo sed -i 's/;extension=iconv/extension=iconv/' /etc/php/php.ini
sudo sed -i 's/;extension=bz2/extension=bz2/' /etc/php/php.ini

# Crear enlace o archivo de configuración para phpMyAdmin en Apache
sudo tee /etc/httpd/conf/extra/httpd-phpmyadmin.conf > /dev/null << 'EOF'
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>
EOF

if ! grep -q "httpd-phpmyadmin.conf" /etc/httpd/conf/httpd.conf; then
    echo -e "\n# Configuración de phpMyAdmin\nInclude conf/extra/httpd-phpmyadmin.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

# 9. Cambiar contraseña de root de MariaDB
echo "🔑 Cambiando contraseña de root de MariaDB..."
sudo mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"

# 10. Habilitar y reiniciar servicios para aplicar cambios
echo "🔄 Habilitando y reiniciando servicios..."
sudo systemctl enable httpd mariadb
sudo systemctl restart httpd

echo "🎉 ¡Instalación completada con éxito!"
echo "🌐 Apache: http://localhost"
echo "📄 PHP Info: http://localhost/phpinfo.php"
echo "🗄️ phpMyAdmin: http://localhost/phpmyadmin"
