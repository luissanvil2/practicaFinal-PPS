FROM node:18-alpine

WORKDIR /usr/src/app

# Copiamos primero el package.json para aprovechar la caché de Docker
COPY package*.json ./
RUN npm install

# Copiamos el resto del código
COPY . .

EXPOSE 3000

CMD ["npm", "start"]