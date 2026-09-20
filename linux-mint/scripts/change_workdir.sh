#!/bin/bash

# Salir si un comando falla
set -e

# 1. Definir la ruta (Parámetro o Valor por defecto)
NUEVA_RUTA="${1:-/mnt/ddrive/html}"

echo "🔄 Configurando Apache para usar la ruta: $NUEVA_RUTA"

# 2. Crear el directorio si no existe
if [ ! -d "$NUEVA_RUTA" ]; then
    echo "📂 Creando el directorio..."
    sudo mkdir -p "$NUEVA_RUTA"
fi

# 3. Modificar el DocumentRoot en el sitio por defecto de Apache
echo "⚙️ Actualizando DocumentRoot en 000-default.conf..."
# Busca la línea DocumentRoot y la reemplaza por completo usando '|' como delimitador
sudo sed -i "s|DocumentRoot .*|DocumentRoot $NUEVA_RUTA|g" /etc/apache2/sites-available/000-default.conf

# 4. Añadir bloque de permisos en apache2.conf (Solo si no existe ya para esa ruta)
if ! grep -q "<Directory $NUEVA_RUTA/>" /etc/apache2/apache2.conf; then
    echo "🔐 Añadiendo directiva de seguridad en apache2.conf..."
    sudo bash -c "cat >> /etc/apache2/apache2.conf" << EOF

# Directorio de desarrollo personalizado
<Directory $NUEVA_RUTA/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF
fi

# 5. Configurar permisos de usuario y grupo de Apache
echo "👥 Ajustando permisos de la carpeta..."
sudo chown -R $USER:www-data "$NUEVA_RUTA"
sudo chmod -R 755 "$NUEVA_RUTA"

# 6. Crear un archivo phpinfo de prueba en la nueva ubicación
echo "📝 Creando archivo phpinfo.php..."
echo "<?php phpinfo(); ?>" > "$NUEVA_RUTA/phpinfo.php"
sudo cp /var/www/html/index.html "$NUEVA_RUTA/"

# 7. Reiniciar Apache para aplicar los cambios
echo "🔄 Reiniciando Apache..."
sudo systemctl restart apache2

echo "🎉 ¡Cambio completado con éxito!"
echo "🌐 Sitio local: http://localhost"
echo "📄 PHP Info: http://localhost/phpinfo.php"
