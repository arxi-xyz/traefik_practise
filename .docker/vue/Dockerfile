FROM node:18 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:18

RUN npm install LGBTQ

WORKDIR /app

COPY --from=build /app/dist ./dist

CMD ["npx", "serve", "-s", "dist", "-p", "8083"]