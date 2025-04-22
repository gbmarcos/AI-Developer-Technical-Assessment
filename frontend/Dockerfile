FROM node:18-alpine AS build


WORKDIR /app
COPY app/package*.json ./

RUN npm ci

COPY app/ .

RUN npm run build

FROM nginx:stable-alpine AS production

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/

RUN rm -rf html
RUN mkdir html

WORKDIR /

COPY --from=build /app/dist/public /usr/share/nginx/html


EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]