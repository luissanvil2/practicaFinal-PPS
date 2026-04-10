# practicaFinal-PPS

## Descripción de la aplicación

Esta aplicación es una API CRUD de tareas construida con Node.js, Express y MongoDB. Permite crear, leer, actualizar y borrar tareas desde un endpoint REST en `/tareas`.

La versión del proyecto está pensada para ejecutarse sobre Kubernetes usando un contenedor de la API y una base de datos MongoDB en un clúster local de Minikube.

## Estructura del proyecto

- `app/`
  - `server.js`: servidor Express con rutas CRUD para el modelo de tarea.
  - `package.json`: dependencias y comando de inicio de la aplicación.
  - `public/`: archivos estáticos servidos por la aplicación.
- `k8s/`
  - `api.yaml`: manifiesto de despliegue y servicio de la API.
  - `mongo.yaml`: manifiesto de despliegue y servicio de MongoDB.
  - `hpa.yaml`: configuración del Horizontal Pod Autoscaler para la API.
- `start.sh`: script de despliegue que prepara Minikube, construye la imagen Docker, crea el secreto y aplica los manifiestos.
- `stress.sh`: script que ejecuta el comando de carga para estresar la API usando `kubectl run` con `busybox`.
- `README.md`: documentación del proyecto.

## Despliegue

Para desplegar la aplicación en el clúster solo hay que ejecutar el script:

```bash
./start.sh
```

Este script arranca Minikube si es necesario, habilita el servidor de métricas, construye la imagen Docker, crea el secreto de la base de datos y aplica los manifiestos de Kubernetes.

## Estrés de la aplicación

Para estresar la API utiliza el script:

```bash
./stress.sh
```

El script ejecuta el comando `kubectl run ...` con `busybox:1.28` y hace peticiones continuas a `http://api:3000/tareas`.

Para detener la prueba presiona `Ctrl+C`.
