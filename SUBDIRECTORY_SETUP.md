# Setup Access via Subdirectory (Bypasses Port Blocking)

Since accessing port 24364 directly is blocked (likely by Cloudflare or a Cloud Firewall), the best solution is to serve the app through your existing main website using a **subdirectory**.

This means accessing it at: **`https://binarysquad.club/pontaj-admin`**

## Step 1: Find your existing Nginx config

Run this command to find which file handles your main domain:
```bash
grep -l "server_name binarysquad.club" /etc/nginx/sites-enabled/*
```
It will output a filename (e.g., `/etc/nginx/sites-enabled/default` or `/etc/nginx/sites-enabled/binarysquad`).

## Step 2: Edit that file

Open the file found in Step 1:
```bash
sudo nano /etc/nginx/sites-enabled/YOUR_FOUND_FILE
```

## Step 3: Add the Location Block

Paste this code block **inside** the `server { ... }` block (before the closing `}`):

```nginx
    # Pontaj Admin Subdirectory Proxy
    location /pontaj-admin {
        # Rewrite URL to remove the subdirectory part before passing to container
        rewrite ^/pontaj-admin/(.*)$ /$1 break;
        
        proxy_pass http://localhost:24364;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
```

## Step 4: Test and Reload

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Step 5: Access the App

Go to: **`https://binarysquad.club/pontaj-admin/`**
(Note: The trailing slash `/` is important!)
