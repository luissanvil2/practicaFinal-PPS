#!/bin/bash
set -e

echo "1. Preparando entorno de Minikube (Métricas)..."
minikube addons enable metrics-server

echo "2. Construyendo imagen de la API en Minikube..."
eval $(minikube docker-env)
docker build -t mi-api-tareas:1.0 ./app

echo "3. Creando el Secret para MongoDB..."
kubectl delete secret db-secret --ignore-not-found
kubectl create secret generic db-secret --from-literal=mongo-uri='mongodb://db:27017/tareas'

echo "4. Desplegando en Kubernetes..."
kubectl apply -f k8s/

echo "5. Esperando a que los Pods estén listos..."
kubectl wait --for=condition=ready pod -l app=api --timeout=90s

echo "✅ ¡Aplicación desplegada correctamente en K8s!"