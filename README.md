# Dotfiles

My personal dotfiles and configuration files for Linux systems.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/xentixar/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Complete setup (recommended)
./rebuild.sh
```

This will guide you through:
1. Installing system dependencies
2. Restoring dotfiles
3. Building tools

## Manual Setup

### 1. Install Dependencies

```bash
./install.sh
```

Interactive menu lets you choose what to install:
- Essential packages (git, curl, zsh, vim, tmux, build tools)
- Suckless tools dependencies (X11 libraries)
- Development packages (python3, pip)
- Advanced tools (PHP 8.4, Composer, Node.js via NVM, VSCode)
- Script dependencies (nvim, xclip, scrot, wmctrl, etc.)

**Tip:** Type numbers like `1,2,3` to select multiple items, or press Enter to start.

### 2. Restore Dotfiles

```bash
./restore.sh
```

Choose:
- **Symlinks** (recommended) - Changes sync automatically
- **Copy** - Independent copies
- **Backup** - Backs up existing files first

### 3. Build Tools

```bash
./build.sh
```

Select which tools to build (dwm, st, dmenu, slstatus).

## What's Included

### Configuration Files
- **Shell**: zsh, bash configurations
- **Editors**: Neovim, Emacs
- **Terminal**: tmux
- **Window Manager**: dwm, st, dmenu, slstatus

### Scripts
- Custom shell scripts in `scripts/`
- SLStatus helper scripts
- All scripts are installed to `/usr/local/bin` automatically

### Installation Scripts
All scripts in `install/` are automatically detected and shown in the menu:
- Essential packages
- Suckless dependencies
- Development tools (PHP, Composer, Node.js, VSCode)
- Script dependencies (nvim, xclip, scrot, etc.)

## Directory Structure

```
dotfiles/
├── home/          # Dotfiles (~/.zshrc, ~/.bashrc, etc.)
├── config/         # Config files (~/.config/dwm, ~/.config/nvim, etc.)
├── scripts/        # Custom scripts (installed to /usr/local/bin)
├── install/        # Installation scripts (auto-detected)
├── build/          # Build scripts (auto-detected)
├── install.sh      # Interactive installation menu
├── build.sh        # Interactive build menu
├── restore.sh      # Restore dotfiles
└── rebuild.sh      # Complete system rebuild
```

## Features

- **Auto-detection**: Scripts are automatically discovered from folder contents
- **Interactive menus**: Checkbox-style selection for easy use
- **Multi-distro**: Supports apt (Debian/Ubuntu), pacman (Arch), dnf (Fedora)
- **Modular**: Each tool has its own install/build script
- **Safe**: Backs up existing files before restoring

## Adding New Scripts

### Installation Script
1. Create `install/install_<name>.sh`
2. Add title comment: `# Your Title Here`
3. It appears automatically in `install.sh` menu

### Build Script
1. Create `build/build_<name>.sh`
2. Add title comment: `# Your Title Here`
3. It appears automatically in `build.sh` menu

## Notes

- Sensitive files are excluded via `.gitignore`
- Scripts are copied to `/usr/local/bin` during installation
- SLStatus scripts are installed automatically when building slstatus

## License

Personal use only.
