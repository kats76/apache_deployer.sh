#!/bin/bash

# Función para verificar el estado de Apache2
estadoApache() {
    if dpkg -l | grep -w '^ii  apache2\s' > /dev/null 2>&1 ; then
        if systemctl is-active --quiet apache2 ; then
            echo "activo"
        else
            echo "inactivo"
        fi
    else
        echo "no instalado"
    fi
}

# Función para instalar Apache2
instalarApache() {
    read -p "¿Desea instalar Apache2? (S/n): " respuesta
    if [ "$respuesta" == "S" ] || [ "$respuesta" == "s" ] || [ -z "$respuesta" ]; then
        estado=$(estadoApache)
        if [ "$estado" == "activo" ]; then
            echo "Apache2 ya está instalado y activo."
        elif [ "$estado" == "inactivo" ]; then
            # Instalar Apache2
            sudo apt update
            sudo apt install apache2
            # Verificar si la instalación fue exitosa
            estado_despues=$(estadoApache)
            if [ "$estado_despues" == "activo" ]; then
                echo "Apache2 se instaló correctamente."
                # Iniciar el servicio Apache2
                sudo systemctl start apache2
                sudo systemctl enable apache2
                echo "Apache2 se inició y se habilitó para ejecutarse en el arranque."
            else
                echo "Hubo un problema al instalar Apache2. Por favor, intente nuevamente."
                exit 1
            fi
        elif [ "$estado" == "no instalado" ]; then
            # Instalar Apache2 si no está instalado
            sudo apt update
            sudo apt install apache2
            # Verificar si la instalación fue exitosa
            if dpkg -l | grep -w '^ii  apache2\s' > /dev/null 2>&1 ; then
                echo "Apache2 se instaló correctamente."
                # Iniciar el servicio Apache2
                sudo systemctl start apache2
                sudo systemctl enable apache2
                echo "Apache2 se inició y se habilitó para ejecutarse en el arranque."
            else
                echo "Hubo un problema al instalar Apache2. Por favor, intente nuevamente."
                exit 1
            fi
        fi
    elif [ "$respuesta" == "N" ] || [ "$respuesta" == "n" ]; then
        echo "No se realizará la instalación de Apache2. Saliendo del programa."
        exit 0
    else
        echo "Opción no válida. Por favor, seleccione S o n."
        exit 1
    fi
}

# Ejecutar la función instalarApache
estadoApache
instalarApache

