#!/bin/bash

# Terminal Screenshot Generator Build Script
# This script builds the application for production deployment

echo "🔧 Building Terminal Screenshot Generator for production..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies."
    exit 1
fi

# Build the application
echo "🏗️  Building application..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed."
    exit 1
fi

echo "✅ Build completed successfully!"
echo "📁 Built files are in the 'dist' directory"
echo ""
echo "🚀 Deployment options:"
echo "1. Upload the contents of 'dist/' to your web server"
echo "2. Use a static hosting service (GitHub Pages, Netlify, Vercel)"
echo "3. Run 'npm run preview' to test the build locally"
echo ""
echo "📖 See README.md for detailed deployment instructions"
