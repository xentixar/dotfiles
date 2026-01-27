# Emacs C/C++ Development Quick Reference

## Essential Keybindings

### File & Buffer Management
| Key         | Command                    |
|-------------|----------------------------|
| `C-x C-f`   | Find/open file            |
| `C-x C-s`   | Save file                 |
| `C-x s`     | Save all buffers          |
| `C-x k`     | Kill buffer               |
| `C-x b`     | Switch buffer (consult)   |

### Project Management (Projectile)
| Key         | Command                    |
|-------------|----------------------------|
| `C-c p f`   | Find file in project      |
| `C-c p s`   | Switch project            |
| `C-c p g`   | Grep in project           |
| `C-c p c`   | Compile project           |

### Code Navigation
| Key         | Command                    |
|-------------|----------------------------|
| `M-.`       | Jump to definition (peek) |
| `M-?`       | Find references (peek)    |
| `C-c o`     | Switch header/source      |
| `M-g i`     | Jump to symbol (imenu)    |
| `C-:`       | Jump to char (avy)        |
| `C-c l g d` | LSP go to definition      |
| `C-c l g r` | LSP find references       |

### Compilation & Build
| Key         | Command                    |
|-------------|----------------------------|
| `<F5>`      | Compile & run current file|
| `<F6>`      | Build with CMake          |
| `C-c m`     | Build with Make           |
| `C-c t`     | Run tests                 |
| `C-c C-f`   | Format buffer (clang)     |
| `C-c C-r`   | Format region (clang)     |

### Debugging
| Key         | Command                    |
|-------------|----------------------------|
| `M-x gdb`   | Start GDB                 |
| `<F7>`      | Step into (DAP)           |
| `<F8>`      | Step over (DAP)           |
| `<F9>`      | Continue (DAP)            |

### Code Editing
| Key           | Command                      |
|---------------|------------------------------|
| `C-=`         | Expand region                |
| `M-;`         | Smart comment/uncomment      |
| `C->`         | Mark next like this (MC)     |
| `C-<`         | Mark previous like this (MC) |
| `C-S-c C-S-c` | Edit lines (MC)              |
| `TAB`         | Complete (company)           |

### Search & Replace
| Key         | Command                    |
|-------------|----------------------------|
| `C-s`       | Search forward            |
| `C-r`       | Search backward           |
| `M-s l`     | Consult line search       |
| `M-s r`     | Ripgrep project           |
| `M-%`       | Query replace             |

### Git (Magit)
| Key         | Command                    |
|-------------|----------------------------|
| `C-x g`     | Magit status              |
| `C-c g`     | Magit file dispatch       |
| In Magit:   |                           |
| `s`         | Stage                     |
| `u`         | Unstage                   |
| `c c`       | Commit                    |
| `P p`       | Push                      |
| `F p`       | Pull                      |

### Window Management
| Key         | Command                    |
|-------------|----------------------------|
| `C-x 1`     | Delete other windows      |
| `C-x 2`     | Split below               |
| `C-x 3`     | Split right               |
| `C-x 0`     | Delete window             |
| `M-o`       | Ace window                |
| `C-c <left>`| Winner undo               |

### Help & Documentation
| Key         | Command                    |
|-------------|----------------------------|
| `C-h f`     | Describe function         |
| `C-h v`     | Describe variable         |
| `C-h k`     | Describe key              |
| `C-c d`     | Show LSP documentation    |
| `C-h t`     | Emacs tutorial            |

### LSP Commands (C-c l prefix)
| Key           | Command                    |
|---------------|----------------------------|
| `C-c l g g`   | Go to definition          |
| `C-c l g r`   | Find references           |
| `C-c l r r`   | Rename symbol             |
| `C-c l a a`   | Code actions              |
| `C-c l F b`   | Format buffer             |

## Common Workflows

### Starting a New Project
```bash
~/.emacs.d/scripts/new-project.sh my-project
cd ~/Projects/my-project
emacs src/main.cpp
```

### Opening Existing Project
```
1. Open any file: C-x C-f ~/project/file.cpp
2. Find file in project: C-c p f
3. Build: F6 or C-c m
```

### Debugging Session
```
1. Compile with debug: F6
2. Start debugger: M-x dap-debug
3. Set breakpoints: M-x dap-breakpoint-toggle
4. Step through: F7 (step-in), F8 (next), F9 (continue)
```

### Code Navigation
```
1. Jump to definition: M-.
2. Find usages: M-?
3. Go back: M-,
4. Jump to symbol: M-g i
```

## Tips & Tricks

- **Restart LSP**: `M-x lsp-workspace-restart`
- **Kill completion**: `C-g`
- **Eval elisp**: `M-:` then type expression
- **Bookmark location**: `C-x r m`
- **Jump to bookmark**: `C-x r b`
- **Undo**: `C-/` or `C-x u`
- **Redo**: `C-g C-/`

## Custom Functions

- `pb/switch-between-header-source` - Switch .h ↔ .cpp (C-c o)
- `pb/insert-header-guard` - Add header guards
- `pb/create-cpp-class` - Create class skeleton
- `pb/compile-and-run` - Quick compile & run (F5)

## Configuration Files

- **Main config**: `~/.emacs.d/init.el`
- **Git ignore**: `~/.emacs.d/.gitignore`
- **Templates**: `~/.emacs.d/templates/`
- **Scripts**: `~/.emacs.d/scripts/`

## Package Management

- **Install package**: `M-x package-install`
- **Update packages**: `M-x package-upgrade-all`
- **Refresh list**: `M-x package-refresh-contents`
- **List packages**: `M-x package-list-packages`

---

**Remember**: `C-` = Ctrl, `M-` = Alt, `S-` = Shift

For more help, press `C-h ?` or visit the README.md
