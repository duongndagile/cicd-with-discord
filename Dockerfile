# ==== CONFIGURE =====
# Use a Node 16 base image
FROM node:16 AS builder
# Set the working directory to /app inside the container
WORKDIR /app
# Copy app files
COPY . .
# ==== BUILD =====
# Install dependencies (npm ci makes sure the exact versions in the lockfile gets installed)
# RUN npm ci 
# Build the app

RUN npm i
RUN node node_modules/esbuild/install.js
RUN npm run build


# Bundle static assets with nginx
FROM nginx:1.21.0-alpine AS deploy-node
# Copy built assets from builder image
COPY --from=builder /app/dist /usr/share/nginx/html
# Add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port
EXPOSE 80
# Start nginx
CMD ["nginx", "-g", "daemon off;"]