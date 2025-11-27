# Server Setup Instructions

## Current Status
✅ Container is running on port 8080
✅ Access via: `http://YOUR_SERVER_IP:8080`

## Setting Up Domain Access

You have two options for accessing via your domain:

### Option 1: Subdomain (Recommended) - `pontaj.binarysquad.club`

#### Step 1: DNS Configuration
Add an A record to your DNS:
- **Type**: A
- **Name**: pontaj
- **Value**: Your server IP address
- **TTL**: 3600 (or auto)

#### Step 2: Copy Nginx Configuration
On your server, create the nginx config:

```bash
# Copy the reverse proxy config
sudo nano /etc/nginx/sites-available/pontaj-admin.conf
```

Paste the contents from `nginx-reverse-proxy.conf` (included in this repo).

#### Step 3: Enable the Site

```bash
# Create symlink
sudo ln -s /etc/nginx/sites-available/pontaj-admin.conf /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

#### Step 4: Set Up SSL with Let's Encrypt

```bash
# Install certbot if not already installed
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d pontaj.binarysquad.club

# Certbot will automatically configure HTTPS
```

After this, your app will be accessible at:
- **HTTP**: `http://pontaj.binarysquad.club` (redirects to HTTPS)
- **HTTPS**: `https://pontaj.binarysquad.club`

---

### Option 2: Subdirectory - `binarysquad.club/pontaj`

Edit your existing nginx configuration for binarysquad.club:

```nginx
location /pontaj {
    rewrite ^/pontaj/(.*)$ /$1 break;
    proxy_pass http://localhost:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

Then reload nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

Access at: `https://binarysquad.club/pontaj`

---

## Quick Access (No Domain Setup)

Access directly via port:
```
http://YOUR_SERVER_IP:8080
```

Or if you have firewall rules allowing port 8080:
```
http://binarysquad.club:8080
```

---

## Troubleshooting

### Port 8080 not accessible from outside
Check firewall:
```bash
# For ufw
sudo ufw allow 8080/tcp

# For firewalld
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Container not running
```bash
# Check status
docker ps | grep pontaj-admin-web

# View logs
docker logs pontaj-admin-web

# Restart
docker-compose restart
```

### Nginx errors
```bash
# Check nginx status
sudo systemctl status nginx

# View error logs
sudo tail -f /var/log/nginx/error.log

# Test configuration
sudo nginx -t
```
