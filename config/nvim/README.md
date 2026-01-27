# Advanced C/C++ Neovim Configuration

A highly optimized Neovim configuration built on LazyVim, specifically designed for C/C++ development with advanced features and productivity tools.

## 🚀 Features

### Core C/C++ Development
- **Advanced LSP Support**: Full clangd integration with comprehensive error checking
- **Intelligent Code Completion**: Context-aware autocompletion with snippets
- **Real-time Diagnostics**: Live error and warning detection
- **Code Formatting**: Automatic clang-format integration
- **Code Linting**: clang-tidy integration for code quality
- **Debugging**: Full debugging support with nvim-dap and LLDB

### Productivity Tools
- **Fuzzy Finder**: Telescope integration for file and symbol search
- **Git Integration**: Git signs, blame, and diff highlighting
- **File Explorer**: NvimTree with file icons and git status
- **Buffer Management**: Smart buffer navigation and management
- **Terminal Integration**: Built-in terminal with toggle support
- **Symbol Outline**: Code structure overview and navigation

### Code Quality
- **Auto-formatting**: Format on save for C/C++ files
- **Syntax Highlighting**: Enhanced TreeSitter highlighting
- **Indent Guides**: Visual indent guides for better code structure
- **Comment Management**: Smart commenting and uncommenting
- **Auto-pairs**: Intelligent bracket and quote pairing
- **Surround**: Easy text surrounding operations

### Advanced Features
- **Flash Search**: Quick navigation within files
- **Better Notifications**: Enhanced notification system
- **Status Line**: Informative status line with git and LSP info
- **Buffer Line**: Tab-like buffer display
- **Auto-save**: Automatic file saving on focus loss
- **Session Management**: Remember cursor positions

## 📋 Prerequisites

### Required Tools
```bash
# Install build tools
sudo apt update
sudo apt install build-essential cmake

# Install clang and clangd
sudo apt install clang clangd clang-tidy clang-format

# Install LLDB for debugging
sudo apt install lldb

# Install ripgrep for search
sudo apt install ripgrep

# Install fd for file finding
sudo apt install fd-find

# Install tree-sitter CLI
npm install -g tree-sitter-cli
```

### Optional Tools
```bash
# Install additional development tools
sudo apt install gdb valgrind cppcheck

# Install git tools
sudo apt install git gitk
```

## 🛠️ Installation

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim_backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone <your-repo> ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

4. **Install plugins** (automatic on first run):
   - LazyVim will automatically install all required plugins
   - Wait for the installation to complete

## ⌨️ Key Mappings

### General Navigation
- `<Space>` - Leader key
- `<C-h/j/k/l>` - Window navigation
- `<S-h/l>` - Buffer navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers

### C/C++ Specific
- `<leader>cc` - Compile C file
- `<leader>cx` - Compile C++ file
- `<leader>cr` - Run compiled program
- `<leader>f` - Format code
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation

### Debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue debugging
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>du` - Step out

### Code Actions
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `gc` - Comment/uncomment line
- `gbc` - Comment/uncomment block
- `ys` - Surround text
- `ds` - Delete surrounding

### File Management
- `<leader>e` - Toggle file explorer
- `<leader>sv` - Vertical split
- `<leader>sh` - Horizontal split
- `<leader>sc` - Close window

### Terminal
- `<C-\>` - Toggle terminal
- `<Esc>` - Exit terminal mode

## 🎨 Customization

### Colorscheme
The configuration uses Catppuccin theme by default. To change:

1. Edit `lua/config/lazy.lua`
2. Change the `colorscheme` in the install section
3. Restart Neovim

### Key Mappings
Customize key mappings in `lua/config/keymaps.lua`

### Options
Modify Neovim options in `lua/config/options.lua`

### Plugins
Add or remove plugins in the `lua/plugins/` directory

## 🔧 Configuration Files

- `init.lua` - Main entry point
- `lua/config/lazy.lua` - Plugin manager configuration
- `lua/config/options.lua` - Neovim options
- `lua/config/keymaps.lua` - Key mappings
- `lua/config/autocmds.lua` - Auto-commands
- `lua/plugins/cpp.lua` - C/C++ specific plugins
- `lua/plugins/advanced.lua` - Advanced productivity plugins

## 🐛 Troubleshooting

### LSP Issues
1. Ensure clangd is installed: `which clangd`
2. Check LSP status: `:LspInfo`
3. Restart LSP: `:LspRestart`

### Plugin Issues
1. Update plugins: `:Lazy sync`
2. Check plugin status: `:Lazy`
3. Clear plugin cache: `:Lazy clean`

### Performance Issues
1. Check startup time: `:StartupTime`
2. Disable heavy plugins if needed
3. Optimize TreeSitter parsers

## 📚 Additional Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Neovim Documentation](https://neovim.io/doc/)
- [clangd Documentation](https://clangd.llvm.org/)
- [TreeSitter Documentation](https://tree-sitter.github.io/tree-sitter/)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License. 