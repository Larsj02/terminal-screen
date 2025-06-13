# Quick Deployment Guide

## 🚀 Ready to Deploy!

Your Terminal Screenshot Generator is ready for production. Here are the fastest ways to get it online:

### Option 1: GitHub Pages (Free & Easy)
1. Push your code to a GitHub repository
2. Go to repository Settings > Pages
3. Select "GitHub Actions" as source
4. Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install
      - run: npm run build
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
```

### Option 2: Netlify (Free, Super Easy)
1. Go to [netlify.com](https://netlify.com)
2. Drag and drop your `dist` folder
3. Done! Your site is live instantly

### Option 3: Your Own Server
1. Run the build script:
   ```bash
   # Windows
   build.bat
   
   # Linux/Mac
   ./build.sh
   ```
2. Upload everything from the `dist/` folder to your web server
3. Make sure your server serves `index.html` for all routes

### Option 4: Nginx with SSL (Production Server)
1. See `NGINX_DEPLOYMENT.md` for complete setup guide
2. Quick deployment:
   ```bash
   # Make scripts executable
   chmod +x deploy.sh update.sh
   
   # Deploy to your server
   ./deploy.sh yourdomain.com
   
   # Get SSL certificate
   sudo certbot --nginx -d yourdomain.com
   ```

### Option 5: Docker (For Advanced Users)
```bash
# Build and run with Docker
docker build -t terminal-screenshot-generator .
docker run -p 80:80 terminal-screenshot-generator
```

## 📁 What's in the Build?

After running `npm run build`, you'll get a `dist/` folder containing:
- `index.html` - The main application file
- `assets/` - Optimized CSS, JavaScript, and font files
- All dependencies bundled and minified

## 🎯 For Your Class

1. **Host it once**: Deploy to any of the above services
2. **Share the URL**: Give your students the link
3. **No installation needed**: Students just open the website
4. **Works offline**: Once loaded, works without internet

## 🔧 Build Details

- **Total build size**: ~2.5MB (includes all fonts and icons)
- **Gzipped size**: ~140KB (actual download size)
- **Browser support**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+

## ⚡ Performance Tips

The application is already optimized with:
- ✅ Code splitting and tree shaking
- ✅ Asset compression and caching
- ✅ Font optimization
- ✅ Image optimization
- ✅ Progressive loading

Your students will have a fast, smooth experience!

---

**Need help?** Check the main README.md for detailed instructions.
