# Server Setup Instructions

## Current Status
✅ Container is running on port 8080
✅ Access via: `http://YOUR_SERVER_IP:8080`

## Setting Up Domain Access

You have two options for accessing via your domain:

### Option 1: Automated Setup (Recommended)

I've created a script that automatically detects your Nginx setup and configures it for you.

1. **Upload the script to your server** (or create it there).
2. **Make it executable and run it**:

```bash
chmod +x setup_proxy.sh
./setup_proxy.sh
```

The script will:
- Find the correct Nginx directory (`sites-available` or `conf.d`)
- Create the configuration
- Test and reload Nginx
- Check if your DNS is working
- Offer to run Certbot for SSL

### Option 2: Manual Setup (If script fails)

#### Step 4: Set Up SSL with Let's Encrypt

```bash
# Install certbot if not already installed
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d adminpontaj.binarysquad.club

# Certbot will automatically configure HTTPS
```

After this, your app will be accessible at:
- **HTTP**: `http://adminpontaj.binarysquad.club` (redirects to HTTPS)
- **HTTPS**: `https://adminpontaj.binarysquad.club`

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

### "Directory not found" when creating config
If `/etc/nginx/sites-available/` does not exist, your Nginx installation might use `conf.d`. Try this instead:

```bash
# Check if conf.d exists
ls -d /etc/nginx/conf.d/

# If yes, create config there directly (no symlink needed)
sudo nano /etc/nginx/conf.d/pontaj-admin.conf
```

### Certbot fails or "Non-existent domain"
**CRITICAL**: You MUST add the DNS record before running Certbot.
1. Go to your domain provider (Namecheap, GoDaddy, Cloudflare, etc.)
2. Add an **A Record**:
   - Host/Name: `adminpontaj`
   - Value: `YOUR_SERVER_IP`
3. Wait 5-10 minutes
4. Verify it works: `ping adminpontaj.binarysquad.club`
5. ONLY THEN run Certbot

### Nginx errors
```bash
# Check nginx status
sudo systemctl status nginx

# View error logs
sudo tail -f /var/log/nginx/error.log

# Test configuration
sudo nginx -t
```
