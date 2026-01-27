# 🚀 Professional Emacs Configuration for C/C++ Development

A modern, comprehensive Emacs setup optimized for professional C/C++ development with LSP support, advanced debugging, intelligent completion, and powerful project management tools.

## ✨ Features

### Core Development Tools
- **LSP (Language Server Protocol)** with clangd for intelligent code completion, navigation, and refactoring
- **DAP (Debug Adapter Protocol)** for advanced debugging with GDB/LLDB
- **Company Mode** with company-box for beautiful auto-completion
- **Flycheck** for real-time syntax checking and linting
- **Clang-format** integration for consistent code formatting
- **Modern C++ font-lock** for enhanced syntax highlighting

### Project Management
- **Projectile** for efficient project navigation and management
- **Treemacs** for visual file tree navigation
- **Magit** for powerful Git integration
- **CMake mode** with syntax highlighting for build configuration

### Code Navigation & Editing
- **Vertico + Orderless + Marginalia** for modern completion UI
- **Consult** for enhanced searching and navigation
- **LSP UI** with peek definitions, hover documentation, and sideline diagnostics
- **Avy** for fast cursor movement
- **Multiple cursors** for simultaneous editing
- **Smartparens** for intelligent parenthesis handling
- **Rainbow delimiters** for visual bracket matching
- **Expand region** for smart text selection

### Developer Experience
- **Doom modeline** with beautiful status bar
- **Dracula theme** for comfortable viewing
- **Which-key** for discoverable keybindings
- **Diff-hl** for git diff visualization in the gutter
- **HL-todo** for highlighting TODO, FIXME, etc.
- **YASnippet** for code snippets
- **Helpful** for better help documentation
- **Vterm** for terminal integration

## 📋 Prerequisites

### Required Tools

1. **Emacs** (version 27.1 or higher)
   ```bash
   # Ubuntu/Debian
   sudo apt install emacs
   
   # Fedora
   sudo dnf install emacs
   
   # Arch
   sudo pacman -S emacs
   
   # macOS
   brew install emacs
   ```

2. **clangd** (LSP server for C/C++)
   ```bash
   # Ubuntu/Debian
   sudo apt install clangd-12  # or later version
   
   # Fedora
   sudo dnf install clang-tools-extra
   
   # Arch
   sudo pacman -S clang
   
   # macOS
   brew install llvm
   ```

3. **CMake** (for project builds)
   ```bash
   # Ubuntu/Debian
   sudo apt install cmake
   
   # Fedora
   sudo dnf install cmake
   
   # Arch
   sudo pacman -S cmake
   
   # macOS
   brew install cmake
   ```

4. **GDB** (for debugging)
   ```bash
   # Ubuntu/Debian
   sudo apt install gdb
   
   # Fedora
   sudo dnf install gdb
   
   # Arch
   sudo pacman -S gdb
   
   # macOS (use lldb which comes with Xcode)
   xcode-select --install
   ```

### Optional but Recommended

5. **ripgrep** (for fast searching)
   ```bash
   # Ubuntu/Debian
   sudo apt install ripgrep
   
   # Fedora
   sudo dnf install ripgrep
   
   # Arch
   sudo pacman -S ripgrep
   
   # macOS
   brew install ripgrep
   ```

6. **clang-format** (code formatting)
   ```bash
   # Usually comes with clang
   # Ubuntu/Debian
   sudo apt install clang-format
   
   # Fedora
   sudo dnf install clang-tools-extra
   
   # Arch
   sudo pacman -S clang
   
   # macOS
   brew install clang-format
   ```

7. **Git** (version control)
   ```bash
   sudo apt install git  # Ubuntu/Debian
   sudo dnf install git  # Fedora
   sudo pacman -S git    # Arch
   brew install git      # macOS
   ```

## 🚀 Installation

1. **Backup existing configuration** (if any):
   ```bash
   mv ~/.emacs.d ~/.emacs.d.backup
   ```

2. **Clone or copy this configuration**:
   ```bash
   # If using git
   git clone <your-repo> ~/.emacs.d
   
   # Or copy the init.el file
   mkdir -p ~/.emacs.d
   cp init.el ~/.emacs.d/
   ```

3. **Start Emacs**:
   ```bash
   emacs
   ```
   
   The first startup will take a few minutes as it downloads and installs all packages automatically.

4. **Install JetBrains Mono font** (optional but recommended):
   ```bash
   # Download from: https://www.jetbrains.com/lp/mono/
   # Or use your package manager:
   
   # Ubuntu/Debian
   sudo apt install fonts-jetbrains-mono
   
   # Arch
   sudo pacman -S ttf-jetbrains-mono
   
   # macOS
   brew tap homebrew/cask-fonts
   brew install --cask font-jetbrains-mono
   ```

## 📖 Usage Guide

### Basic Keybindings

#### File Operations
- `C-x C-f` - Find file
- `C-x C-s` - Save file
- `C-x s` - Save all files
- `C-x C-c` - Quit Emacs

#### Project Management
- `C-c p f` - Find file in project
- `C-c p s` - Switch project
- `C-c p g` - Grep in project
- `C-x t t` - Toggle treemacs

#### Code Navigation
- `M-.` - Jump to definition (LSP peek)
- `M-?` - Find references (LSP peek)
- `C-c l g d` - Go to definition
- `C-c l g r` - Find references
- `C-c l r r` - Rename symbol
- `C-c o` - Switch between header/source file
- `M-g i` - Jump to symbol (imenu)
- `C-:` - Jump to character (avy)

#### Completion & Documentation
- `TAB` - Complete (in company popup)
- `C-n/C-p` - Navigate completion candidates
- `C-c d` - Show documentation at point
- `C-c h` - Hide documentation
- `C-h f` - Describe function (helpful)
- `C-h v` - Describe variable (helpful)

#### Compilation & Building
- `<F5>` - Compile and run current file
- `<F6>` - Build with CMake
- `C-c m` - Build with Make
- `C-c t` - Run tests
- `C-c C-f` - Format buffer with clang-format
- `C-c C-r` - Format region with clang-format

#### Debugging
- `M-x dap-debug` - Start debugging
- `<F7>` - Step into
- `<F8>` - Step over
- `<F9>` - Continue
- `M-x gdb` - Start GDB

#### Git Operations
- `C-x g` - Magit status
- `C-c g` - Magit file dispatch
- Magit status buffer:
  - `s` - Stage file/hunk
  - `u` - Unstage
  - `c c` - Commit
  - `P p` - Push
  - `F p` - Pull

#### Search & Replace
- `C-s` - Search forward
- `C-r` - Search backward
- `M-s l` - Consult line (interactive line search)
- `M-s r` - Consult ripgrep (project-wide search)
- `M-%` - Query replace

#### Window Management
- `C-x 1` - Delete other windows
- `C-x 2` - Split window below
- `C-x 3` - Split window right
- `C-x 0` - Delete current window
- `M-o` - Ace window (quick switch)
- `C-c <left>` - Winner undo
- `C-c <right>` - Winner redo

#### Code Editing
- `C-=` - Expand region
- `M-;` - Smart comment/uncomment
- `C->` - Multiple cursors: mark next
- `C-<` - Multiple cursors: mark previous
- `C-S-c C-S-c` - Multiple cursors: edit lines

#### Terminal
- `C-c v` - Open vterm

### LSP Features

Once you open a C/C++ file, LSP will automatically activate. Available commands:

- `C-c l` - LSP command prefix
- `C-c l g g` - Find definitions
- `C-c l g r` - Find references
- `C-c l g i` - Find implementations
- `C-c l r r` - Rename
- `C-c l r o` - Organize imports
- `C-c l a a` - Execute code action
- `C-c l F r` - Format region
- `C-c l F b` - Format buffer
- `C-c l G g` - Peek definitions
- `C-c l h h` - Show hover info

### Project Setup

#### For CMake Projects

1. Create a `compile_commands.json` file:
   ```bash
   cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build
   ln -s build/compile_commands.json .
   ```

2. Open any source file and LSP will automatically use the compile commands.

#### For Single Files

LSP will work with single files using default system includes.

#### Custom .clang-format

Create a `.clang-format` file in your project root:

```yaml
---
BasedOnStyle: LLVM
IndentWidth: 4
ColumnLimit: 100
BreakBeforeBraces: Allman
AllowShortFunctionsOnASingleLine: Empty
...
```

### Creating C++ Projects

1. **Create a new project directory**:
   ```bash
   mkdir my-cpp-project
   cd my-cpp-project
   ```

2. **Create CMakeLists.txt**:
   ```cmake
   cmake_minimum_required(VERSION 3.10)
   project(MyProject)
   
   set(CMAKE_CXX_STANDARD 17)
   set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
   
   add_executable(my_program main.cpp)
   ```

3. **Open in Emacs**:
   ```bash
   emacs main.cpp
   ```

4. **Build and run** with `<F6>` or `<F5>`

## 🎨 Customization

### Changing Theme

Edit `init.el` and replace the theme:

```elisp
(use-package dracula-theme
  :config (load-theme 'dracula t))
```

Popular alternatives:
- `doom-themes` - Multiple themes from Doom Emacs
- `solarized-theme` - Classic Solarized
- `gruvbox-theme` - Retro groove colors
- `zenburn-theme` - Low contrast theme

### Adjusting Font

Change this line in `init.el`:

```elisp
(set-frame-font "JetBrains Mono-13" nil t)
```

Replace with your preferred font and size.

### Modifying LSP Settings

Adjust clangd arguments in the `lsp-mode` configuration:

```elisp
(lsp-clients-clangd-args '("--background-index"
                           "--clang-tidy"
                           "--completion-style=detailed"
                           "--header-insertion=iwyu"
                           "--header-insertion-decorators"
                           "--all-scopes-completion"
                           "--pch-storage=memory"))
```

### Enable Auto-formatting on Save

Uncomment this line in the `clang-format` configuration:

```elisp
(add-hook 'before-save-hook 'pb/clang-format-on-save)
```

### Adding Project Directories

Modify the `projectile-project-search-path`:

```elisp
(setq projectile-project-search-path '("~/Projects" "~/Work" "~/Code" "~/your-path"))
```

## 🐛 Troubleshooting

### LSP Not Starting

1. Check if clangd is installed:
   ```bash
   which clangd
   ```

2. Check LSP logs: `M-x lsp-describe-session`

3. Restart LSP: `M-x lsp-workspace-restart`

### Slow Performance

1. Increase GC threshold (already set in config)
2. Disable some LSP features:
   ```elisp
   (setq lsp-enable-symbol-highlighting nil)
   (setq lsp-ui-doc-enable nil)
   ```

### Company Completion Not Working

1. Check if company-mode is active: `M-x company-mode`
2. Try manual completion: `M-x company-complete`
3. Check company backends: `M-x describe-variable RET company-backends`

### Font Not Applied

1. Install the font system-wide
2. Restart Emacs
3. Check available fonts: `M-x describe-font`

### Packages Not Installing

1. Refresh package list: `M-x package-refresh-contents`
2. Check your internet connection
3. Try installing manually: `M-x package-install RET package-name`

## 📚 Learning Resources

### Emacs Basics
- [Emacs Tutorial](https://www.gnu.org/software/emacs/tour/) - Built-in tutorial (`C-h t`)
- [Mastering Emacs](https://www.masteringemacs.org/) - Comprehensive Emacs guide
- [EmacsWiki](https://www.emacswiki.org/) - Community wiki

### C/C++ Development
- [clangd Documentation](https://clangd.llvm.org/) - LSP server docs
- [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
- [Modern C++ Guide](https://github.com/isocpp/CppCoreGuidelines)

### Packages Documentation
- [LSP Mode](https://emacs-lsp.github.io/lsp-mode/)
- [Projectile](https://docs.projectile.mx/projectile/index.html)
- [Magit User Manual](https://magit.vc/manual/magit/)
- [Company Mode](https://company-mode.github.io/)

## 🤝 Contributing

Feel free to customize this configuration to your needs! Some ideas:

- Add support for other languages (Python, Rust, etc.)
- Integrate with Docker for containerized development
- Add custom snippets for your coding patterns
- Create project templates

## 📝 License

This configuration is free to use and modify for personal or commercial purposes.

## 👤 Author

**Pawan Bhatta (xentixar)**

## 🙏 Acknowledgments

- Emacs community for the amazing ecosystem
- LSP Mode developers
- Clangd team
- All package maintainers

---

**Happy Coding! 🚀**

For questions or issues, check the documentation or visit the Emacs community forums.
