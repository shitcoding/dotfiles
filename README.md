# Dotfiles

Personal configuration files for a productive development environment on macOS and Linux. Heavily customized for keyboard-driven workflow with Vim keybindings, tmux, and extensive automation.

---

## Quick Start

```sh
git clone --depth=1 https://github.com/shitcoding/dotfiles ~/.dotfiles
cd ~/.dotfiles
make magic
```

---

## What's Inside

### Terminal & Shell

#### Zsh
- **Oh My Zsh** framework with custom plugins
- **Powerlevel10k** theme for a beautiful, informative prompt
- Plugins: `git`, `history-substring-search`, `zsh-autosuggestions`, `zsh-fzf-history-search`, `F-Sy-H`
- **pyenv** and **nvm** integration for Python and Node.js version management
- Extensive custom aliases for productivity (see below)

**Files:**
- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.zshrc_macos` → macOS-specific configuration
- `zsh/oh-my-zsh/custom/aliases-pub.zsh` → Custom command aliases
- `zsh/oh-my-zsh/custom/aliases-pub-macos.zsh` → macOS-specific aliases
- `zsh/oh-my-zsh/custom/env-pub.zsh` → Environment variables
- `zsh/oh-my-zsh/custom/env-pub-macos.zsh` → macOS-specific environment variables
- `powerlevel10k/.p10k.zsh` → `~/.p10k.zsh`

### Terminal Emulators

#### Alacritty
Fast, GPU-accelerated terminal emulator with:
- Custom Gruvbox-inspired color scheme
- 90% opacity for aesthetics
- MesloLGS Nerd Font for icon support
- Maximized startup
- 10,000 lines of scrollback history

**File:** `alacritty/alacritty.yml` → `~/.config/alacritty/alacritty.yml`

#### Kitty
Alternative terminal emulator configuration

**File:** `kitty/kitty.conf`

### Multiplexer

#### Tmux
Comprehensive tmux configuration with:
- **Ctrl-A** prefix (instead of default Ctrl-B)
- Vim-style keybindings for navigation (`hjkl`)
- Alt+hjkl for quick pane switching (no prefix)
- Alt+1-9 for window switching (no prefix)
- Ctrl-Space to switch to last window
- Custom Gruvbox-inspired color scheme
- Mouse support enabled
- Plugins via TPM:
  - `tmux-sensible` - sensible defaults
  - `tmux-yank` - system clipboard integration
  - `tmux-resurrect` - save/restore sessions
  - `tmux-fzf` - fuzzy finder integration
- Resurrect support for: `vim`, `nvim`, `htop`, `btop`, `nvitop`, `lazygit`

**Files:**
- `tmux/.tmux.conf` → `~/.tmux.conf`
- `tmux/.tmux.conf.macos` → macOS-specific configuration

### Editors

#### Vim
Classic Vim configuration with extensive plugins via vim-plug:
- **Gruvbox** color scheme
- **NERDTree** with icons and syntax highlighting
- **YouCompleteMe** for code completion
- **FZF** for fuzzy file finding
- **vim-airline** with minimalist theme
- **vim-surround**, **targets.vim**, **emmet-vim**
- **vim-numbertoggle** - hybrid/absolute line numbers
- Custom keybindings:
  - Space as leader key
  - H/L for line beginning/end
  - Ctrl-hjkl for split navigation
  - g1-g9 for tab switching
  - Emacs-like shortcuts in command mode
  - Persistent undo
- Russian keyboard layout support

**File:** `vim/.vimrc` → `~/.vimrc`

#### LazyVim
Neovim IDE layer built on [LazyVim](https://www.lazyvim.org/) with extensive customization:
- **VSCode** color scheme with transparency
- Custom keybindings matching Vim configuration
- J/K for buffer tab navigation, g1-g9 for direct buffer access
- m/M for buffer reordering
- H/L for line beginning/end navigation
- vim-surround style keybindings via mini.surround
- Flash.nvim for enhanced navigation with labels
- Emacs-style command line navigation
- Russian keyboard layout support via langmap
- LazyExtras for optional language support (Python, etc.)

**Files:**
- `lazyvim/` → `~/.config/nvim/`
- `lazyvim/lua/config/keymaps.lua` → Custom key mappings
- `lazyvim/lua/config/options.lua` → Vim options
- `lazyvim/lua/plugins/` → Plugin configurations

#### LunarVim (Legacy)
> **Note:** LunarVim is now deprecated. Configuration is kept for reference but LazyVim is the primary editor.

**Files:**
- `lvim/config.lua` → LunarVim config (legacy)

### Keyboard Remapping

#### Karabiner-Elements (macOS)
Sophisticated keyboard customizations:
- **Caps Lock** → Escape when tapped, Ctrl when held
- **Left Cmd** → Mission Control (F3) when pressed alone
- **Ctrl** → Hyper key (⌃⌥⇧⌘) for additional shortcuts
- **Double Left Shift** → Caps Lock
- **Emacs-like text editing** (Ctrl-a/e/b/f/w/u/d) system-wide
  - Excludes terminals, Vim, Obsidian, Firefox
- **Ctrl-hjkl** → Arrow keys (except in terminals/Vim)
- **Cmd-hjkl** → Tmux pane switching in terminals
- **Ctrl-b** → Backspace (except in terminals)
- Preserves Ctrl-Cmd-H/L/K for BetterTouchTool integration

**File:** `karabiner/karabiner.json`

#### Hammerspoon (macOS)
Automation and window management:
- **Cmd-0** → Switch to last space/desktop on built-in display

**File:** `hammerspoon/init.lua`

### File Manager

#### Vifm
Vim-like file manager configuration

**File:** `vifm/vifmrc`

### Browser

#### Firefox
- **Tridactyl** extension configuration for Vim-like browsing
- Custom `userChrome.css` for UI modifications

**Files:**
- `firefox/tridactylrc`
- `firefox/userChrome.css`

### IDE

#### JetBrains IDEs
- IdeaVim configuration for Vim emulation
- Custom keymap exports

**Files:**
- `jetbrains/.ideavimrc`
- `jetbrains/ide_keymaps.zip`

### Tools

#### LazyDocker
TUI for Docker management

**File:** `lazydocker/config.yml`

#### Obsidian
Vim mode configuration for note-taking

**File:** `obsidian/.obsidian.vimrc`

### Desktop Environment

#### GNOME (Linux)
Custom GNOME settings

**File:** `gnome/gnome-settings.ini`

---

## Notable Aliases & Commands

### Tool Replacements
```bash
l, la          # eza (modern ls)
bat            # batcat (cat with syntax highlighting)
ping           # prettyping (prettier ping)
```

### Docker Shortcuts
```bash
dcmp           # docker compose
dcst, dcrm     # docker stop, docker rm
dcps           # docker ps --all
```

### Tmux
```bash
tmr            # Launch tmux, restore last session, attach to main
```

### File Operations
```bash
mkd            # mkdir -p
cpr            # cp -r
cpwd, c        # Copy current directory path to clipboard
cpls           # Copy file/directory absolute path to clipboard
```

### System Utilities
```bash
dnow           # Current date (DD-MM-YYYY)
dtnow          # Current datetime (DD-MM-YYYY_HH-MM)
qrstring       # Generate QR code in terminal
yo             # Send desktop notification
```

### Package Managers
```bash
# Arch Linux
pac, pacs, pacr

# Debian/Ubuntu
sai, sau, sar   # apt install, update, remove
sni, snu        # nala (better apt) install, upgrade
```

### Development
```bash
v              # nvim (LazyVim)
lg             # lazygit
ldc            # lazydocker
py, pym        # python3, python3 -m
pcd            # Remove __pycache__ directories
```

### Linux-Specific
```bash
restart-gnome  # Restart GNOME Shell
restart-sound  # Restart PipeWire/audio
fxrndr         # Fix external display scaling
```

---

## Installation Scripts

### Arch Linux
```bash
./arch_install_tools.sh
```
Automated installation of common development tools

### Ubuntu/Debian
```bash
./ubuntu_install_tools.sh
```
Automated installation of common development tools

### Manual Installation
```bash
./install.sh
```
Copies dotfiles to appropriate locations (basic setup)

---

## Key Features

### Vim Everywhere
- Vim keybindings in: shell, tmux, browsers, file managers, IDEs, note-taking apps
- Consistent navigation across all tools (hjkl)
- H/L for line beginning/end across editors

### Keyboard-Driven Workflow
- Extensive keyboard shortcuts minimize mouse usage
- System-wide Emacs-like text editing shortcuts
- Quick workspace/window switching via Karabiner
- Tmux integration with terminal-level shortcuts

### Developer Productivity
- Modern CLI tools (eza, bat, prettyping, fzf)
- Python development: pyenv, virtual envs, LSP, formatters, linters
- Docker workflows with lazydocker
- Git workflows with lazygit
- Session persistence in tmux and Neovim

### Multi-Platform Support
- Separate configurations for macOS and Linux
- Platform-specific aliases and environment variables
- Conditional tool usage based on availability

### Aesthetic Consistency
- Gruvbox-inspired color scheme across all tools
- Transparent backgrounds where supported
- Nerd Fonts for consistent iconography
- Custom status lines and prompts

---

## Dependencies

### Required
- `zsh` - Shell
- `oh-my-zsh` - Zsh framework
- `powerlevel10k` - Zsh theme
- `tmux` - Terminal multiplexer
- `neovim` - Text editor (with LazyVim)

### Recommended
- `alacritty` or `kitty` - Terminal emulator
- `fzf` - Fuzzy finder
- `eza` - Modern ls replacement
- `bat` - Cat with syntax highlighting
- `prettyping` - Better ping
- `pyenv` - Python version manager
- `nvm` - Node.js version manager
- `lazygit` - Git TUI
- `lazydocker` - Docker TUI
- `karabiner-elements` - Keyboard customizer (macOS)
- `hammerspoon` - Automation tool (macOS)

### Fonts
- MesloLGS Nerd Font - For icon support

---

## Platform Compatibility

- **macOS** - Primary platform with full support
- **Linux (Arch, Ubuntu/Debian)** - Full support
- **Wayland/Xorg** - Both supported

---

## Recent Updates

- **Editor: Migrated from LunarVim to LazyVim** (LunarVim is deprecated)
- Karabiner: Ctrl-b as backspace (except terminals)
- Karabiner: Emacs text editing bindings
- Karabiner: Cmd-hjkl for tmux pane switching
- Zsh: soundcloud-dl (scdl) alias
- Zsh: Go directory moved to hidden `.go`
- Tmux: macOS-specific configuration
- Hammerspoon: Cmd-0 to switch to last space

---

## Contributing

These are personal dotfiles, but feel free to fork and adapt them to your needs!

---

## License

MIT

---

## Credits

Best configs for best tools (by my mom's rating)
