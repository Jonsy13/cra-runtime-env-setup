# Docker Image which is used as foundation to create
# a custom Docker Image with this Dockerfile
FROM node:12.18.0 as react-build

# Checking environment variables
RUN env

# A directory within the virtualized Docker environment
# Becomes more relevant when using Docker Compose later
WORKDIR /frontend

# Copies package.json and package-lock.json to Docker environment
COPY package.json ./
COPY package-lock.json ./

# Installs all node packages except Cypress
RUN npm ci

# Copies everything over to Docker environment
COPY . ./

# Finally runs the application
RUN npm run build

# Stage 2: the production environment
FROM nginxinc/nginx-unprivileged:1.21-alpine
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY  --from=react-build /frontend/build /usr/share/nginx/html

EXPOSE 8080

COPY ./env.sh /usr/share/nginx/html/env.sh
COPY .env /usr/share/nginx/html/.env

# Add bash
RUN apk add --no-cache bash

# Make our shell script executable
RUN chmod +x /usr/share/nginx/html/env.sh

# Start Nginx server
CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]