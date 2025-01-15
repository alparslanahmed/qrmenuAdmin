FROM ghcr.io/cirruslabs/flutter as build

WORKDIR /app

COPY . .
RUN flutter pub get
RUN flutter build web

FROM nginx:alpine as nginx

COPY ssl /etc/nginx/ssl
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]