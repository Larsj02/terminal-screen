# Nginx Deployment with Let's Encrypt SSL

This guide shows how to deploy your Terminal Screenshot Generator on a server using nginx with SSL certificates from Let's Encrypt.

## Prerequisites

- Ubuntu/Debian server with root access
- Domain name pointing to your server
- Server with ports 80 and 443 open

## Installation Steps

### 1. Install nginx and certbot

```bash
# Update packages
sudo apt update

# Install nginx
sudo apt install nginx -y

# Install certbot for Let's Encrypt
sudo apt install certbot python3-certbot-nginx -y

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 2. Build your application

```bash
# On your local machine or server
npm install
npm run build

# Upload the dist folder to your server
# Example using rsync:
rsync -avz dist/ user@yourserver.com:/var/www/terminal-screenshot/
```

### 3. Create nginx configuration

```bash
# Create nginx site configuration
sudo nano /etc/nginx/sites-available/terminal-screenshot
```

Copy the configuration from `nginx.conf` in this directory, then:

```bash
# Enable the site
sudo ln -s /etc/nginx/sites-available/terminal-screenshot /etc/nginx/sites-enabled/

# Remove default nginx site
sudo rm /etc/nginx/sites-enabled/default

# Test nginx configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

### 4. Get SSL certificate from Let's Encrypt

```bash
# Replace yourdomain.com with your actual domain
sudo certbot --nginx -d yourdomain.com
```

Follow the prompts to:
- Enter your email address
- Agree to terms of service
- Choose whether to share your email with EFF
- Select redirect option (recommended)

### 5. Set up automatic renewal

```bash
# Test renewal
sudo certbot renew --dry-run

# Certbot automatically adds a cron job, but you can check:
sudo systemctl status certbot.timer
```

## File Locations

- **Web files**: `/var/www/terminal-screenshot/`
- **Nginx config**: `/etc/nginx/sites-available/terminal-screenshot`
- **SSL certificates**: `/etc/letsencrypt/live/yourdomain.com/`
- **Nginx logs**: `/var/log/nginx/`

## Configuration Files Included

- `nginx.conf` - Basic nginx configuration
- `nginx-ssl.conf` - nginx configuration with SSL (auto-generated by certbot)
- `deploy.sh` - Deployment script
- `update.sh` - Update script for future deployments

## Security Features

✅ **HTTPS redirect**: All HTTP traffic redirected to HTTPS
✅ **Security headers**: HSTS, XSS protection, content type sniffing protection  
✅ **Gzip compression**: Faster loading times
✅ **Cache control**: Optimized caching for static assets
✅ **Rate limiting**: Protection against abuse

## Updating Your Application

To update your application:

```bash
# Build locally
npm run build

# Upload to server
rsync -avz dist/ user@yourserver.com:/var/www/terminal-screenshot/

# Or use the included update script
./update.sh yourdomain.com
```

## Monitoring

Check your site status:

```bash
# Check nginx status
sudo systemctl status nginx

# Check nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Check SSL certificate
sudo certbot certificates
```

## Troubleshooting

**SSL certificate issues:**
```bash
sudo certbot renew
sudo systemctl reload nginx
```

**File permissions:**
```bash
sudo chown -R www-data:www-data /var/www/terminal-screenshot/
sudo chmod -R 644 /var/www/terminal-screenshot/
```

**nginx configuration test:**
```bash
sudo nginx -t
```

Your Terminal Screenshot Generator will be available at `https://yourdomain.com`!
