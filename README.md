# Dotfiles

My personal dotfiles and configuration files.

## Contents

- **home/**: Dotfiles from home directory (`.zshrc`, `.bashrc`, etc.)
- **config/**: Configuration files from `~/.config/`
- **scripts/**: Custom shell scripts
- **install/**: Development tools installation scripts
- **build/**: Build scripts for suckless tools

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
3. Rebuild suckless tools (dwm, st, dmenu, slstatus) using modular build scripts

### Step-by-Step Setup

#### 1. Clone the repository

```bash
git clone https://github.com/xentixar/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### 2. Install system dependencies

```bash
./install.sh
```

This will show an interactive checkbox menu where you can select what to install:
- Essential packages (git, curl, zsh, vim, tmux, build tools)
- Suckless tools dependencies (X11 libraries for dwm, st, dmenu, slstatus)
- Basic development packages (nodejs, npm, python3, pip)
- Advanced development tools (PHP 8.4, Composer, Node.js via NVM, VSCode)
- Set zsh as default shell

The menu automatically detects all installation scripts in the `install/` folder and displays them with their titles (from the first comment line in each script).

#### 3. Restore dotfiles

```bash
./restore.sh
```

Options:
- **Symlinks** (recommended): Creates symlinks so changes in dotfiles repo are reflected immediately
- **Copy**: Creates independent copies
- **Backup**: Automatically backs up existing files before restoring

#### 4. Install Development Tools (Optional)

Install development tools individually or all at once:

```bash
# Install all development tools
./install/install_all.sh

# Or install individually:
./install/install_php84.sh      # PHP 8.4
./install/install_composer.sh   # Composer
./install/install_nodejs_nvm.sh # Node.js via NVM
./install/install_vscode.sh    # Visual Studio Code
```

#### 5. Rebuild tools (optional)

After restoring, rebuild your tools:

```bash
./build.sh
```

This will show an interactive checkbox menu where you can select what to build. The menu automatically detects all build scripts in the `build/` folder and displays them with their titles (from the first comment line in each script).

You can also rebuild tools individually:
```bash
./build/build_dwm.sh      # DWM window manager
./build/build_st.sh       # ST terminal
./build/build_dmenu.sh    # DMenu
./build/build_slstatus.sh # SLStatus bar
./build/build_all.sh      # Build all tools at once
```

Or use the rebuild script which handles this automatically.

## Installation Scripts

The `install/` folder contains modular installation scripts that are automatically detected by `install.sh`:

### System Packages
- **`install_essential.sh`**: Essential packages (git, curl, wget, zsh, vim, tmux, build tools)
- **`install_suckless_deps.sh`**: Suckless tools dependencies (X11 libraries)
- **`install_dev_packages.sh`**: Basic development packages (nodejs, npm, python3, pip)

### Advanced Development Tools
- **`install_php84.sh`**: PHP 8.4 and common extensions
- **`install_composer.sh`**: Composer globally
- **`install_nodejs_nvm.sh`**: NVM and latest LTS Node.js
- **`install_vscode.sh`**: Visual Studio Code
- **`install_all.sh`**: Installs all advanced development tools at once

### How It Works

The `install.sh` script:
- **Automatically detects** all `install_*.sh` scripts in the `install/` folder
- **Extracts the title** from the first comment line in each script (e.g., `# Essential Packages Installation Script`)
- **Displays an interactive menu** with checkboxes where you can select what to install
- **Executes selected scripts** in order

### Adding New Installation Scripts

To add a new installation script:
1. Create a new file `install/install_<name>.sh`
2. Add a comment on the first line after the shebang: `# Your Script Title Here`
3. The script will automatically appear in the `install.sh` menu

Each script:
- Supports multiple package managers (apt, pacman, dnf)
- Checks if tools are already installed
- Verifies installation success
- Provides clear output with color-coded messages

## Build Scripts

The `build/` folder contains modular build scripts that are automatically detected by `build.sh`:

- **`build_dwm.sh`**: Rebuilds DWM window manager
- **`build_st.sh`**: Rebuilds ST terminal
- **`build_dmenu.sh`**: Rebuilds DMenu
- **`build_slstatus.sh`**: Rebuilds SLStatus status bar
- **`build_all.sh`**: Rebuilds all tools at once

### How It Works

The `build.sh` script:
- **Automatically detects** all `build_*.sh` scripts in the `build/` folder
- **Extracts the title** from the first comment line in each script (e.g., `# DWM Build Script`)
- **Displays an interactive menu** with checkboxes where you can select what to build
- **Executes selected scripts** in order

### Adding New Build Scripts

To add a new build script:
1. Create a new file `build/build_<name>.sh`
2. Add a comment on the first line after the shebang: `# Your Build Script Title Here`
3. The script will automatically appear in the `build.sh` menu

Each script:
- Cleans previous builds
- Builds and installs the tool
- Provides clear output with color-coded messages
- Handles errors gracefully

## Structure

```
dotfiles/
├── home/              # Dotfiles from ~/
│   ├── .zshrc
│   ├── .bashrc
│   └── ...
├── config/            # Config files from ~/.config/
│   ├── dwm/          # dwm window manager config
│   ├── st/            # st terminal config
│   ├── dmenu/         # dmenu config
│   ├── slstatus/      # slstatus bar config
│   ├── nvim/          # Neovim config
│   ├── emacs/         # Emacs config
│   ├── tmux/          # Tmux config
│   └── ...
├── scripts/           # Custom shell scripts
├── install/          # Installation scripts (automatically detected)
│   ├── install_essential.sh
│   ├── install_suckless_deps.sh
│   ├── install_dev_packages.sh
│   ├── install_php84.sh
│   ├── install_composer.sh
│   ├── install_nodejs_nvm.sh
│   ├── install_vscode.sh
│   └── install_all.sh
├── build/            # Build scripts for suckless tools
│   ├── build_dwm.sh
│   ├── build_st.sh
│   ├── build_dmenu.sh
│   ├── build_slstatus.sh
│   └── build_all.sh
├── backup.sh         # Backup current dotfiles to repo
├── restore.sh        # Restore dotfiles from repo to system
├── install.sh        # Interactive installation menu (auto-detects scripts)
├── build.sh          # Interactive build menu (auto-detects scripts)
├── rebuild.sh        # Complete system rebuild (install + restore)
├── .gitignore        # Files to exclude from git
└── README.md         # This file
```

## Package Manager Support

All installation scripts support multiple package managers:
- **apt** (Debian/Ubuntu)
- **pacman** (Arch Linux)
- **dnf** (Fedora/RHEL)

The scripts automatically detect your package manager and use the appropriate commands.

## Notes

- Sensitive files (SSH keys, credentials, etc.) are excluded via `.gitignore`
- History files are not backed up for privacy
- Large cache directories are excluded
- Compiled binaries and object files are excluded
- Build artifacts are excluded

## License

Personal use only.
