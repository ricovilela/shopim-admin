FROM node:16-alpine as build

WORKDIR /app

ENV __MEDUSA_BACKEND_URL__=https://shopim-be-production.up.railway.app

COPY package*.json ./

RUN yarn --silent

COPY . .

RUN yarn build

FROM nginx:alpine as server

COPY --from=build /app/public /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
