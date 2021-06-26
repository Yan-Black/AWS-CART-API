FROM node:15.4.0-alpine AS base

WORKDIR app/

#Dependencies
COPY package*.json ./
RUN npm install

#Build
COPY . .
RUN npm run Build

#Application
FROM node:15.4.0-alpine AS application

COPY --from=base /app/package*.json ./

RUN npm install --only=production
RUN npm install pm2 -g

COPY --from=base /app/dist ./dist

USER node
ENV port=8080
EXPOSE 8080

CMD ["pm2-runtime", "dist/main.js"]


