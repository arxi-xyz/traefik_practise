FROM node:20 AS build

WORKDIR /app

COPY ./frontend/package*.json ./

RUN npm install --verbose

COPY ./frontend .

RUN npm run build

FROM node:20

RUN npm install -g serve

WORKDIR /app

COPY --from=build /app/dist ./dist

CMD ["npx", "serve", "-s", "dist", "-p", "8083"]