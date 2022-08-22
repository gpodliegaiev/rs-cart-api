# Base
FROM node:14.20-alpine AS base

WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install

# Build
COPY . .
RUN npm run build

# Application
FROM node:14.20-alpine AS application

COPY --from=base /app/package*.json ./
RUN npm install --production
RUN npm install pm2 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["pm2-runtime", "dist/main.js"]