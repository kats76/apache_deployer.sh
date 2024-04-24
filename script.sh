#!/bin/bash

# Verificar si Apache está instalado
if ! [ -x "$(command -v apache2)" ]; then
  echo 'Apache2 no está instalado. Intentando instalarlo...' >&2
  
  # Detectar la distribución de Linux
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
  else
    echo "No se pudo detectar la distribución de Linux. Por favor, instala Apache2 manualmente."
    exit 1
  fi

  # Instalar Apache2 según la distribución de Linux
  case $OS in
    "Ubuntu"|"Debian GNU/Linux")
      sudo apt-get install apache2
      ;;
    "CentOS Linux"|"Red Hat Enterprise Linux")
      sudo yum install httpd
      ;;
    "Fedora")
      sudo dnf install httpd
      ;;
    "Arch Linux")
      sudo pacman -S apache
      ;;
    *)
      echo "Distribución no soportada: $OS. Por favor, instala Apache2 manualmente."
      exit 1
      ;;
  esac
fi

# Mostrar la versión de Apache instalada
apache_version=$(apache2 -v | grep -oP '(?<=Apache/)[0-9]+\.[0-9]+\.[0-9]+')
echo "Apache $apache_version está instalado."

# Solicitar al usuario la URL del repositorio
read -p "Por favor ingresa la URL del repositorio: " repositorio_url

# Extraer el nombre del repositorio de la URL
repositorio_nombre=$(basename $repositorio_url .git)

# Clonar el repositorio desde la URL proporcionada
git clone $repositorio_url /tmp/$repositorio_nombre

# Mover el repositorio a la zona de publicación
sudo cp -r /tmp/$repositorio_nombre/ /var/www/html/

echo "Despliegue completado correctamente."
