#!/bin/bash

# Terminal Screenshot Generator Update Script
# Usage: ./update.sh [domain]

set -e

DOMAIN=${1:-""}
WEB_ROOT="/var/www/terminal-screenshot"

echo "🔄 Updating Terminal Screenshot Generator..."

# Build the application
echo "🏗️  Building application..."
npm install
npm run build

# Backup current version
echo "💾 Creating backup..."
sudo cp -r $WEB_ROOT $WEB_ROOT.backup.$(date +%Y%m%d_%H%M%S)

# Update files
echo "📋 Updating application files..."
sudo cp -r dist/* $WEB_ROOT/

# Set permissions
echo "🔒 Setting permissions..."
sudo chown -R www-data:www-data $WEB_ROOT
sudo chmod -R 755 $WEB_ROOT

# Test nginx configuration
echo "🧪 Testing nginx configuration..."
sudo nginx -t

# Reload nginx (graceful restart)
echo "🔄 Reloading nginx..."
sudo systemctl reload nginx

echo "✅ Update complete!"

if [ ! -z "$DOMAIN" ]; then
    echo "🌐 Your updated site is available at: https://$DOMAIN"
else
    echo "🌐 Your updated site is now live!"
fi

echo ""
echo "📊 Check status with:"
echo "    sudo systemctl status nginx"
echo "    sudo tail -f /var/log/nginx/terminal-screenshot.access.log"
