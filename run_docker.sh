#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}=== Pontaj Admin Docker Launcher ===${NC}"

# 1. Build the image
echo "Building Docker image..."
docker build -t pontaj-admin .

# 2. Stop existing container (if any)
echo "Stopping old container..."
docker stop pontaj-admin-web 2>/dev/null || true
docker rm pontaj-admin-web 2>/dev/null || true

# 3. Run new container
echo "Starting new container on port 24364..."
docker run -d \
  --name pontaj-admin-web \
  -p 24364:80 \
  --restart unless-stopped \
  pontaj-admin

echo -e "${GREEN}Success! Application is running at http://localhost:24364${NC}"
echo "Check logs with: docker logs -f pontaj-admin-web"
