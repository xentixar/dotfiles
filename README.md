# Dotfiles

My personal dotfiles and configuration files.

## Contents

- **home/**: Dotfiles from home directory (`.zshrc`, `.bashrc`, etc.)
- **config/**: Configuration files from `~/.config/`
- **Scripts/**: Custom shell scripts

## Setup

### Backup your current dotfiles

Run the backup script to copy your current dotfiles:

```bash
cd ~/dotfiles
./backup.sh
```

## Installation & Restore

### Quick Setup (Complete Rebuild)

For a fresh system or after reset, use the rebuild script:

```bash
cd ~/dotfiles
./rebuild.sh
```

This will:
1. Install all dependencies (`install.sh`)
2. Restore all dotfiles (`restore.sh`)
3. Rebuild suckless tools (dwm, st, dmenu, slstatus)

### Step-by-Step Setup

#### 1. Clone the repository

```bash
git clone https://github.com/xentixar/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### 2. Install dependencies

```bash
./install.sh
```

This installs:
- Essential packages (git, curl, zsh, vim, tmux, etc.)
- Development tools (nodejs, npm, python3)
- Suckless tools dependencies (X11 libraries)

#### 3. Restore dotfiles

```bash
./restore.sh
```

Options:
- **Symlinks** (recommended): Creates symlinks so changes in dotfiles repo are reflected immediately
- **Copy**: Creates independent copies
- **Backup**: Automatically backs up existing files before restoring

#### 4. Rebuild suckless tools (optional)

After restoring, rebuild your window manager and tools:

```bash
# Rebuild dwm
cd ~/.config/dwm && sudo make clean install

# Rebuild st (terminal)
cd ~/.config/st && sudo make clean install

# Rebuild dmenu
cd ~/.config/dmenu && sudo make clean install

# Rebuild slstatus (status bar)
cd ~/.config/slstatus && sudo make clean install
```

Or use the rebuild script which handles this automatically.

## Structure

```
dotfiles/
├── home/           # Dotfiles from ~/
│   ├── .zshrc
│   ├── .bashrc
│   └── ...
├── config/         # Config files from ~/.config/
│   ├── dwm/        # dwm window manager config
│   ├── st/         # st terminal config
│   ├── dmenu/      # dmenu config
│   ├── slstatus/   # slstatus bar config
│   ├── nvim/       # Neovim config
│   ├── tmux/       # Tmux config
│   └── ...
├── Scripts/        # Custom shell scripts
├── backup.sh       # Backup current dotfiles to repo
├── restore.sh      # Restore dotfiles from repo to system
├── install.sh      # Install system dependencies
├── rebuild.sh      # Complete system rebuild (install + restore)
├── .gitignore      # Files to exclude from git
└── README.md       # This file
```

## Notes

- Sensitive files (SSH keys, credentials, etc.) are excluded via `.gitignore`
- History files are not backed up for privacy
- Large cache directories are excluded

## License

Personal use only.
