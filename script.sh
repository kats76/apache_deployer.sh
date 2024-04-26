#!/bin/bash

# Función para determinar la distribución del sistema
get_distribution() {
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "debian" ] || [ "$ID_LIKE" = "debian" ]; then
            echo "debian"
        elif [ "$ID" = "ubuntu" ] || [ "$ID_LIKE" = "ubuntu" ]; then
            echo "ubuntu"
        elif [ "$ID" = "centos" ] || [ "$ID_LIKE" = "rhel fedora" ]; then
            echo "centos"
        elif [ "$ID" = "arch" ] || [ "$ID_LIKE" = "arch" ]; then
            echo "arch"
        fi
    fi
}

# Función para instalar Apache en Arch Linux
install_apache_arch() {
    sudo pacman -Sy --noconfirm apache
}

# Función para iniciar Apache en Arch Linux
start_apache_arch() {
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
}

# Verificar si Apache está instalado
if ! [ -x "$(command -v apache2)" ]; then
    distribution=$(get_distribution)
    case $distribution in
        "arch")
            echo "Instalando Apache en Arch Linux..."
            install_apache_arch
            start_apache_arch
            ;;
        *)
            echo 'Error: Apache2 no está instalado. Instálalo e inténtalo de nuevo.' >&2
            exit 1
            ;;
    esac
fi

# Mostrar la versión de Apache instalada
apache_version=$(httpd -v | awk '/Apache/ {print $3}')
echo "Apache $apache_version está instalado."

# Determinar la ubicación de la carpeta de despliegue
distribution=$(get_distribution)
case $distribution in
    "debian" | "ubuntu")
        deploy_folder="/var/www/html"
        ;;
    "centos" | "arch")
        deploy_folder="/srv/http"
        ;;
    *)
        echo "No se pudo determinar la distribución del sistema. Por favor, verifica la ubicación de la carpeta de despliegue manualmente."
        exit 1
        ;;
esac

# Solicitar al usuario la URL del repositorio
read -p "Por favor ingresa la URL del repositorio: " repositorio_url

# Clonar el repositorio desde la URL proporcionada
git clone $repositorio_url /tmp/mi_repositorio

# Mover el repositorio a la carpeta de despliegue
sudo cp -r /tmp/mi_repositorio/* "$deploy_folder/"

echo "Despliegue completado correctamente en $deploy_folder."
