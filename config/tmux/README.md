# Tmux Configuration Documentation

> A modern, feature-rich tmux configuration with 1-based indexing and comprehensive information display.

## 📋 Table of Contents

- [Installation](#installation)
- [Key Concepts](#key-concepts)
- [Keyboard Shortcuts](#keyboard-shortcuts)
  - [Prefix Key](#prefix-key)
  - [Session Management](#session-management)
  - [Window Management](#window-management)
  - [Pane Management](#pane-management)
  - [Copy Mode](#copy-mode)
  - [Utility Commands](#utility-commands)
- [Status Bar Information](#status-bar-information)
- [Advanced Features](#advanced-features)
- [Plugin Installation](#plugin-installation)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Installation

1. **Ensure tmux is installed:**
   ```bash
   # Ubuntu/Debian
   sudo apt install tmux
   
   # Arch Linux
   sudo pacman -S tmux
   
   # macOS
   brew install tmux
   ```

2. **The configuration is already in place at:**
   ```
   ~/.config/tmux/tmux.conf
   ```

3. **Start tmux or reload the configuration:**
   ```bash
   # Start new tmux session
   tmux
   
   # Or reload in existing session
   Ctrl-a + r
   ```

---

## 🎯 Key Concepts

### Prefix Key
The **prefix key** is `Ctrl-a` (more ergonomic than the default `Ctrl-b`). Most commands require pressing the prefix first.

### Hierarchy
```
Session (1 or more)
  ↳ Window (1 or more) - like tabs in a browser
      ↳ Pane (1 or more) - split views within a window
```

### Indexing
All windows and panes start at **1** (not 0) for human-friendly navigation.

---

## ⌨️ Keyboard Shortcuts

### Prefix Key

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a` | Prefix key (press before most commands) |
| `Ctrl-a Ctrl-a` | Send `Ctrl-a` to the application |

---

### Session Management

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a Ctrl-c` | Create new session |
| `Ctrl-a Ctrl-j` | Choose session from tree |
| `Ctrl-a $` | Rename current session |
| `Ctrl-a d` | Detach from session |
| `tmux ls` | List all sessions (from terminal) |
| `tmux attach -t [name]` | Attach to session (from terminal) |
| `tmux kill-session -t [name]` | Kill session (from terminal) |

---

### Window Management

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a c` | Create new window (in current path) |
| `Ctrl-a ,` | Rename current window |
| `Ctrl-a X` | Kill current window (with confirmation) |
| `Ctrl-a &` | Kill current window (default binding) |
| `Shift-Left` | Previous window (no prefix needed) |
| `Shift-Right` | Next window (no prefix needed) |
| `Ctrl-a 1-9` | Switch to window 1-9 |
| `Ctrl-a <` | Move current window left |
| `Ctrl-a >` | Move current window right |
| `Ctrl-a w` | List all windows |
| `Ctrl-a f` | Find window by name |

---

### Pane Management

#### Creating Panes

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a \|` | Split pane horizontally (side-by-side) |
| `Ctrl-a -` | Split pane vertically (top-bottom) |
| `Ctrl-a v` | Split pane horizontally (vim-style) |
| `Ctrl-a s` | Split pane vertically (vim-style) |

#### Navigating Panes

| Shortcut | Description |
|----------|-------------|
| `Alt-Left/Right/Up/Down` | Navigate panes (no prefix needed) |
| `Ctrl-a h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl-a ;` | Toggle to last active pane |
| `Ctrl-a o` | Go to next pane |
| `Ctrl-a q` | Show pane numbers (type number to jump) |

#### Resizing Panes

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a Ctrl-h` | Resize pane left |
| `Ctrl-a Ctrl-j` | Resize pane down |
| `Ctrl-a Ctrl-k` | Resize pane up |
| `Ctrl-a Ctrl-l` | Resize pane right |
| `Ctrl-a Left/Right/Up/Down` | Resize with arrow keys |

#### Pane Actions

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a z` | Toggle pane zoom (fullscreen) |
| `Ctrl-a x` | Kill current pane (no confirmation) |
| `Ctrl-a !` | Break pane to new window |
| `Ctrl-a b` | Break pane to new window (stay in current) |
| `Ctrl-a S` | Toggle synchronize panes (type in all at once) |
| `Ctrl-a {` | Swap with previous pane |
| `Ctrl-a }` | Swap with next pane |
| `Ctrl-a Space` | Cycle through pane layouts |

---

### Copy Mode (Vim-style)

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a Enter` | Enter copy mode |
| `Ctrl-a Escape` | Enter copy mode |
| `Ctrl-a [` | Enter copy mode (default) |
| `q` | Exit copy mode |
| **In Copy Mode:** | |
| `h/j/k/l` | Move cursor (vim-style) |
| `H` | Jump to start of line |
| `L` | Jump to end of line |
| `v` | Begin selection |
| `Ctrl-v` | Rectangle selection toggle |
| `y` | Copy selection and exit |
| `Escape` | Cancel selection |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `Ctrl-u` | Scroll up half page |
| `Ctrl-d` | Scroll down half page |
| `g` | Go to top |
| `G` | Go to bottom |
| **After Copy Mode:** | |
| `Ctrl-a p` | Paste buffer |
| `Ctrl-a P` | Choose which buffer to paste |

---

### Utility Commands

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a r` | Reload configuration |
| `Ctrl-a e` | Edit configuration in editor |
| `Ctrl-a ?` | List all key bindings |
| `Ctrl-a m` | Show message log |
| `Ctrl-a t` | Show clock |
| `Ctrl-a Ctrl-l` | Clear screen and scrollback |
| `Ctrl-a :` | Enter command mode |
| `Ctrl-a i` | Display pane info |
| `Ctrl-a M` | Monitor pane for silence (30s) |

---

## 📊 Status Bar Information

### Left Section
- **Session name** with icon (❐)
- **Username@hostname**

### Center Section
- **Window list** with numbers starting from 1
- **Active window** highlighted in blue
- **Window flags:**
  - `*` = Current window
  - `-` = Last window
  - `#` = Activity detected
  - `!` = Bell in window
  - `~` = Monitored for silence
  - `Z` = Zoomed pane

### Right Section
- **🔴 PREFIX** - Shows when prefix key is pressed
- **🔄 SYNC** - Shows when panes are synchronized
- **📅 Date** in YYYY-MM-DD format
- **⏰ Time** in 24-hour format with seconds

---

## 🔥 Advanced Features

### Mouse Support
- **Click** to select pane
- **Drag** pane borders to resize
- **Click** window name to switch
- **Scroll** to scroll through history
- **Double-click** to select word
- **Triple-click** to select line

### Nested Tmux Sessions
When you SSH into another machine running tmux:
- Press `F12` to switch to inner tmux (status bar dims)
- Press `Shift-F12` to switch back to outer tmux

### Activity Monitoring
- Windows with activity show highlighted in the status bar
- Set monitor silence: `Ctrl-a M`
- Disable monitoring: `Ctrl-a m`

### Synchronized Panes
Type the same command in all panes simultaneously:
```
Ctrl-a S  (toggle on/off)
```

### Custom Layouts
Cycle through predefined layouts:
```
Ctrl-a Space
```

---

## 🔌 Plugin Installation (Optional)

### Install TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Enable Plugins

1. Uncomment the plugin section at the bottom of `tmux.conf`
2. Reload tmux config: `Ctrl-a r`
3. Install plugins: `Ctrl-a I` (capital I)

### Recommended Plugins

- **tmux-resurrect** - Save/restore tmux sessions
- **tmux-continuum** - Automatic session saving
- **tmux-yank** - Better clipboard integration
- **tmux-cpu** - CPU and memory monitoring

### Plugin Commands

| Shortcut | Description |
|----------|-------------|
| `Ctrl-a I` | Install plugins |
| `Ctrl-a U` | Update plugins |
| `Ctrl-a alt-u` | Uninstall removed plugins |

---

## 🛠️ Troubleshooting

### Colors Look Wrong

Ensure your terminal supports 256 colors:
```bash
echo $TERM
# Should show: screen-256color, xterm-256color, or similar
```

Add to your `~/.zshrc` or `~/.bashrc`:
```bash
export TERM=xterm-256color
```

### Can't Copy to System Clipboard

Install clipboard utilities:
```bash
# Linux
sudo apt install xclip

# macOS (should work by default)
# Install reattach-to-user-namespace if needed
brew install reattach-to-user-namespace
```

### Tmux Not Loading Config

Check config location:
```bash
# Should be at:
~/.config/tmux/tmux.conf

# Or create a symlink:
ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
```

### Status Bar Not Showing CPU/Memory

Uncomment and install the `tmux-cpu` plugin (see Plugin Installation above).

---

## 📚 Useful Commands

### From Terminal (Outside Tmux)

```bash
# Start new named session
tmux new -s mysession

# List sessions
tmux ls

# Attach to session
tmux attach -t mysession

# Attach to last session
tmux attach

# Kill session
tmux kill-session -t mysession

# Kill all sessions except current
tmux kill-session -a

# Send commands to running session
tmux send-keys -t mysession "echo hello" Enter
```

### Inside Tmux Command Mode (`Ctrl-a :`)

```bash
# Split window 50/50
split-window -h -p 50

# Resize pane to 40% height
resize-pane -y 40%

# Swap window 1 with window 2
swap-window -s 1 -t 2

# Move current window to position 5
move-window -t 5

# Rename session
rename-session newsessionname

# Set status bar on/off
set status on
```

---

## 🎨 Customization

### Change Color Scheme

Edit the color values in `tmux.conf`:
- `colour154` = Green accent (change to your preference)
- `colour31` = Blue for active window
- `colour234` = Dark background
- `colour238` = Medium gray

Find colors: https://jonasjacek.github.io/colors/

### Change Prefix Key

Replace `C-a` with your preferred key:
```bash
set -g prefix C-b  # or any other key
```

---

## 📖 Quick Reference Card

```
┌─────────────────────────────────────────────────────┐
│ Prefix: Ctrl-a                                      │
├─────────────────────────────────────────────────────┤
│ SESSIONS                                            │
│  Ctrl-a Ctrl-c  New session                         │
│  Ctrl-a Ctrl-j  Choose session                      │
│  Ctrl-a d       Detach                              │
├─────────────────────────────────────────────────────┤
│ WINDOWS                                             │
│  Ctrl-a c       New window                          │
│  Shift-←/→      Previous/Next window                │
│  Ctrl-a 1-9     Go to window 1-9                    │
├─────────────────────────────────────────────────────┤
│ PANES                                               │
│  Ctrl-a |       Split horizontal                    │
│  Ctrl-a -       Split vertical                      │
│  Alt-Arrow      Navigate panes                      │
│  Ctrl-a z       Zoom pane                           │
│  Ctrl-a S       Sync panes                          │
├─────────────────────────────────────────────────────┤
│ COPY MODE                                           │
│  Ctrl-a Enter   Enter copy mode                     │
│  v              Begin selection                     │
│  y              Copy and exit                       │
│  Ctrl-a p       Paste                               │
├─────────────────────────────────────────────────────┤
│ UTILITY                                             │
│  Ctrl-a r       Reload config                       │
│  Ctrl-a ?       List keybindings                    │
│  Ctrl-a :       Command mode                        │
└─────────────────────────────────────────────────────┘
```

---

## 📝 Notes

- All windows and panes start at **1** (not 0)
- Mouse support is enabled by default
- Scrollback buffer: 100,000 lines
- True color support enabled
- Vim-style key bindings in copy mode
- 24-hour clock format

---

## 🔗 Resources

- [Official Tmux Wiki](https://github.com/tmux/tmux/wiki)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [TPM Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Awesome Tmux](https://github.com/rothgar/awesome-tmux)