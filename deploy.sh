#!/bin/bash

# Terminal Screenshot Generator Deployment Script
# Usage: ./deploy.sh yourdomain.com

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 example.com"
    exit 1
fi

DOMAIN=$1
WEB_ROOT="/var/www/terminal-screenshot"
NGINX_CONF="/etc/nginx/sites-available/terminal-screenshot"

echo "🚀 Deploying Terminal Screenshot Generator to $DOMAIN"

# Create web directory
echo "📁 Creating web directory..."
sudo mkdir -p $WEB_ROOT

# Set permissions
echo "🔒 Setting permissions..."
sudo chown -R www-data:www-data $WEB_ROOT
sudo chmod -R 755 $WEB_ROOT

# Copy files
echo "📋 Copying application files..."
if [ -d "dist" ]; then
    sudo cp -r dist/* $WEB_ROOT/
else
    echo "❌ Error: dist directory not found. Run 'npm run build' first."
    exit 1
fi

# Update nginx configuration with domain
echo "⚙️  Setting up nginx configuration..."
sudo cp nginx.conf $NGINX_CONF
sudo sed -i "s/yourdomain.com/$DOMAIN/g" $NGINX_CONF

# Enable site
echo "🔗 Enabling nginx site..."
sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/terminal-screenshot

# Remove default site if it exists
if [ -f "/etc/nginx/sites-enabled/default" ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

# Test nginx configuration
echo "🧪 Testing nginx configuration..."
sudo nginx -t

# Reload nginx
echo "🔄 Reloading nginx..."
sudo systemctl reload nginx

echo "✅ Basic deployment complete!"
echo ""
echo "🔐 To enable SSL with Let's Encrypt, run:"
echo "    sudo certbot --nginx -d $DOMAIN"
echo ""
echo "🌐 Your site should be available at: http://$DOMAIN"
