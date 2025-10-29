# Use official Node LTS image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Default env
ENV NODE_ENV=production
ENV PORT=3000

# Start app
CMD ["node", "src/index.js"]
