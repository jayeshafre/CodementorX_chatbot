# Multi-stage React Dockerfile for CodeMentorX Frontend
# Optimized for AWS Free Tier deployment with minimal resource usage

# Stage 1: Build (Node.js for building the React app)
FROM node:20-alpine as builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install ALL dependencies (including devDependencies needed for build)
RUN npm ci --ignore-scripts && \
    npm cache clean --force

# Copy source code
COPY . .

# Build arguments for environment variables (passed during build)
ARG VITE_DJANGO_API_URL=http://localhost:8000
ARG VITE_CHATBOT_API_URL=http://localhost:8001/api
ARG VITE_APP_NAME=CodementorX

# Set environment variables for build
ENV VITE_DJANGO_API_URL=${VITE_DJANGO_API_URL}
ENV VITE_CHATBOT_API_URL=${VITE_CHATBOT_API_URL}
ENV VITE_APP_NAME=${VITE_APP_NAME}

# Build the application
RUN npm run build

# Stage 2: Production (Nginx for serving static files)
FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Create nginx user and set permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 3000 (nginx will serve on this port)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]