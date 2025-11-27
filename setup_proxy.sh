#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Pontaj Admin Server Setup Assistant ===${NC}"

# 1. Check if Nginx is installed
if ! command -v nginx &> /dev/null; then
    echo -e "${RED}Error: Nginx is not installed or not in PATH.${NC}"
    echo "Please install Nginx first (e.g., sudo apt install nginx)"
    exit 1
fi

# 2. Detect Nginx Configuration Directory
NGINX_CONF_DIR=""
if [ -d "/etc/nginx/sites-available" ]; then
    NGINX_CONF_DIR="/etc/nginx/sites-available"
    NGINX_ENABLED_DIR="/etc/nginx/sites-enabled"
    USE_SYMLINK=true
elif [ -d "/etc/nginx/conf.d" ]; then
    NGINX_CONF_DIR="/etc/nginx/conf.d"
    USE_SYMLINK=false
else
    echo -e "${RED}Error: Could not find standard Nginx configuration directories.${NC}"
    echo "Checked: /etc/nginx/sites-available and /etc/nginx/conf.d"
    exit 1
fi

echo -e "${GREEN}Found Nginx configuration directory: ${NGINX_CONF_DIR}${NC}"

# 3. Create Nginx Configuration
DOMAIN="adminpontaj.binarysquad.club"
CONFIG_FILE="$NGINX_CONF_DIR/pontaj-admin.conf"

echo "Creating configuration file at $CONFIG_FILE..."

# Write the config file
sudo bash -c "cat > $CONFIG_FILE" <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# 4. Enable Site (if using sites-available)
if [ "$USE_SYMLINK" = true ]; then
    if [ ! -L "$NGINX_ENABLED_DIR/pontaj-admin.conf" ]; then
        echo "Enabling site via symlink..."
        sudo ln -s "$CONFIG_FILE" "$NGINX_ENABLED_DIR/pontaj-admin.conf"
    fi
fi

# 5. Test and Reload Nginx
echo "Testing Nginx configuration..."
if sudo nginx -t; then
    echo -e "${GREEN}Configuration valid! Reloading Nginx...${NC}"
    sudo systemctl reload nginx
else
    echo -e "${RED}Nginx configuration test failed!${NC}"
    exit 1
fi

# 6. Check DNS
echo -e "\n${YELLOW}Checking DNS for $DOMAIN...${NC}"
if ping -c 1 $DOMAIN &> /dev/null; then
    echo -e "${GREEN}DNS is propagating correctly!${NC}"
    
    # 7. Offer to run Certbot
    echo -e "\nWould you like to set up SSL with Certbot now? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        if command -v certbot &> /dev/null; then
            sudo certbot --nginx -d $DOMAIN
        else
            echo -e "${RED}Certbot not found. Please install it (sudo apt install certbot python3-certbot-nginx)${NC}"
        fi
    fi
else
    echo -e "${RED}DNS lookup failed for $DOMAIN${NC}"
    echo "CRITICAL: You must add an 'A Record' for 'adminpontaj' pointing to your server IP in your DNS provider settings."
    echo "Wait for DNS to propagate (can take 10 mins to 24 hours) before running Certbot."
fi

echo -e "\n${GREEN}Setup script completed!${NC}"
