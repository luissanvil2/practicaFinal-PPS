#!/bin/bash
set -e

echo "1. Iniciando Minikube (esto puede tardar unos minutos)..."
# Arranca minikube solo si no está ya corriendo
minikube status >/dev/null 2>&1 || minikube start --driver=docker

echo "2. Habilitando servidor de métricas para el escalado (HPA)..."
minikube addons enable metrics-server

echo "3. Configurando entorno Docker de Minikube y construyendo imagen..."
eval $(minikube docker-env)
# Construimos la imagen con los cambios de seguridad de KICS
docker build -t mi-api-tareas:1.0 ./app

echo "4. Preparando Secretos y Manifiestos..."
kubectl delete secret db-secret --ignore-not-found
kubectl create secret generic db-secret --from-literal=mongo-uri='mongodb://db:27017/tareas'

echo "5. Desplegando infraestructura en Kubernetes..."
# Aplicamos todos los archivos de la carpeta k8s
kubectl apply -f k8s/

echo "6. Esperando a que la API esté lista..."
kubectl wait --for=condition=ready pod -l app=api --timeout=120s

echo "-------------------------------------------------------"
echo "✅ ¡TODO LISTO! La aplicación está desplegada."
echo "Puedes acceder a través de los puertos expuestos en Codespaces."
echo "-------------------------------------------------------"