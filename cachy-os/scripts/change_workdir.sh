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

# 3. Modificar el DocumentRoot en el archivo principal de Apache (httpd.conf)
echo "⚙️ Actualizando DocumentRoot en httpd.conf..."
# En Arch Linux se deben actualizar tanto la directiva DocumentRoot como el bloque <Directory> principal que la acompaña
sudo sed -i "s|^DocumentRoot \".*\"|DocumentRoot \"$NUEVA_RUTA\"|g" /etc/httpd/conf/httpd.conf
sudo sed -i "s|^<Directory \".*\">|<Directory \"$NUEVA_RUTA\">|g" /etc/httpd/conf/httpd.conf

# 4. Modificar los permisos internos del bloque de la ruta si es necesario
# Nota: Por defecto el bloque <Directory> en Arch ya viene configurado de forma segura, 
# pero nos aseguramos de que permita AllowOverride All para los archivos .htaccess
echo "🔐 Asegurando directivas AllowOverride en httpd.conf..."
# Usamos '|' como delimitador para que las barras de la ruta no rompan el comando sed
sudo sed -i "\|<Directory \"$NUEVA_RUTA\">|,\|</Directory>| s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf

# 5. Configurar permisos de usuario y grupo de Apache
echo "👥 Ajustando permisos de la carpeta..."
# En Arch Linux el grupo web por defecto es 'http'
sudo chown -R $USER:http "$NUEVA_RUTA"
sudo chmod -R 755 "$NUEVA_RUTA"

# 6. Crear un archivo phpinfo de prueba en la nueva ubicación
echo "📝 Creando archivo phpinfo.php..."
echo "<?php phpinfo(); ?>" > "$NUEVA_RUTA/phpinfo.php"

# Intentar copiar el index.html original si existe en la ruta por defecto de Arch (/srv/http)
if [ -f /srv/http/index.html ]; then
    sudo cp /srv/http/index.html "$NUEVA_RUTA/"
else
    echo "<h1>Apache funciona en su nueva ruta de CachyOS</h1>" > "$NUEVA_RUTA/index.html"
fi

# 7. Reiniciar Apache (httpd) para aplicar los cambios
echo "🔄 Reiniciando Apache..."
sudo systemctl restart httpd

echo "🎉 ¡Cambio completado con éxito!"
echo "🌐 Sitio local: http://localhost"
echo "📄 PHP Info: http://localhost/phpinfo.php"
