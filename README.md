# Terminal Screenshot Generator

A beautiful, modern web application for creating professional-looking screenshots of terminal output. Perfect for Linux assignments, documentation, presentations, and sharing command-line results.

![Terminal Screenshot Generator](https://img.shields.io/badge/Vue.js-3.x-green.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 🚀 Features

### Core Functionality
- **Real-time Preview**: See your terminal output formatted instantly
- **Multiple Export Formats**: Generate high-quality PNG screenshots
- **Responsive Design**: Works on desktop, tablet, and mobile devices

### Theming & Customization
- **16 Built-in Themes**: Material, Dark, Light, Ubuntu, Matrix, Dracula, Monokai, Solarized, Nord, Gruvbox, One Dark, Cyberpunk, Retro Green, and more
- **Custom Theme Creator**: Design your own color schemes with live preview
- **Theme Import/Export**: Share custom themes with classmates via JSON files

### Typography Options
- **10 Professional Fonts**: JetBrains Mono, Fira Code, Source Code Pro, Consolas, Monaco, Menlo, Roboto Mono, Ubuntu Mono, Inconsolata, Cascadia Code
- **Custom Font Upload**: Support for .woff, .woff2, .ttf, and .otf font files
- **Multiple Font Sizes**: 10px to 18px options

### Smart Parsing
- **Intelligent Output Recognition**: Automatically detects and colors different parts of terminal output
- **File Permission Highlighting**: Colors directory permissions, symlinks, executables, and sticky bits
- **Command Prompt Styling**: Highlights user@host, paths, and commands
- **ls -l Output Formatting**: Perfect alignment and coloring for file listings

### Layout Controls
- **Flexible Sizing**: Manual width/height control or auto-scaling options
- **Custom Terminal Titles**: Personalize your screenshots
- **Professional Window Design**: Mac-style terminal buttons and headers

## 📖 How to Use

### Basic Usage
1. **Paste Your Terminal Output**: Copy and paste your command-line output into the text area
2. **Choose a Theme**: Select from 16 built-in themes or create a custom one
3. **Adjust Settings**: Pick your preferred font, size, and dimensions
4. **Generate Screenshot**: Click "Generate Screenshot" to create a high-quality PNG
5. **Download**: Save the image to your computer

### For Linux Assignments
1. Run your commands in the terminal
2. Copy the output (including the command prompt)
3. Paste into the Terminal Screenshot Generator
4. Choose an appropriate theme (Ubuntu theme recommended for authenticity)
5. Generate and download your screenshot
6. Include in your assignment documentation

### Custom Themes
1. Select "Custom" from the theme dropdown
2. Click "Customize Colors" to open the theme editor
3. Adjust colors for different terminal elements:
   - Terminal background and header
   - Prompt colors (user@host, paths, commands)
   - File permissions and details
   - Directory and symlink names
4. Use quick presets or fine-tune individual colors
5. Export your theme to share with classmates

### Custom Fonts
1. Select "Custom Font" from the font dropdown
2. Click "Choose File" to upload your font (.woff, .woff2, .ttf, .otf)
3. The font will be applied immediately to the preview

## 🛠️ Development Setup

### Prerequisites
- Node.js 16+ and npm
- Modern web browser

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd terminal-screen

# Install dependencies
npm install

# Start development server
npm run dev
```

The application will be available at `http://localhost:3000` (or the next available port).

### Development Commands
```bash
# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint code
npm run lint
```

## 🚀 Deployment

### Building for Production
```bash
# Install dependencies
npm install

# Build the application
npm run build
```

This creates a `dist/` folder with all the static files ready for deployment.

### Deployment Options

#### Option 1: Static Hosting (Recommended)
The built application is purely static and can be hosted on any web server:

**Popular Hosting Services:**
- **GitHub Pages** (Free)
- **Netlify** (Free tier available)
- **Vercel** (Free tier available)
- **Firebase Hosting** (Free tier available)

**Manual Server Deployment:**
1. Build the project: `npm run build`
2. Upload the contents of `dist/` folder to your web server
3. Configure your web server to serve `index.html` for all routes

#### Option 2: Traditional Web Server
For Apache or Nginx servers:

**Apache (.htaccess)**:
```apache
RewriteEngine On
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]
```

**Nginx**:
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

#### Option 3: Docker Deployment
```dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
EXPOSE 80
```

### Environment Configuration
No environment variables required - the application is completely client-side.

## 📋 Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 🤝 Usage for Educational Purposes

This tool is perfect for:
- **Linux System Administration Courses**
- **Command Line Tutorials**
- **Assignment Documentation**
- **Technical Presentations**
- **Code Documentation**

### Best Practices for Assignments
1. Always include the command prompt showing your username and directory
2. Use consistent theming throughout your assignment
3. Choose readable font sizes (12px-14px recommended)
4. Include the full command and its output
5. Consider using the Ubuntu theme for Linux assignments

## 🐛 Troubleshooting

### Common Issues

**Fonts not loading:**
- Ensure you have an internet connection for Google Fonts
- For custom fonts, check the file format is supported (.woff, .woff2, .ttf, .otf)

**Screenshot quality issues:**
- The tool generates 2x resolution images for crisp quality
- Try adjusting the terminal width/height for better composition

**Theme not applying:**
- Refresh the page if custom themes aren't working
- Clear browser cache if issues persist

**Browser compatibility:**
- Use a modern browser (Chrome, Firefox, Safari, Edge)
- Enable JavaScript if disabled

## 📄 License

MIT License - feel free to use this tool for educational and personal purposes.

## 🔧 Technical Details

### Built With
- **Vue.js 3** - Reactive frontend framework
- **Vite** - Fast build tool and development server
- **html2canvas** - Client-side screenshot generation
- **CSS Grid & Flexbox** - Modern responsive layouts
- **Google Fonts** - Professional typography

### Architecture
- **Single Page Application (SPA)** - Fast, responsive user experience
- **Client-side Processing** - No server required, works offline
- **Progressive Enhancement** - Works without JavaScript for basic functionality
- **Responsive Design** - Mobile-friendly interface

---

**Created for educational use in Linux system administration and command-line courses.**
