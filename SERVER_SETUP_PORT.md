# Server Setup Instructions (Port Access)

## Current Configuration
✅ **Port**: 24364
✅ **Access URL**: `http://binarysquad.club:24364` (or `http://YOUR_SERVER_IP:24364`)

## How to Deploy

1. **Pull the latest changes**:
   ```bash
   git pull
   ```

2. **Run the deployment script**:
   ```bash
   chmod +x run_docker.sh
   ./run_docker.sh
   ```

3. **Verify it's running**:
   ```bash
   docker ps
   ```
   You should see `0.0.0.0:24364->80/tcp`.

## Troubleshooting

### "Site can't be reached"
If you cannot access the site, the port might be blocked by your firewall.

**Open the port:**
```bash
# If using UFW (Ubuntu/Debian)
sudo ufw allow 24364/tcp

# If using Firewalld (CentOS/RHEL)
sudo firewall-cmd --permanent --add-port=24364/tcp
sudo firewall-cmd --reload
```

### "KeyError: 'ContainerConfig'" or Docker Compose Errors
If `docker-compose` fails with obscure errors, use plain Docker commands:

```bash
# 1. Stop and remove old container
docker stop pontaj-admin-web
docker rm pontaj-admin-web

# 2. Build image manually
docker build -t pontaj-admin .

# 3. Run container manually
docker run -d --name pontaj-admin-web -p 24364:80 --restart unless-stopped pontaj-admin
```
