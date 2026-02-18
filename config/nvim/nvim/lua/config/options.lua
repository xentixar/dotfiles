local opt = vim.opt

-- Ensure buffer is modifiable
vim.o.modifiable = true

-- Performance
opt.lazyredraw = true
opt.updatetime = 100
opt.timeoutlen = 100  -- Show which-key menu immediately after pressing Space

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Indent
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
-- Disable cursorcolumn to remove vertical line
opt.cursorcolumn = false
opt.signcolumn = "yes"
-- Disable colorcolumn to remove vertical lines
opt.colorcolumn = ""
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- File
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
-- Remove fileformat setting as it may be causing issues
-- opt.fileformat = "unix"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Terminal
opt.termguicolors = true
opt.showmode = false

-- Add window borders for better visual separation
opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
  eob = ' ', -- Empty space at end of buffer
  fold = ' ',
  foldopen = 'v',
  foldsep = ' ',
  foldclose = '>'
}

-- C/C++ specific
opt.cindent = true
opt.cinoptions = "g0,:0,(0"

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Split
opt.splitbelow = true
opt.splitright = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Mouse
opt.mouse = "a"

-- Hidden buffers
opt.hidden = true

-- Wildmenu
opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- Status line
opt.laststatus = 3
opt.showcmd = false

-- Backup

-- Fix CTRL-S terminal flow control
vim.cmd([[
  " Fix CTRL-S terminal flow control issue
  silent !stty -ixon 2>/dev/null
  
  " Map CTRL-S in all modes to save
  nnoremap <C-S> :update<CR>
  vnoremap <C-S> <C-C>:update<CR>
  inoremap <C-S> <C-O>:update<CR>
]])
opt.backupdir = vim.fn.stdpath("data") .. "/backup"
opt.directory = vim.fn.stdpath("data") .. "/swap"

-- Grep
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m" 