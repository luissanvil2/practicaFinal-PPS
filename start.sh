#!/bin/bash
set -e

echo "1. Iniciando entorno de Minikube (esto puede tardar unos minutos)..."
# Inicia minikube solo si no está ya en ejecución
minikube status >/dev/null 2>&1 || minikube start --driver=docker

echo "2. Habilitando servidor de métricas para el autoescalado (HPA)..."
minikube addons enable metrics-server

echo "3. Configurando entorno Docker de Minikube y construyendo imagen segura..."
eval $(minikube docker-env)
# Construimos la imagen usando el Dockerfile que ya tiene la corrección de usuario node
docker build -t mi-api-tareas:1.0 ./app

echo "4. Preparando Secretos de la Base de Datos..."
kubectl delete secret db-secret --ignore-not-found
kubectl create secret generic db-secret --from-literal=mongo-uri='mongodb://db:27017/tareas'

echo "5. Desplegando infraestructura en Kubernetes (API, DB, HPA)..."
# Aplicamos todos los archivos corregidos de la carpeta k8s
kubectl apply -f k8s/

echo "6. Esperando a que los servicios estén listos..."
kubectl wait --for=condition=ready pod -l app=api --timeout=120s

echo "-------------------------------------------------------"
echo "✅ DESPLIEGUE COMPLETADO CON ÉXITO"
echo "-------------------------------------------------------"
echo "7. Abriendo túnel de acceso para Codespaces..."
echo "👉 Haz clic en el enlace emergente o ve a la pestaña PORTS."
echo "⚠️  Mantén esta terminal abierta para que el túnel no se cierre."
echo "-------------------------------------------------------"

# Este comando permite que el profesor vea la web desde fuera de Codespaces
kubectl port-forward service/api 3000:3000