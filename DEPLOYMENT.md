# Deployment Guide for Pontaj Admin

This guide explains how to deploy the Pontaj Admin web application using Docker.

## Prerequisites

- Docker installed on your server ([Install Docker](https://docs.docker.com/engine/install/))
- Docker Compose installed ([Install Docker Compose](https://docs.docker.com/compose/install/))
- Git (to clone the repository)

## Quick Start

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd pontaj_admin
```

### 2. Build and Run with Docker Compose

```bash
docker-compose up -d
```

The application will be available at `http://localhost:24364`

### 3. Stop the Application

```bash
docker-compose down
```

## Configuration

### Port Configuration

By default, the application is exposed on port `8080`. To change this, edit the `docker-compose.yml` file:

```yaml
ports:
  - "your-custom-port:80"
```

For example, to use port `3000`:

```yaml
ports:
  - "3000:80"
```

### Environment Variables

If you need to configure environment variables (e.g., API endpoints), add them to the `docker-compose.yml` file:

```yaml
environment:
  - API_URL=https://your-api-endpoint.com
  - OTHER_VAR=value
```

## Production Deployment

### Option 1: Using Docker Compose (Recommended)

1. **Copy files to your server**:
   ```bash
   scp -r pontaj_admin user@your-server:/path/to/deployment
   ```

2. **SSH into your server**:
   ```bash
   ssh user@your-server
   cd /path/to/deployment/pontaj_admin
   ```

3. **Start the application**:
   ```bash
   docker-compose up -d
   ```

4. **View logs**:
   ```bash
   docker-compose logs -f
   ```

### Option 2: Using Docker Only

1. **Build the image**:
   ```bash
   docker build -t pontaj-admin:latest .
   ```

2. **Run the container**:
   ```bash
   docker run -d \
     --name pontaj-admin \
     -p 8080:80 \
     --restart unless-stopped \
     pontaj-admin:latest
   ```

## Setting Up with Reverse Proxy

If you want to serve the application through a reverse proxy (e.g., Nginx, Traefik), configure it to forward requests to `localhost:8080`.

### Example Nginx Reverse Proxy Configuration

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

For HTTPS, you can use Let's Encrypt with Certbot.

## Health Checks

The nginx server includes a health check endpoint:

```bash
curl http://localhost:8080/health
```

Should return: `healthy`

## Updating the Application

1. **Pull the latest changes**:
   ```bash
   git pull origin main
   ```

2. **Rebuild and restart**:
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

## Troubleshooting

### Container won't start

Check the logs:
```bash
docker-compose logs web
```

### Port already in use

Change the port in `docker-compose.yml` or stop the service using that port.

### Application not loading

1. Check if the container is running:
   ```bash
   docker ps
   ```

2. Check nginx logs inside the container:
   ```bash
   docker exec pontaj-admin-web cat /var/log/nginx/error.log
   ```

### Build failures

Ensure you have sufficient disk space and Docker has enough resources allocated.

## Backup and Maintenance

### Viewing Container Stats

```bash
docker stats pontaj-admin-web
```

### Cleaning Up Old Images

```bash
docker system prune -a
```

## Security Recommendations

1. **Use HTTPS**: Set up SSL/TLS certificates (Let's Encrypt recommended)
2. **Firewall**: Configure firewall to only allow necessary ports
3. **Updates**: Regularly update the base images:
   ```bash
   docker-compose pull
   docker-compose up -d
   ```
4. **Secrets**: Never commit sensitive data to the repository

## Support

For issues or questions, please refer to the main [README.md](README.md) or contact the development team.
