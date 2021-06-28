FROM node:12-alpine AS base

WORKDIR /app

#Dependencies
FROM base AS dependencies
COPY package*.json ./
RUN npm install 

#Build
FROM dependencies AS build
WORKDIR /app
COPY src /app
RUN npm run build

#Application
FROM node:12-alpine AS release
WORKDIR /app
COPY --from=dependencies /app/package*.json ./
RUN npm install --only=production
RUN npm install pm2 -g
COPY --from=build /app ./dist

USER node
ENV port=8080
EXPOSE 8080

CMD ["pm2-runtime", "dist/main.js"]


