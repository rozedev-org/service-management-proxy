#!/bin/bash


# Función para manejar errores
handle_error() {
    echo "Error en el paso $1"
    exit 1
}


image=jcdev.online:32000/service-management-proxy
appName=service-management-proxy

# Construir la imagen de Docker
echo "Iniciando construcción de la imagen de Docker..."
docker build -t "$image" ../ || handle_error "construcción"
echo "Construcción de la imagen de Docker completada con éxito."

# Empujar la imagen de Docker
echo "Iniciando empuje de la imagen de Docker al registro..."
docker push "$image:latest" || handle_error "empuje"
echo "Empuje de la imagen de Docker completado con éxito."

# Desplegar en Kubernetes
echo "Iniciando despliegue en Kubernetes..."
kubectl apply -k ../k8s || handle_error "despliegue 1"
kubectl set image deployment/$appName $appName=$image -n service-management || handle_error "despliegue 2"
kubectl rollout restart deployment/$appName -n service-management || handle_error "despliegue 3"
echo "Despliegue en Kubernetes completado con éxito."

echo "Todas las acciones se completaron con éxito."
