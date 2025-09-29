# Stage 1: Build stage
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Nginx serve
FROM nginx:latest
COPY --from=build /app/dist /usr/share/nginx/html
# Optional: Custom Nginx config to handle SPA routes
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { try_files $uri /index.html; } \
}' > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
