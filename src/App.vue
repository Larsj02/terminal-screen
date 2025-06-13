<template>
  <div class="app">
    <header class="header">
      <h1>Terminal Screenshot Generator</h1>
      <p>Paste your terminal output below and generate a beautiful screenshot</p>
    </header>

    <div class="content">
      <div class="input-section">
        <h2>Terminal Output</h2>
        <textarea
          v-model="terminalInput"
          placeholder="Paste your terminal output here..."
          class="terminal-input"
          rows="10"
        ></textarea>
        
        <div class="controls">
          <label class="checkbox-label">
            <input type="checkbox" v-model="showTimestamp" />
            Show timestamp
          </label>
            <select v-model="selectedTheme" class="theme-select">
            <option value="dark">Dark Theme</option>
            <option value="light">Light Theme</option>
            <option value="ubuntu">Ubuntu</option>
            <option value="matrix">Matrix</option>
            <option value="dracula">Dracula</option>
            <option value="monokai">Monokai</option>
            <option value="solarized-dark">Solarized Dark</option>
            <option value="solarized-light">Solarized Light</option>
            <option value="nord">Nord</option>
            <option value="gruvbox-dark">Gruvbox Dark</option>
            <option value="gruvbox-light">Gruvbox Light</option>
            <option value="one-dark">One Dark</option>
            <option value="material">Material</option>
            <option value="cyberpunk">Cyberpunk</option>
            <option value="retro">Retro Green</option>          </select>
          
          <div class="font-controls">
            <label style="color: white;">Font Size:</label>
            <select v-model="fontSize" class="font-select">
              <option value="12">12px</option>
              <option value="13">13px</option>
              <option value="14">14px</option>
              <option value="15">15px</option>
              <option value="16">16px</option>
              <option value="18">18px</option>
            </select>
          </div>
          
          <button @click="generateScreenshot" class="generate-btn" :disabled="!terminalInput.trim()">
            Generate Screenshot
          </button>
        </div>
      </div>

      <div class="preview-section">
        <h2>Preview</h2>
        <div 
          ref="terminalPreview" 
          class="terminal-preview" 
          :class="`theme-${selectedTheme}`"
        >
          <div class="terminal-header">
            <div class="terminal-buttons">
              <span class="btn red"></span>
              <span class="btn yellow"></span>
              <span class="btn green"></span>
            </div>
            <div class="terminal-title">Terminal</div>
          </div>          <div class="terminal-content" :style="{ fontSize: fontSize + 'px' }">
            <div v-if="showTimestamp" class="timestamp">
              {{ currentTimestamp }}
            </div>
            <pre v-html="formattedOutput" class="terminal-output" :style="{ fontSize: fontSize + 'px' }"></pre>
          </div>
        </div>
        
        <button 
          v-if="formattedOutput" 
          @click="downloadScreenshot" 
          class="download-btn"
        >
          Download Screenshot
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import html2canvas from 'html2canvas'

export default {
  name: 'App',  data() {
    return {      terminalInput: `lars@DESKTOP-1M2J5TN:~$ ls -ltra /
total 2284
drwxr-xr-x   2 root root    4096 Apr 18  2022 boot
lrwxrwxrwx   1 root root       8 Jan  3  2023 sbin -> usr/sbin
lrwxrwxrwx   1 root root       7 Jan  3  2023 lib -> usr/lib
lrwxrwxrwx   1 root root       7 Jan  3  2023 bin -> usr/bin
lrwxrwxrwx   1 root root      10 Jan  3  2023 libx32 -> usr/libx32
lrwxrwxrwx   1 root root       9 Jan  3  2023 lib64 -> usr/lib64
lrwxrwxrwx   1 root root       9 Jan  3  2023 lib32 -> usr/lib32
drwxr-xr-x   2 root root    4096 Jan  3  2023 srv
drwxr-xr-x   2 root root    4096 Jan  3  2023 opt
drwxr-xr-x   2 root root    4096 Jan  3  2023 media
drwxr-xr-x  14 root root    4096 Jan  3  2023 usr
drwxr-xr-x  13 root root    4096 Jan  3  2023 var
drwxr-xr-x   8 root root    4096 Jan  3  2023 snap
-rwxrwxrwx   1 root root 2260248 Sep 27  2024 init
drwx------   2 root root   16384 Nov 15  2024 lost+found
drwxr-xr-x   5 root root    4096 Nov 15  2024 mnt
drwxr-xr-x   2 root root    4096 Feb 13 23:58 zip
drwxrwxrwt   3 root root    4096 Mar 28 10:09 tmp
drwx------   3 root root    4096 Mar 28 10:38 root
drwxr-xr-x   4 root root    4096 Mar 28 10:43 home
dr-xr-xr-x  11 root root       0 Jun 13 09:45 sys
dr-xr-xr-x 220 root root       0 Jun 13 09:45 proc
drwxr-xr-x  11 root root    3060 Jun 13 09:45 dev
drwxr-xr-x  20 root root    4096 Jun 13 09:45 ..
drwxr-xr-x  20 root root    4096 Jun 13 09:45 .
drwxr-xr-x   7 root root     140 Jun 13 09:45 run
drwxr-xr-x  81 root root    4096 Jun 13 09:45 etc
lars@DESKTOP-1M2J5TN:~$`,
      selectedTheme: 'dark',
      showTimestamp: false,
      fontSize: 14
    }
  },
  computed: {
    currentTimestamp() {
      return new Date().toLocaleString()
    },
    formattedOutput() {
      if (!this.terminalInput.trim()) return ''
      
      return this.parseTerminalOutput(this.terminalInput)
    }
  },
  methods: {
    parseTerminalOutput(text) {
      // Split into lines
      const lines = text.split('\n')
      let formatted = ''
      
      for (const line of lines) {
        if (line.includes('@') && line.includes('$')) {
          // This is a prompt line
          formatted += this.formatPromptLine(line)
        } else if (line.startsWith('total ')) {
          // Total line in ls output
          formatted += `<span class="total-line">${this.escapeHtml(line)}</span>\n`        } else if (line.match(/^[dl-]/)) {
          // Any line starting with d, l, or -
          formatted += this.formatPermissionLine(line)
        } else {
          // Regular line
          formatted += `<span class="regular-line">${this.escapeHtml(line)}</span>\n`
        }
      }
      
      return formatted
    },
    
    formatPromptLine(line) {
      // Match user@hostname:path$ pattern
      const promptMatch = line.match(/^([^@]+@[^:]+):([^$]+)\$(.*)$/)
      if (promptMatch) {
        const [, userHost, path, command] = promptMatch
        return `<span class="prompt-user">${this.escapeHtml(userHost)}</span><span class="prompt-separator">:</span><span class="prompt-path">${this.escapeHtml(path)}</span><span class="prompt-dollar">$</span><span class="command">${this.escapeHtml(command)}</span>\n`
      }
      return `<span class="prompt-line">${this.escapeHtml(line)}</span>\n`
    },    formatPermissionLine(line) {
      // Debug: Check if this is the tmp line
      if (line.includes('tmp')) {
        console.log('Processing tmp line:', line)
        console.log('Line parts:', line.trim().split(/\s+/))
      }
      
      // Parse ls -l output with more precise regex for the exact format
      // Format: permissions linkcount user group size month day year/time filename
      const parts = line.trim().split(/\s+/)
        if (parts.length >= 8) {
        const permissions = parts[0]
        const linkCount = parts[1]
        const user = parts[2]
        const group = parts[3]
        const size = parts[4]
        const month = parts[5]
        const day = parts[6]
        const timeOrYear = parts[7]
        const filename = parts.slice(8).join(' ')
        
        // Debug for tmp line
        if (filename === 'tmp') {
          console.log('tmp line - parts[0] (permissions):', JSON.stringify(permissions))
          console.log('tmp line - permissions.length:', permissions.length)
          console.log('tmp line - all parts:', parts)
        }
        
        let permClass = 'file'
        let displayFilename = filename        // Determine file type and format filename accordingly
        if (permissions.startsWith('d')) {
          permClass = 'directory'
          displayFilename = this.escapeHtml(filename)
        } else if (permissions.startsWith('l')) {
          permClass = 'symlink'
          // Handle symlink display with arrow
          if (filename.includes(' -> ')) {
            const [linkName, target] = filename.split(' -> ')
            displayFilename = `<span class="symlink-name">${this.escapeHtml(linkName)}</span> <span class="symlink-arrow">-></span> <span class="symlink-target">${this.escapeHtml(target)}</span>`
          } else {
            displayFilename = `<span class="symlink-name">${this.escapeHtml(filename)}</span>`
          }
        } else {
          displayFilename = this.escapeHtml(filename)        }
        
        // Create formatted date string
        const datetime = `${month} ${day} ${timeOrYear}`
        
        // Use fixed-width spans to maintain perfect alignment
        const permissionClass = this.getPermissionClass(permissions)
        if (filename === 'tmp') {
          console.log('tmp final - permissions:', permissions, 'class:', permissionClass)
          console.log('tmp permissions details:', {
            permissions,
            length: permissions.length,
            charAtIndex9: permissions.charAt(9),
            startsWithD: permissions.startsWith('d')
          })
          console.log('Expected sticky bit detection result:', 
            permissions.startsWith('d') && 
            permissions.length === 10 && 
            (permissions.charAt(9) === 't' || permissions.charAt(9) === 'T')
          )
        }
        return `<span class="permissions ${permissionClass}" style="display: inline-block; width: 12ch;">${permissions}</span><span class="link-count" style="display: inline-block; width: 4ch; text-align: right;">${linkCount}</span> <span class="user" style="display: inline-block; width: 9ch;">${user}</span> <span class="group" style="display: inline-block; width: 9ch;">${group}</span> <span class="size" style="display: inline-block; width: 10ch; text-align: right;">${size}</span> <span class="date" style="display: inline-block; width: 14ch;">${datetime}</span> <span class="filename ${permClass}">${displayFilename}</span>\n`
      }
      
      // Fallback for unrecognized format
      return `<span class="regular-line">${this.escapeHtml(line)}</span>\n`
    },    getPermissionClass(permissions) {
      if (permissions.startsWith('d')) {
        // Check for sticky bit (t at the end) - permissions are 10 chars: drwxrwxrwt
        if (permissions.length === 10 && (permissions.charAt(9) === 't' || permissions.charAt(9) === 'T')) {
          return 'sticky-dir-perm'
        }
        return 'dir-perm'
      }
      if (permissions.startsWith('l')) return 'link-perm' 
      if (permissions.startsWith('-') && permissions.includes('x')) return 'exec-perm'
      return 'file-perm'
    },
    
    escapeHtml(text) {
      const div = document.createElement('div')
      div.textContent = text
      return div.innerHTML
    },
    
    async generateScreenshot() {
      if (!this.$refs.terminalPreview) return
      
      try {
        const canvas = await html2canvas(this.$refs.terminalPreview, {
          backgroundColor: null,
          scale: 2,
          useCORS: true
        })
        
        // You can use the canvas here - for now we'll just trigger download
        this.downloadScreenshot()
      } catch (error) {
        console.error('Error generating screenshot:', error)
        alert('Error generating screenshot. Please try again.')
      }
    },
    
    async downloadScreenshot() {
      if (!this.$refs.terminalPreview) return
      
      try {
        const canvas = await html2canvas(this.$refs.terminalPreview, {
          backgroundColor: null,
          scale: 2,
          useCORS: true
        })
        
        // Create download link
        const link = document.createElement('a')
        link.download = `terminal-screenshot-${Date.now()}.png`
        link.href = canvas.toDataURL('image/png')
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
      } catch (error) {
        console.error('Error downloading screenshot:', error)
        alert('Error downloading screenshot. Please try again.')
      }
    }
  }
}
</script>

<style scoped>
.app {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.header {
  text-align: center;
  margin-bottom: 30px;
  color: white;
}

.header h1 {
  font-size: 2.5rem;
  margin-bottom: 10px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
}

.content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  max-width: 1400px;
  margin: 0 auto;
}

.input-section, .preview-section {
  background: rgba(255, 255, 255, 0.1);
  padding: 25px;
  border-radius: 15px;
  backdrop-filter: blur(10px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.input-section h2, .preview-section h2 {
  color: white;
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 1.5rem;
}

.terminal-input {
  width: 100%;
  height: 300px;
  background: #1e1e1e;
  color: #00ff00;
  border: 2px solid #333;
  border-radius: 8px;
  padding: 15px;
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.4;
  resize: vertical;
  box-sizing: border-box;
}

.terminal-input:focus {
  outline: none;
  border-color: #00ff00;
  box-shadow: 0 0 10px rgba(0, 255, 0, 0.3);
}

.controls {
  display: flex;
  gap: 15px;
  align-items: center;
  margin-top: 15px;
  flex-wrap: wrap;
}

.checkbox-label {
  color: white;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.theme-select, .font-select {
  padding: 8px 12px;
  border-radius: 6px;
  border: 1px solid #ccc;
  background: white;
  font-size: 14px;
}

.font-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.font-controls label {
  font-size: 14px;
}

.generate-btn, .download-btn {
  padding: 10px 20px;
  background: linear-gradient(45deg, #00ff00, #00cc00);
  color: black;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: bold;
  font-size: 14px;
  transition: all 0.3s ease;
}

.generate-btn:hover, .download-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 255, 0, 0.3);
}

.generate-btn:disabled {
  background: #666;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.download-btn {
  margin-top: 15px;
  width: 100%;
  background: linear-gradient(45deg, #4CAF50, #45a049);
  color: white;
}

.terminal-preview {
  background: #1e1e1e;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  margin-bottom: 15px;
}

.terminal-header {
  background: #333;
  padding: 10px 15px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.terminal-buttons {
  display: flex;
  gap: 8px;
}

.btn {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.btn.red { background: #ff5f57; }
.btn.yellow { background: #ffbd2e; }
.btn.green { background: #28ca42; }

.terminal-title {
  color: #ccc;
  font-size: 14px;
  font-weight: 500;
}

.terminal-content {
  padding: 20px;
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.4;
  background: #1e1e1e;
  color: #ffffff;
  min-height: 200px;
}

.terminal-output {
  margin: 0;
  white-space: pre;
  font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
  font-size: 14px;
  line-height: 1.4;
  letter-spacing: 0;
  word-spacing: 0;
}

.timestamp {
  color: #888;
  font-size: 12px;
  margin-bottom: 10px;
  border-bottom: 1px solid #333;
  padding-bottom: 5px;
}

/* Theme-specific styles */
.theme-dark .terminal-content {
  background: #1e1e1e;
  color: #ffffff;
}

.theme-light .terminal-content {
  background: #ffffff;
  color: #000000;
}

.theme-light .terminal-header {
  background: #f0f0f0;
}

.theme-ubuntu .terminal-content {
  background: #300a24;
  color: #ffffff;
}

.theme-ubuntu .terminal-header {
  background: #2c001e;
}

.theme-matrix .terminal-content {
  background: #000000;
  color: #00ff00;
}

.theme-matrix .terminal-header {
  background: #001100;
}

.theme-dracula .terminal-content {
  background: #282a36;
  color: #f8f8f2;
}

.theme-dracula .terminal-header {
  background: #44475a;
}

.theme-monokai .terminal-content {
  background: #272822;
  color: #f8f8f2;
}

.theme-monokai .terminal-header {
  background: #3e3d32;
}

.theme-solarized-dark .terminal-content {
  background: #002b36;
  color: #839496;
}

.theme-solarized-dark .terminal-header {
  background: #073642;
}

.theme-solarized-light .terminal-content {
  background: #fdf6e3;
  color: #657b83;
}

.theme-solarized-light .terminal-header {
  background: #eee8d5;
}

.theme-nord .terminal-content {
  background: #2e3440;
  color: #d8dee9;
}

.theme-nord .terminal-header {
  background: #3b4252;
}

.theme-gruvbox-dark .terminal-content {
  background: #282828;
  color: #ebdbb2;
}

.theme-gruvbox-dark .terminal-header {
  background: #3c3836;
}

.theme-gruvbox-light .terminal-content {
  background: #fbf1c7;
  color: #3c3836;
}

.theme-gruvbox-light .terminal-header {
  background: #f2e5bc;
}

.theme-one-dark .terminal-content {
  background: #21252b;
  color: #abb2bf;
}

.theme-one-dark .terminal-header {
  background: #2c313c;
}

.theme-material .terminal-content {
  background: #263238;
  color: #eeffff;
}

.theme-material .terminal-header {
  background: #37474f;
}

.theme-cyberpunk .terminal-content {
  background: #0a0a0a;
  color: #00ff41;
  text-shadow: 0 0 5px #00ff41;
}

.theme-cyberpunk .terminal-header {
  background: #1a0033;
}

.theme-retro .terminal-content {
  background: #000000;
  color: #33ff33;
  font-family: 'Courier New', monospace;
  text-shadow: 0 0 10px #33ff33;
}

.theme-retro .terminal-header {
  background: #003300;
}

/* Terminal output styling */
:deep(.prompt-user) { color: #00ff00; font-weight: bold; }
:deep(.prompt-separator) { color: #ffffff; }
:deep(.prompt-path) { color: #0080ff; font-weight: bold; }
:deep(.prompt-dollar) { color: #ffffff; font-weight: bold; }
:deep(.command) { color: #ffffff; }

:deep(.total-line) { color: #888888; }

:deep(.permissions.dir-perm) { color: #00ffff; font-weight: bold; }
:deep(.permissions.sticky-dir-perm) { color: #ffff00; font-weight: bold; background-color: rgba(255, 255, 0, 0.1); }
:deep(.permissions.link-perm) { color: #ff00ff; font-weight: bold; }
:deep(.permissions.exec-perm) { color: #00ff00; font-weight: bold; }
:deep(.permissions.file-perm) { color: #ffffff; }

/* Special styling for sticky bit directories like /tmp */
:deep(.permissions.dir-perm:contains("t")) { color: #ffff00; font-weight: bold; }

:deep(.link-count) { color: #888888; }
:deep(.user) { color: #ffff00; }
:deep(.group) { color: #ffff00; }
:deep(.size) { color: #00ffff; }
:deep(.date) { color: #888888; }

:deep(.filename.directory) { color: #0080ff; font-weight: bold; }
:deep(.filename.symlink) { color: #ff00ff; font-weight: bold; }
:deep(.filename.file) { color: #ffffff; }

/* Symlink-specific styling */
:deep(.symlink-name) { color: #00ffff; font-weight: bold; }
:deep(.symlink-arrow) { color: #ffffff; }
:deep(.symlink-target) { color: #ffff00; font-style: italic; }

/* Theme-specific color overrides */
.theme-light :deep(.prompt-user) { color: #008000; }
.theme-light :deep(.prompt-path) { color: #0000ff; }
.theme-light :deep(.filename.directory) { color: #0000ff; }
.theme-light :deep(.permissions.dir-perm) { color: #008080; }
.theme-light :deep(.permissions.sticky-dir-perm) { color: #b8860b; }
.theme-light :deep(.symlink-name) { color: #008080; }
.theme-light :deep(.symlink-target) { color: #b8860b; }

.theme-ubuntu :deep(.prompt-user) { color: #8ae234; }
.theme-ubuntu :deep(.prompt-path) { color: #729fcf; }
.theme-ubuntu :deep(.permissions.sticky-dir-perm) { color: #fcaf3e; }
.theme-ubuntu :deep(.symlink-name) { color: #ad7fa8; }
.theme-ubuntu :deep(.symlink-target) { color: #fcaf3e; }

.theme-matrix :deep(.prompt-user) { color: #00ff00; }
.theme-matrix :deep(.prompt-path) { color: #00aa00; }
.theme-matrix :deep(.filename.directory) { color: #00ff00; }
.theme-matrix :deep(.permissions.sticky-dir-perm) { color: #88ff88; }
.theme-matrix :deep(.symlink-name) { color: #00ff00; }
.theme-matrix :deep(.symlink-target) { color: #88ff88; }

.theme-dracula :deep(.prompt-user) { color: #50fa7b; }
.theme-dracula :deep(.prompt-path) { color: #8be9fd; }
.theme-dracula :deep(.filename.directory) { color: #8be9fd; }
.theme-dracula :deep(.permissions.dir-perm) { color: #bd93f9; }
.theme-dracula :deep(.permissions.sticky-dir-perm) { color: #f1fa8c; }
.theme-dracula :deep(.symlink-name) { color: #ff79c6; }
.theme-dracula :deep(.symlink-target) { color: #f1fa8c; }

.theme-monokai :deep(.prompt-user) { color: #a6e22e; }
.theme-monokai :deep(.prompt-path) { color: #66d9ef; }
.theme-monokai :deep(.filename.directory) { color: #66d9ef; }
.theme-monokai :deep(.permissions.dir-perm) { color: #ae81ff; }
.theme-monokai :deep(.permissions.sticky-dir-perm) { color: #e6db74; }
.theme-monokai :deep(.symlink-name) { color: #f92672; }
.theme-monokai :deep(.symlink-target) { color: #e6db74; }

.theme-solarized-dark :deep(.prompt-user) { color: #859900; }
.theme-solarized-dark :deep(.prompt-path) { color: #268bd2; }
.theme-solarized-dark :deep(.filename.directory) { color: #268bd2; }
.theme-solarized-dark :deep(.permissions.dir-perm) { color: #2aa198; }
.theme-solarized-dark :deep(.permissions.sticky-dir-perm) { color: #b58900; }
.theme-solarized-dark :deep(.symlink-name) { color: #d33682; }
.theme-solarized-dark :deep(.symlink-target) { color: #b58900; }

.theme-solarized-light :deep(.prompt-user) { color: #859900; }
.theme-solarized-light :deep(.prompt-path) { color: #268bd2; }
.theme-solarized-light :deep(.filename.directory) { color: #268bd2; }
.theme-solarized-light :deep(.permissions.dir-perm) { color: #2aa198; }
.theme-solarized-light :deep(.permissions.sticky-dir-perm) { color: #b58900; }
.theme-solarized-light :deep(.symlink-name) { color: #d33682; }
.theme-solarized-light :deep(.symlink-target) { color: #b58900; }

.theme-nord :deep(.prompt-user) { color: #a3be8c; }
.theme-nord :deep(.prompt-path) { color: #81a1c1; }
.theme-nord :deep(.filename.directory) { color: #81a1c1; }
.theme-nord :deep(.permissions.dir-perm) { color: #b48ead; }
.theme-nord :deep(.permissions.sticky-dir-perm) { color: #ebcb8b; }
.theme-nord :deep(.symlink-name) { color: #bf616a; }
.theme-nord :deep(.symlink-target) { color: #ebcb8b; }

.theme-gruvbox-dark :deep(.prompt-user) { color: #b8bb26; }
.theme-gruvbox-dark :deep(.prompt-path) { color: #83a598; }
.theme-gruvbox-dark :deep(.filename.directory) { color: #83a598; }
.theme-gruvbox-dark :deep(.permissions.dir-perm) { color: #d3869b; }
.theme-gruvbox-dark :deep(.permissions.sticky-dir-perm) { color: #fabd2f; }
.theme-gruvbox-dark :deep(.symlink-name) { color: #fb4934; }
.theme-gruvbox-dark :deep(.symlink-target) { color: #fabd2f; }

.theme-gruvbox-light :deep(.prompt-user) { color: #79740e; }
.theme-gruvbox-light :deep(.prompt-path) { color: #076678; }
.theme-gruvbox-light :deep(.filename.directory) { color: #076678; }
.theme-gruvbox-light :deep(.permissions.dir-perm) { color: #8f3f71; }
.theme-gruvbox-light :deep(.permissions.sticky-dir-perm) { color: #b57614; }
.theme-gruvbox-light :deep(.symlink-name) { color: #9d0006; }
.theme-gruvbox-light :deep(.symlink-target) { color: #b57614; }

.theme-one-dark :deep(.prompt-user) { color: #98c379; }
.theme-one-dark :deep(.prompt-path) { color: #61afef; }
.theme-one-dark :deep(.filename.directory) { color: #61afef; }
.theme-one-dark :deep(.permissions.dir-perm) { color: #c678dd; }
.theme-one-dark :deep(.permissions.sticky-dir-perm) { color: #e5c07b; }
.theme-one-dark :deep(.symlink-name) { color: #e06c75; }
.theme-one-dark :deep(.symlink-target) { color: #e5c07b; }

.theme-material :deep(.prompt-user) { color: #c3e88d; }
.theme-material :deep(.prompt-path) { color: #82aaff; }
.theme-material :deep(.filename.directory) { color: #82aaff; }
.theme-material :deep(.permissions.dir-perm) { color: #c792ea; }
.theme-material :deep(.permissions.sticky-dir-perm) { color: #ffcb6b; }
.theme-material :deep(.symlink-name) { color: #f07178; }
.theme-material :deep(.symlink-target) { color: #ffcb6b; }

.theme-cyberpunk :deep(.prompt-user) { color: #ff0080; }
.theme-cyberpunk :deep(.prompt-path) { color: #00ffff; }
.theme-cyberpunk :deep(.filename.directory) { color: #00ffff; }
.theme-cyberpunk :deep(.permissions.dir-perm) { color: #ff00ff; }
.theme-cyberpunk :deep(.permissions.sticky-dir-perm) { color: #80ff00; }
.theme-cyberpunk :deep(.symlink-name) { color: #ff4080; }
.theme-cyberpunk :deep(.symlink-target) { color: #80ff00; }

.theme-retro :deep(.prompt-user) { color: #33ff33; }
.theme-retro :deep(.prompt-path) { color: #66ff66; }
.theme-retro :deep(.filename.directory) { color: #66ff66; }
.theme-retro :deep(.permissions.dir-perm) { color: #99ff99; }
.theme-retro :deep(.permissions.sticky-dir-perm) { color: #ccff99; }
.theme-retro :deep(.symlink-name) { color: #66ff66; }
.theme-retro :deep(.symlink-target) { color: #ccff99; }

@media (max-width: 768px) {
  .content {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .header h1 {
    font-size: 2rem;
  }
  
  .controls {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
