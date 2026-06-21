#!/bin/bash

# Salir inmediatamente si un comando falla
set -e

echo "🚀 Iniciando instalación del entorno LAMP local..."

# 1. Actualizar sistema
sudo apt update && sudo apt upgrade -y

# 2. Instalar Apache y configurar Firewall
sudo apt install apache2 -y
sudo ufw allow 'Apache Full'

# 3. Instalar MariaDB
sudo apt install mariadb-server -y

# 4. Instalar PHP y extensiones comunes
sudo apt install php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-curl php-xml php-mcrypt -y

# 5. Configurar phpMyAdmin de forma no interactiva (Evita las pantallas azules)
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webconfig select apache2" | sudo debconf-set-selections
sudo apt install phpmyadmin -y

# 6. Configurar permisos para tu usuario local (Reemplaza $USER por tu usuario actual)
sudo chown -R $USER:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# 7. Crear archivo de prueba phpinfo
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

# 8. Configurar phpMyAdmin
echo "🔗 Enlazando configuración de phpMyAdmin en Apache..."
sudo ln -sf /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin

# 9. Cambiar contraseña de root de maria-db
echo "🔑 Cambiando contraseña de root de MariaDB..."
sudo maria-db -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"

# 10. Reiniciar Apache para aplicar cambios
echo "🔄 Reiniciando Apache para aplicar cambios..."
sudo systemctl restart apache2

echo "🎉 ¡Instalación completada con éxito!"
echo "🌐 Apache: http://localhost"
echo "📄 PHP Info: http://localhost/phpinfo.php"
echo "🗄️ phpMyAdmin: http://localhost/phpmyadmin"
