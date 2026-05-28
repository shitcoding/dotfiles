# JankyBorders Configuration

Window border highlighting for macOS using [JankyBorders](https://github.com/FelixKratz/JankyBorders).

## Features

- Orange border on active window, no border on inactive
- Per-app border styles (square borders for terminal apps, rounded for others)
- Auto-start on login

## Prerequisites

```bash
brew tap FelixKratz/formulae
brew install borders
```

## Setup

### Option 1: Clone repo + symlink

```bash
git clone <repo-url> ~/.dotfiles
ln -s ~/.dotfiles/borders ~/.config/borders
```

### Option 2: Manual setup

Create `~/.config/borders/bordersrc`:

```bash
#!/bin/bash

options=(
    style=round
    width=4.0
    hidpi=on
    active_color=0xffC96003
    inactive_color=0x00000000
)

borders "${options[@]}"
```

Make executable: `chmod +x ~/.config/borders/bordersrc`

## Auto-start borders

```bash
brew services start borders
```

## Per-app border styles (optional)

The watcher script applies square borders to specific apps (useful for terminals with square corners).

### Setup watcher

1. Copy `get_windows.swift`, `borders_watcher.sh`, and `square_apps.txt` to `~/.config/borders/`

2. Make executable:
   ```bash
   chmod +x ~/.config/borders/borders_watcher.sh
   chmod +x ~/.config/borders/get_windows.swift
   ```

3. Create LaunchAgent at `~/Library/LaunchAgents/com.user.borders-watcher.plist`:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.user.borders-watcher</string>
       <key>ProgramArguments</key>
       <array>
           <string>/Users/archer/.config/borders/borders_watcher.sh</string>
       </array>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
       <key>StandardOutPath</key>
       <string>/tmp/borders-watcher.log</string>
       <key>StandardErrorPath</key>
       <string>/tmp/borders-watcher.log</string>
   </dict>
   </plist>
   ```

4. Load the service:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.user.borders-watcher.plist
   ```

### Configure apps

Edit `square_apps.txt`. Each rule is one of:

- `AppName` — match any window of that app.
- `AppName:substring` — match windows of that app where either the window
  title contains the substring (case-sensitive), OR — when the title isn't
  readable — the owning process's command-line contains the substring
  (case-insensitive). `kCGWindowName` requires Screen Recording permission,
  which the `swift` helper usually doesn't have, so the cmdline fallback
  is what kicks in for most users.

```
# Apps with square borders
Ghostty
Alacritty

# Single-window discrimination: square the Vimput popup (kitty window
# launched with --instance-group vimput) but leave other kitty windows
# on the default rounded border.
kitty:Vimput
```

Changes take effect automatically (no restart needed).

## Management

```bash
# Borders
brew services start|stop|restart borders

# Watcher
launchctl load|unload ~/Library/LaunchAgents/com.user.borders-watcher.plist

# Logs
tail -f /tmp/borders-watcher.log
```
