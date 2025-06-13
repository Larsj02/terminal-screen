<template>
  <div class="app">
    <div class="app-container">
      <!-- Header -->
      <header class="header">
        <div class="header-content">
          <div class="header-icon">
            <i class="mdi mdi-monitor-screenshot"></i>
          </div>
          <div class="header-text">
            <h1>Terminal Screenshot Generator</h1>
            <p>Create beautiful screenshots of your terminal output</p>
          </div>
        </div>
      </header>

      <!-- Main Content -->
      <main class="main-content">
        <!-- Input Section -->
        <section class="input-card">
          <div class="card-header">
            <h2><i class="mdi mdi-console"></i> Terminal Input</h2>
          </div>
          <div class="card-content">
            <div class="input-field">
              <textarea
                v-model="terminalInput"
                placeholder="Paste your terminal output here..."
                class="terminal-input"
                rows="12"
              ></textarea>
            </div>            <div class="controls-grid">
              <div class="control-group title-group">
                <label class="control-label">
                  <i class="mdi mdi-format-title"></i>
                  Terminal Title
                </label>
                <input 
                  type="text" 
                  v-model="terminalTitle" 
                  class="text-input"
                  placeholder="Terminal"
                />
              </div>
                <div class="control-group">
                <label class="control-label">
                  <i class="mdi mdi-palette"></i>
                  Theme
                </label>                <select v-model="selectedTheme" class="select-input">
                  <option value="material">Material</option>
                  <option value="dark">Dark</option>
                  <option value="light">Light</option>
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
                  <option value="cyberpunk">Cyberpunk</option>
                  <option value="retro">Retro Green</option>
                  <option value="custom">Custom</option>
                </select>
              </div>              <div class="control-group">
                <label class="control-label">
                  <i class="mdi mdi-format-size"></i>
                  Font Size
                </label>
                <select v-model="fontSize" class="select-input">
                  <option value="10">10px</option>
                  <option value="11">11px</option>
                  <option value="12">12px</option>
                  <option value="13">13px</option>
                  <option value="14">14px</option>
                  <option value="15">15px</option>
                  <option value="16">16px</option>
                  <option value="18">18px</option>
                </select>
              </div>
              
              <div class="customize-colors-group" v-if="selectedTheme === 'custom'">
                <button 
                  @click="openCustomThemeModal" 
                  class="btn btn-secondary"
                >
                  <i class="mdi mdi-palette"></i>
                  Customize Colors
                </button>
              </div>
              
              <div class="control-group">
                <label class="control-label">
                  <i class="mdi mdi-resize"></i>
                  Width (px)
                </label>
                <input 
                  type="number" 
                  v-model.number="terminalWidth" 
                  class="number-input"
                  min="300"
                  max="1200"
                  step="50"
                  :disabled="autoScaleWidth"
                />
              </div>
              
              <div class="control-group">
                <label class="control-label">
                  <i class="mdi mdi-resize"></i>
                  Height (px)
                </label>
                <input 
                  type="number" 
                  v-model.number="terminalHeight" 
                  class="number-input"
                  min="200"
                  max="800"
                  step="50"
                  :disabled="autoScaleHeight"
                />
              </div>
              
              <div class="control-group">
                <label class="control-label">
                  <i class="mdi mdi-arrow-expand-horizontal"></i>
                  Auto-scale width
                </label>
                <div class="toggle-switch">
                  <input type="checkbox" v-model="autoScaleWidth" id="autoscale-width-toggle" />
                  <label for="autoscale-width-toggle" class="toggle-label"></label>
                </div>
              </div>
              
              <div class="control-group">
                <label class="control-label">
                  <i class="mdi mdi-arrow-expand-vertical"></i>
                  Auto-scale height
                </label>
                <div class="toggle-switch">
                  <input type="checkbox" v-model="autoScaleHeight" id="autoscale-height-toggle" />
                  <label for="autoscale-height-toggle" class="toggle-label"></label>
                </div>
              </div>
              
              <div class="control-group action-group">
                <button 
                  @click="generateScreenshot" 
                  class="btn btn-primary"
                  :disabled="!terminalInput.trim()"
                >
                  <i class="mdi mdi-camera"></i>
                  Generate Screenshot
                </button>
              </div>
            </div>
          </div>
        </section>

        <!-- Preview Section -->
        <section class="preview-card">
          <div class="card-header">
            <h2><i class="mdi mdi-eye"></i> Preview</h2>
          </div>
          <div class="card-content">            <div class="terminal-container">
              <div 
                ref="terminalPreview" 
                class="terminal-preview" 
                :class="`theme-${selectedTheme}`"
                :style="terminalStyles"
              ><div class="terminal-header">
                  <div class="terminal-buttons">
                    <span class="window-btn red"></span>
                    <span class="window-btn yellow"></span>
                    <span class="window-btn green"></span>
                  </div>
                  <div class="terminal-title">{{ terminalTitle }}</div>
                </div>                <div class="terminal-content" :style="terminalContentStyles">
                  <pre v-html="formattedOutput" class="terminal-output" :style="{ fontSize: fontSize + 'px' }"></pre>
                </div>
              </div>
            </div>
            
            <div v-if="formattedOutput" class="actions">
              <button 
                @click="downloadScreenshot" 
                class="btn btn-success"
              >
                <i class="mdi mdi-download"></i>
                Download Screenshot
              </button>
            </div>
          </div>
        </section>      </main>
    </div>

    <!-- Custom Theme Modal -->
    <div v-if="showCustomThemeModal" class="modal-overlay" @click="closeCustomThemeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3><i class="mdi mdi-palette"></i> Customize Theme Colors</h3>
          <button @click="closeCustomThemeModal" class="btn-close">
            <i class="mdi mdi-close"></i>
          </button>
        </div>
          <div class="modal-body">
          <div class="preset-themes">
            <h4>Quick Presets</h4>
            <div class="preset-buttons">
              <button @click="applyPreset('dark')" class="btn-preset">Dark Terminal</button>
              <button @click="applyPreset('light')" class="btn-preset">Light Terminal</button>
              <button @click="applyPreset('matrix')" class="btn-preset">Matrix Green</button>
              <button @click="applyPreset('cyberpunk')" class="btn-preset">Cyberpunk</button>
              <button @click="applyPreset('dracula')" class="btn-preset">Dracula</button>
              <button @click="applyPreset('monokai')" class="btn-preset">Monokai</button>
            </div>
          </div>
          
          <div class="color-sections">
            <!-- Terminal Background -->
            <div class="color-section">
              <h4>Terminal Background</h4>
              <div class="color-controls">                <div class="color-control">
                  <label>Background</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.terminalBackground" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.terminalBackground" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Header Background</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.terminalHeaderBackground" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.terminalHeaderBackground" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Default Text</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.defaultText" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.defaultText" 
                      class="color-text-input"
                    />
                  </div>
                </div>
              </div>
            </div>

            <!-- Prompt Colors -->
            <div class="color-section">
              <h4>Prompt Colors</h4>
              <div class="color-controls">                <div class="color-control">
                  <label>User@Host</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.promptUser" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.promptUser" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Path</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.promptPath" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.promptPath" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Command</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.command" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.command" 
                      class="color-text-input"
                    />
                  </div>
                </div>
              </div>
            </div>            <!-- File Permissions -->
            <div class="color-section">
              <h4>File Permissions</h4>
              <div class="color-controls">
                <div class="color-control">
                  <label>Directory</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.directoryPerm" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.directoryPerm" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Sticky Directory</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.stickyDirPerm" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.stickyDirPerm" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Symlink</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.symlinkPerm" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.symlinkPerm" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Executable</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.execPerm" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.execPerm" 
                      class="color-text-input"
                    />
                  </div>
                </div>
              </div>
            </div>

            <!-- File Details -->
            <div class="color-section">
              <h4>File Details</h4>
              <div class="color-controls">
                <div class="color-control">
                  <label>User</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.user" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.user" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Group</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.group" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.group" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Size</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.size" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.size" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Date</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.date" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.date" 
                      class="color-text-input"
                    />
                  </div>
                </div>
              </div>
            </div>

            <!-- Filenames -->
            <div class="color-section">
              <h4>Filenames</h4>
              <div class="color-controls">
                <div class="color-control">
                  <label>Directory Name</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.directoryName" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.directoryName" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Symlink Name</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.symlinkName" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.symlinkName" 
                      class="color-text-input"
                    />
                  </div>
                </div>
                <div class="color-control">
                  <label>Symlink Target</label>
                  <div class="color-input-group">
                    <input 
                      type="color" 
                      v-model="customTheme.symlinkTarget" 
                      class="color-input"
                    />
                    <input 
                      type="text" 
                      v-model="customTheme.symlinkTarget" 
                      class="color-text-input"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
          <div class="modal-footer">
          <div class="footer-left">
            <button @click="exportCustomTheme" class="btn btn-secondary">
              <i class="mdi mdi-download"></i>
              Export Theme
            </button>
            <label class="btn btn-secondary file-input-wrapper">
              <i class="mdi mdi-upload"></i>
              Import Theme
              <input 
                type="file" 
                @change="importCustomTheme" 
                accept=".json"
                class="file-input"
                ref="fileInput"
              />
            </label>
          </div>
          <div class="footer-right">
            <button @click="resetCustomTheme" class="btn btn-secondary">
              <i class="mdi mdi-restart"></i>
              Reset to Default
            </button>
            <button @click="closeCustomThemeModal" class="btn btn-primary">
              <i class="mdi mdi-check"></i>
              Apply Colors
            </button>
          </div>
        </div>
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
lars@DESKTOP-1M2J5TN:~$`,      selectedTheme: 'material',
      terminalTitle: 'Terminal',
      fontSize: 12,
      terminalWidth: 600,
      terminalHeight: 400,
      autoScaleWidth: false,
      autoScaleHeight: false,
      showCustomThemeModal: false,
      customTheme: {
        terminalBackground: '#0d1117',
        terminalHeaderBackground: '#161b22',
        defaultText: '#e6edf3',
        promptUser: '#00ff00',
        promptPath: '#0080ff',
        command: '#ffffff',
        directoryPerm: '#00ffff',
        stickyDirPerm: '#ffff00',
        symlinkPerm: '#ff00ff',
        execPerm: '#00ff00',
        user: '#ffff00',
        group: '#ffff00',
        size: '#00ffff',
        date: '#888888',
        directoryName: '#0080ff',
        symlinkName: '#00ffff',
        symlinkTarget: '#ffff00'
      }
    }
  },computed: {
    formattedOutput() {
      if (!this.terminalInput.trim()) return ''
      
      return this.parseTerminalOutput(this.terminalInput)
    },terminalStyles() {
      const styles = {}
      
      if (this.autoScaleWidth) {
        styles.width = 'auto'
        styles.minWidth = 'fit-content'
      } else {
        styles.width = `${this.terminalWidth}px`
        styles.minWidth = `${this.terminalWidth}px`
      }
      
      // Apply custom theme styles when custom theme is selected
      if (this.selectedTheme === 'custom') {
        styles['--custom-terminal-bg'] = this.customTheme.terminalBackground
        styles['--custom-terminal-header-bg'] = this.customTheme.terminalHeaderBackground
        styles['--custom-default-text'] = this.customTheme.defaultText
        styles['--custom-prompt-user'] = this.customTheme.promptUser
        styles['--custom-prompt-path'] = this.customTheme.promptPath
        styles['--custom-command'] = this.customTheme.command
        styles['--custom-directory-perm'] = this.customTheme.directoryPerm
        styles['--custom-sticky-dir-perm'] = this.customTheme.stickyDirPerm
        styles['--custom-symlink-perm'] = this.customTheme.symlinkPerm
        styles['--custom-exec-perm'] = this.customTheme.execPerm
        styles['--custom-user'] = this.customTheme.user
        styles['--custom-group'] = this.customTheme.group
        styles['--custom-size'] = this.customTheme.size
        styles['--custom-date'] = this.customTheme.date
        styles['--custom-directory-name'] = this.customTheme.directoryName
        styles['--custom-symlink-name'] = this.customTheme.symlinkName
        styles['--custom-symlink-target'] = this.customTheme.symlinkTarget
      }
      
      return styles
    },terminalContentStyles() {
      const baseStyles = {
        fontSize: this.fontSize + 'px'
      }
      
      if (this.autoScaleHeight) {
        return {
          ...baseStyles,
          height: 'auto',
          minHeight: '200px',
          overflow: 'visible',
          whiteSpace: this.autoScaleWidth ? 'pre' : 'pre-wrap'
        }
      } else {
        return {
          ...baseStyles,
          height: `${this.terminalHeight - 50}px`, // Subtract header height
          minHeight: `${this.terminalHeight - 50}px`,
          overflow: 'auto',
          whiteSpace: this.autoScaleWidth ? 'pre' : 'pre-wrap'
        }
      }
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
      } catch (error) {        console.error('Error downloading screenshot:', error)
        alert('Error downloading screenshot. Please try again.')
      }
    },

    openCustomThemeModal() {
      this.showCustomThemeModal = true
    },

    closeCustomThemeModal() {
      this.showCustomThemeModal = false
    },    resetCustomTheme() {
      this.customTheme = {
        terminalBackground: '#0d1117',
        terminalHeaderBackground: '#161b22',
        defaultText: '#e6edf3',
        promptUser: '#00ff00',
        promptPath: '#0080ff',
        command: '#ffffff',
        directoryPerm: '#00ffff',
        stickyDirPerm: '#ffff00',
        symlinkPerm: '#ff00ff',
        execPerm: '#00ff00',
        user: '#ffff00',
        group: '#ffff00',
        size: '#00ffff',
        date: '#888888',
        directoryName: '#0080ff',
        symlinkName: '#00ffff',
        symlinkTarget: '#ffff00'
      }
    },

    applyPreset(presetName) {
      const presets = {
        dark: {
          terminalBackground: '#1e1e1e',
          terminalHeaderBackground: '#333333',
          defaultText: '#ffffff',
          promptUser: '#00ff00',
          promptPath: '#0080ff',
          command: '#ffffff',
          directoryPerm: '#00ffff',
          stickyDirPerm: '#ffff00',
          symlinkPerm: '#ff00ff',
          execPerm: '#00ff00',
          user: '#ffff00',
          group: '#ffff00',
          size: '#00ffff',
          date: '#888888',
          directoryName: '#0080ff',
          symlinkName: '#00ffff',
          symlinkTarget: '#ffff00'
        },
        light: {
          terminalBackground: '#ffffff',
          terminalHeaderBackground: '#f0f0f0',
          defaultText: '#000000',
          promptUser: '#008000',
          promptPath: '#0000ff',
          command: '#000000',
          directoryPerm: '#008080',
          stickyDirPerm: '#b8860b',
          symlinkPerm: '#800080',
          execPerm: '#008000',
          user: '#b8860b',
          group: '#b8860b',
          size: '#008080',
          date: '#666666',
          directoryName: '#0000ff',
          symlinkName: '#008080',
          symlinkTarget: '#b8860b'
        },
        matrix: {
          terminalBackground: '#000000',
          terminalHeaderBackground: '#001100',
          defaultText: '#00ff00',
          promptUser: '#00ff00',
          promptPath: '#00aa00',
          command: '#00ff00',
          directoryPerm: '#00ff00',
          stickyDirPerm: '#88ff88',
          symlinkPerm: '#00ff00',
          execPerm: '#00ff00',
          user: '#00ff00',
          group: '#00ff00',
          size: '#00ff00',
          date: '#006600',
          directoryName: '#00ff00',
          symlinkName: '#00ff00',
          symlinkTarget: '#88ff88'
        },
        cyberpunk: {
          terminalBackground: '#0a0a0a',
          terminalHeaderBackground: '#1a0033',
          defaultText: '#00ff41',
          promptUser: '#ff0080',
          promptPath: '#00ffff',
          command: '#00ff41',
          directoryPerm: '#ff00ff',
          stickyDirPerm: '#80ff00',
          symlinkPerm: '#ff00ff',
          execPerm: '#ff0080',
          user: '#80ff00',
          group: '#80ff00',
          size: '#00ffff',
          date: '#ff4080',
          directoryName: '#00ffff',
          symlinkName: '#ff4080',
          symlinkTarget: '#80ff00'
        },
        dracula: {
          terminalBackground: '#282a36',
          terminalHeaderBackground: '#44475a',
          defaultText: '#f8f8f2',
          promptUser: '#50fa7b',
          promptPath: '#8be9fd',
          command: '#f8f8f2',
          directoryPerm: '#bd93f9',
          stickyDirPerm: '#f1fa8c',
          symlinkPerm: '#ff79c6',
          execPerm: '#50fa7b',
          user: '#f1fa8c',
          group: '#f1fa8c',
          size: '#8be9fd',
          date: '#6272a4',
          directoryName: '#8be9fd',
          symlinkName: '#ff79c6',
          symlinkTarget: '#f1fa8c'
        },
        monokai: {
          terminalBackground: '#272822',
          terminalHeaderBackground: '#3e3d32',
          defaultText: '#f8f8f2',
          promptUser: '#a6e22e',
          promptPath: '#66d9ef',
          command: '#f8f8f2',
          directoryPerm: '#ae81ff',
          stickyDirPerm: '#e6db74',
          symlinkPerm: '#f92672',
          execPerm: '#a6e22e',
          user: '#e6db74',
          group: '#e6db74',
          size: '#66d9ef',
          date: '#75715e',
          directoryName: '#66d9ef',
          symlinkName: '#f92672',
          symlinkTarget: '#e6db74'
        }
      }
        if (presets[presetName]) {
        this.customTheme = { ...presets[presetName] }
      }
    },    exportCustomTheme() {
      const themeName = prompt('Enter a name for this theme:', 'My Custom Theme')
      if (!themeName) return // User cancelled
      
      const themeData = {
        name: themeName,
        version: '1.0',
        created: new Date().toISOString(),
        generator: 'Terminal Screenshot Generator',
        colors: { ...this.customTheme }
      }
      
      const dataStr = JSON.stringify(themeData, null, 2)
      const blob = new Blob([dataStr], { type: 'application/json' })
      const url = URL.createObjectURL(blob)
      
      const link = document.createElement('a')
      link.href = url
      link.download = `${themeName.toLowerCase().replace(/[^a-z0-9]/g, '-')}-theme.json`
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      
      URL.revokeObjectURL(url)
    },

    importCustomTheme(event) {
      const file = event.target.files[0]
      if (!file) return
      
      if (!file.name.endsWith('.json')) {
        alert('Please select a JSON file.')
        return
      }
      
      const reader = new FileReader()
      reader.onload = (e) => {
        try {
          const themeData = JSON.parse(e.target.result)
          
          // Validate the theme data structure
          if (!themeData.colors || typeof themeData.colors !== 'object') {
            alert('Invalid theme file: Missing colors object.')
            return
          }
          
          // Check if all required color properties exist
          const requiredColors = [
            'terminalBackground', 'terminalHeaderBackground', 'defaultText',
            'promptUser', 'promptPath', 'command', 'directoryPerm',
            'stickyDirPerm', 'symlinkPerm', 'execPerm', 'user', 'group',
            'size', 'date', 'directoryName', 'symlinkName', 'symlinkTarget'
          ]
          
          const missingColors = requiredColors.filter(color => 
            !themeData.colors.hasOwnProperty(color)
          )
          
          if (missingColors.length > 0) {
            alert(`Invalid theme file: Missing color properties: ${missingColors.join(', ')}`)
            return
          }
          
          // Validate color format (hex colors)
          const invalidColors = requiredColors.filter(color => {
            const colorValue = themeData.colors[color]
            return !/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/.test(colorValue)
          })
          
          if (invalidColors.length > 0) {
            alert(`Invalid color format for: ${invalidColors.join(', ')}. Colors must be in hex format (e.g., #ff0000)`)
            return
          }
          
          // Apply the theme
          this.customTheme = { ...themeData.colors }
          alert(`Theme "${themeData.name || 'Imported Theme'}" imported successfully!`)
          
        } catch (error) {
          console.error('Theme import error:', error)
          alert('Error reading theme file. Please make sure it\'s a valid JSON file.')
        }
      }
      
      reader.onerror = () => {
        alert('Error reading file.')
      }
      
      reader.readAsText(file)
      
      // Reset the file input
      event.target.value = ''
    }
  }
}
</script>

<style scoped>
/* Base Layout */
.app {
  min-height: 100vh;
  background: linear-gradient(135deg, #0d1117 0%, #161b22 50%, #0d1117 100%);
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  font-size: 12px;
  line-height: 1.5;
}

.app-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px;
}

/* Header */
.header {
  margin-bottom: 32px;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 24px 0;
}

.header-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  background: linear-gradient(135deg, #1f6feb 0%, #0969da 100%);
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(31, 111, 235, 0.3);
}

.header-icon i {
  font-size: 28px;
  color: white;
}

.header-text h1 {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 4px 0;
  color: #e6edf3;
  letter-spacing: -0.025em;
}

.header-text p {
  font-size: 16px;
  color: #7d8590;
  margin: 0;
  font-weight: 400;
}

/* Main Content */
.main-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  align-items: start;
}

/* Cards */
.input-card,
.preview-card {
  background: rgba(22, 27, 34, 0.8);
  border: 1px solid #30363d;
  border-radius: 12px;
  backdrop-filter: blur(16px);
  box-shadow: 0 16px 32px rgba(0, 0, 0, 0.2);
  overflow: hidden;
}

.card-header {
  padding: 20px 24px;
  border-bottom: 1px solid #30363d;
  background: rgba(13, 17, 23, 0.5);
}

.card-header h2 {
  font-size: 18px;
  font-weight: 600;
  color: #e6edf3;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.card-header h2 i {
  color: #1f6feb;
}

.card-content {
  padding: 24px;
}

/* Input Field */
.input-field {
  margin-bottom: 24px;
}

.terminal-input {
  width: 100%;
  min-height: 280px;
  background: #0d1117;
  color: #e6edf3;
  border: 1px solid #30363d;
  border-radius: 8px;
  padding: 16px;
  font-family: 'JetBrains Mono', 'Consolas', 'Monaco', monospace;
  font-size: 12px;
  line-height: 1.45;
  resize: vertical;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.terminal-input:focus {
  outline: none;
  border-color: #1f6feb;
  box-shadow: 0 0 0 3px rgba(31, 111, 235, 0.1);
}

.terminal-input::placeholder {
  color: #7d8590;
}

/* Controls Grid */
.controls-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  align-items: end;
}

.action-group {
  grid-column: 1 / -1;
}

.title-group {
  grid-column: 1 / -1;
}

.control-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.customize-colors-group {
  grid-column: 1 / -1;
  margin: 8px 0;
}

.control-label {
  font-size: 12px;
  font-weight: 500;
  color: #e6edf3;
  display: flex;
  align-items: center;
  gap: 6px;
}

.control-label i {
  color: #7d8590;
  font-size: 14px;
}

/* Toggle Switch */
.toggle-switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 24px;
}

.toggle-switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.toggle-label {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: #30363d;
  border-radius: 12px;
  transition: 0.2s ease;
}

.toggle-label:before {
  position: absolute;
  content: "";
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background: #7d8590;
  border-radius: 50%;
  transition: 0.2s ease;
}

input:checked + .toggle-label {
  background: #1f6feb;
}

input:checked + .toggle-label:before {
  transform: translateX(20px);
  background: white;
}

/* Select Input */
.select-input {
  padding: 8px 12px;
  background: #0d1117;
  color: #e6edf3;
  border: 1px solid #30363d;
  border-radius: 6px;
  font-size: 12px;
  font-family: inherit;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.select-input:focus {
  outline: none;
  border-color: #1f6feb;
  box-shadow: 0 0 0 3px rgba(31, 111, 235, 0.1);
}

/* Text Input */
.text-input {
  padding: 8px 12px;
  background: #0d1117;
  color: #e6edf3;
  border: 1px solid #30363d;
  border-radius: 6px;
  font-size: 12px;
  font-family: inherit;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
  width: 100%;
}

.text-input:focus {
  outline: none;
  border-color: #1f6feb;
  box-shadow: 0 0 0 3px rgba(31, 111, 235, 0.1);
}

.text-input::placeholder {
  color: #7d8590;
}

/* Number Input */
.number-input {
  padding: 8px 12px;
  background: #0d1117;
  color: #e6edf3;
  border: 1px solid #30363d;
  border-radius: 6px;
  font-size: 12px;
  font-family: inherit;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
  width: 100%;
}

.number-input:focus {
  outline: none;
  border-color: #1f6feb;
  box-shadow: 0 0 0 3px rgba(31, 111, 235, 0.1);
}

.number-input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  background: #161b22;
}

/* Buttons */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  border: none;
  border-radius: 8px;
  font-family: inherit;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
  min-height: 44px;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none !important;
}

.btn-primary {
  background: linear-gradient(135deg, #1f6feb 0%, #0969da 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(31, 111, 235, 0.3);
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(31, 111, 235, 0.4);
}

.btn-success {
  background: linear-gradient(135deg, #2da44e 0%, #1a7f37 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(45, 164, 78, 0.3);
  width: 100%;
  justify-content: center;
}

.btn-success:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(45, 164, 78, 0.4);
}

.btn-secondary {
  background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
  width: 100%;
  justify-content: center;
}

.btn-secondary:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(108, 117, 125, 0.4);
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(4px);
}

.modal-content {
  background: rgba(22, 27, 34, 0.95);
  border: 1px solid #30363d;
  border-radius: 12px;
  backdrop-filter: blur(16px);
  box-shadow: 0 24px 48px rgba(0, 0, 0, 0.4);
  max-width: 800px;
  max-height: 90vh;
  width: 90%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.modal-header {
  padding: 20px 24px;
  border-bottom: 1px solid #30363d;
  background: rgba(13, 17, 23, 0.5);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.modal-header h3 {
  font-size: 18px;
  font-weight: 600;
  color: #e6edf3;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.modal-header h3 i {
  color: #1f6feb;
}

.btn-close {
  background: none;
  border: none;
  color: #7d8590;
  cursor: pointer;
  padding: 8px;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-close:hover {
  background: rgba(125, 133, 144, 0.1);
  color: #e6edf3;
}

.modal-body {
  padding: 24px;
  overflow-y: auto;
  flex: 1;
}

.preset-themes {
  background: rgba(13, 17, 23, 0.3);
  border: 1px solid #30363d;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 24px;
}

.preset-themes h4 {
  font-size: 16px;
  font-weight: 600;
  color: #e6edf3;
  margin: 0 0 16px 0;
  padding-bottom: 8px;
  border-bottom: 1px solid #30363d;
}

.preset-buttons {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
}

.btn-preset {
  padding: 8px 12px;
  background: rgba(31, 111, 235, 0.1);
  color: #1f6feb;
  border: 1px solid #1f6feb;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  text-align: center;
}

.btn-preset:hover {
  background: rgba(31, 111, 235, 0.2);
  transform: translateY(-1px);
}

.color-sections {
  display: grid;
  gap: 24px;
}

.color-section {
  background: rgba(13, 17, 23, 0.3);
  border: 1px solid #30363d;
  border-radius: 8px;
  padding: 20px;
}

.color-section h4 {
  font-size: 16px;
  font-weight: 600;
  color: #e6edf3;
  margin: 0 0 16px 0;
  padding-bottom: 8px;
  border-bottom: 1px solid #30363d;
}

.color-controls {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.color-control {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.color-control label {
  font-size: 12px;
  font-weight: 500;
  color: #e6edf3;
}

.color-input-group {
  display: flex;
  gap: 8px;
  align-items: center;
}

.color-input {
  width: 40px;
  height: 32px;
  border: 1px solid #30363d;
  border-radius: 6px;
  background: transparent;
  cursor: pointer;
  padding: 0;
  flex-shrink: 0;
}

.color-input::-webkit-color-swatch-wrapper {
  padding: 2px;
}

.color-input::-webkit-color-swatch {
  border: none;
  border-radius: 4px;
}

.color-text-input {
  padding: 6px 8px;
  background: #0d1117;
  color: #e6edf3;
  border: 1px solid #30363d;
  border-radius: 4px;
  font-size: 11px;
  font-family: 'JetBrains Mono', monospace;
  transition: border-color 0.2s ease;
  flex: 1;
}

.color-text-input:focus {
  outline: none;
  border-color: #1f6feb;
}

.modal-footer {
  padding: 20px 24px;
  border-top: 1px solid #30363d;
  background: rgba(13, 17, 23, 0.5);
  display: flex;
  gap: 12px;
  justify-content: space-between;
  align-items: center;
}

.footer-left,
.footer-right {
  display: flex;
  gap: 12px;
  align-items: center;
}

.file-input-wrapper {
  position: relative;
  cursor: pointer;
  width: auto !important;
  transition: all 0.2s ease;
}

.file-input-wrapper:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(108, 117, 125, 0.4);
}

.file-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
  pointer-events: none;
}

.modal-footer .btn {
  min-width: 120px;
}

/* Responsive modal design */
@media (max-width: 768px) {
  .modal-content {
    max-width: 95%;
    max-height: 95vh;
  }
  
  .color-controls {
    grid-template-columns: 1fr;
  }
  
  .preset-buttons {
    grid-template-columns: repeat(2, 1fr);
  }
    .modal-footer {
    flex-direction: column;
    gap: 16px;
  }
  
  .footer-left,
  .footer-right {
    width: 100%;
    justify-content: center;
  }
  
  .modal-footer .btn {
    width: 100%;
    min-width: auto;
  }
}

@media (max-width: 480px) {
  .preset-buttons {
    grid-template-columns: 1fr;
  }
}

/* Terminal Preview Container */
.terminal-container {
  margin-bottom: 16px;
  overflow-x: auto;
  overflow-y: visible;
  max-width: 100%;
}

.terminal-container::-webkit-scrollbar {
  height: 8px;
}

.terminal-container::-webkit-scrollbar-track {
  background: rgba(48, 54, 61, 0.3);
  border-radius: 4px;
}

.terminal-container::-webkit-scrollbar-thumb {
  background: rgba(125, 133, 144, 0.5);
  border-radius: 4px;
}

.terminal-container::-webkit-scrollbar-thumb:hover {
  background: rgba(125, 133, 144, 0.8);
}

.terminal-preview {
  background: #0d1117;
  border: 1px solid #30363d;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
  min-width: fit-content;
}

.terminal-header {
  background: #161b22;
  padding: 12px 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #30363d;
}

.terminal-buttons {
  display: flex;
  gap: 8px;
}

/* Terminal Window Buttons (red, yellow, green circles) */
.window-btn {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  border: none;
  cursor: pointer;
}

.window-btn.red { background: #ff5f57; }
.window-btn.yellow { background: #ffbd2e; }
.window-btn.green { background: #28ca42; }

.terminal-title {
  color: #7d8590;
  font-size: 12px;
  font-weight: 500;
  font-family: 'JetBrains Mono', monospace;
}

.terminal-content {
  padding: 16px;
  font-family: 'JetBrains Mono', 'Consolas', 'Monaco', monospace;
  font-size: 12px;
  line-height: 1.45;
  background: #0d1117;
  color: #e6edf3;
  min-height: 200px;
  word-wrap: break-word;
  white-space: pre-wrap;
}

/* Custom scrollbar for terminal content */
.terminal-content::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

.terminal-content::-webkit-scrollbar-track {
  background: rgba(48, 54, 61, 0.3);
  border-radius: 4px;
}

.terminal-content::-webkit-scrollbar-thumb {
  background: rgba(125, 133, 144, 0.5);
  border-radius: 4px;
}

.terminal-content::-webkit-scrollbar-thumb:hover {
  background: rgba(125, 133, 144, 0.8);
}

.terminal-content::-webkit-scrollbar-corner {
  background: transparent;
}

.terminal-output {
  margin: 0;
  white-space: pre-wrap;
  font-family: 'JetBrains Mono', 'Consolas', 'Monaco', monospace;
  font-size: 12px;
  line-height: 1.45;
  letter-spacing: 0;
  word-spacing: 0;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.timestamp {
  color: #7d8590;
  font-size: 11px;
  margin-bottom: 12px;
  border-bottom: 1px solid #30363d;
  padding-bottom: 8px;
}

/* Actions */
.actions {
  display: flex;
  gap: 12px;
}

/* Theme-specific styles */
.theme-custom .terminal-content {
  background: var(--custom-terminal-bg, #0d1117);
  color: var(--custom-default-text, #e6edf3);
}

.theme-custom .terminal-header {
  background: var(--custom-terminal-header-bg, #161b22);
}

.theme-dark .terminal-content {
  background: #1e1e1e;
  color: #ffffff;
}

.theme-dark .terminal-header {
  background: #333;
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
.theme-custom :deep(.prompt-user) { color: var(--custom-prompt-user, #00ff00); font-weight: bold; }
.theme-custom :deep(.prompt-path) { color: var(--custom-prompt-path, #0080ff); font-weight: bold; }
.theme-custom :deep(.command) { color: var(--custom-command, #ffffff); }
.theme-custom :deep(.permissions.dir-perm) { color: var(--custom-directory-perm, #00ffff); font-weight: bold; }
.theme-custom :deep(.permissions.sticky-dir-perm) { color: var(--custom-sticky-dir-perm, #ffff00); font-weight: bold; background-color: rgba(255, 255, 0, 0.1); }
.theme-custom :deep(.permissions.link-perm) { color: var(--custom-symlink-perm, #ff00ff); font-weight: bold; }
.theme-custom :deep(.permissions.exec-perm) { color: var(--custom-exec-perm, #00ff00); font-weight: bold; }
.theme-custom :deep(.user) { color: var(--custom-user, #ffff00); }
.theme-custom :deep(.group) { color: var(--custom-group, #ffff00); }
.theme-custom :deep(.size) { color: var(--custom-size, #00ffff); }
.theme-custom :deep(.date) { color: var(--custom-date, #888888); }
.theme-custom :deep(.filename.directory) { color: var(--custom-directory-name, #0080ff); font-weight: bold; }
.theme-custom :deep(.symlink-name) { color: var(--custom-symlink-name, #00ffff); font-weight: bold; }
.theme-custom :deep(.symlink-target) { color: var(--custom-symlink-target, #ffff00); font-style: italic; }

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

/* Responsive Design */
@media (max-width: 1024px) {
  .main-content {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .controls-grid {
    grid-template-columns: 1fr;
  }
  
  .action-group {
    grid-column: 1;
  }
}

@media (max-width: 768px) {
  .app-container {
    padding: 16px;
  }
  
  .header-content {
    flex-direction: column;
    text-align: center;
    gap: 12px;
  }
  
  .header-text h1 {
    font-size: 24px;
  }
  
  .header-text p {
    font-size: 14px;
  }
  
  .card-content {
    padding: 16px;
  }
  
  .controls-grid {
    gap: 12px;
  }
  
  .btn {
    padding: 10px 16px;
    font-size: 12px;
    min-height: 40px;
  }
  
  .terminal-content {
    max-height: 300px;
  }
}

@media (max-width: 480px) {
  .header-icon {
    width: 48px;
    height: 48px;
  }
  
  .header-icon i {
    font-size: 24px;
  }
  
  .header-text h1 {
    font-size: 20px;
  }
  
  .btn {
    padding: 8px 14px;
    font-size: 11px;
    min-height: 36px;
  }
  
  .terminal-content {
    max-height: 250px;
  }
}
</style>
