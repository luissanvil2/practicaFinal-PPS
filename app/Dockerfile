FROM node:18-alpine

WORKDIR /usr/src/app

FROM node:18-alpine

# [CORRECCIÓN KICS - HIGH] Vulnerabilidad existente: El contenedor corre como root por defecto.
# Se añade USER node para ejecutar el proceso con un usuario sin privilegios.
USER node

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./
RUN npm install
COPY --chown=node:node . .

EXPOSE 3000
CMD ["npm", "start"]