@echo off
REM Terminal Screenshot Generator Build Script for Windows
REM This script builds the application for production deployment

echo 🔧 Building Terminal Screenshot Generator for production...

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js 16+ first.
    exit /b 1
)

REM Check if npm is installed
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not installed. Please install npm first.
    exit /b 1
)

REM Install dependencies
echo 📦 Installing dependencies...
npm install

if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies.
    exit /b 1
)

REM Build the application
echo 🏗️  Building application...
npm run build

if %errorlevel% neq 0 (
    echo ❌ Build failed.
    exit /b 1
)

echo ✅ Build completed successfully!
echo 📁 Built files are in the 'dist' directory
echo.
echo 🚀 Deployment options:
echo 1. Upload the contents of 'dist/' to your web server
echo 2. Use a static hosting service (GitHub Pages, Netlify, Vercel)
echo 3. Run 'npm run preview' to test the build locally
echo.
echo 📖 See README.md for detailed deployment instructions

pause
