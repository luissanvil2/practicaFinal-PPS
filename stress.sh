#!/bin/bash
set -euo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "ERROR: kubectl no está instalado o no está en el PATH."
  exit 1
fi

cat <<'EOF'
Ejecutando carga de estrés usando kubectl:
  kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://api:3000/tareas; done"

Para detener la prueba, presiona Ctrl+C.
EOF

kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://api:3000/tareas; done"
