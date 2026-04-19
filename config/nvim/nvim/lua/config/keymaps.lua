local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Better buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Better search
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "*", "*zzzv", opts)
map("n", "#", "#zzzv", opts)

-- Better indentation
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Quick save
map("n", "<C-s>", ":w<CR>", opts)
map("i", "<C-s>", "<Esc>:w<CR>a", opts)

-- Quick quit
map("n", "<C-q>", ":q<CR>", opts)

-- Clear search
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Yank to clipboard
map("n", "<leader>y", '"+y', opts)
map("v", "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+yg_', opts)

-- Paste from clipboard
map("n", "<leader>p", '"+p', opts)
map("v", "<leader>p", '"+p', opts)

-- C/C++ specific mappings
map("n", "<leader>cc", ":!gcc -Wall -Wextra -std=c99 % -o %:r<CR>", opts)
map("n", "<leader>cx", ":!g++ -Wall -Wextra -std=c++17 % -o %:r<CR>", opts)
map("n", "<leader>cr", ":!./%:r<CR>", opts)

-- Debug mappings
map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<leader>dc", ":lua require'dap'.continue()<CR>", opts)
map("n", "<leader>di", ":lua require'dap'.step_into()<CR>", opts)
map("n", "<leader>do", ":lua require'dap'.step_over()<CR>", opts)
map("n", "<leader>du", ":lua require'dap'.step_out()<CR>", opts)

-- LSP mappings
map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>lf", vim.lsp.buf.format, opts)

-- Telescope mappings
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- TreeSitter
map("n", "<leader>ts", ":TSBufToggle highlight<CR>", opts)

-- Git - Use LazyGit instead (<leader>gg)
-- Git shortcuts removed in favor of LazyGit integration

-- Terminal - Enhanced features
-- Toggle terminal in different locations
map("n", "<leader>tt", ":ToggleTerm<CR>", opts)                           -- Default toggle
map("n", "<leader>tf", ":ToggleTerm direction=float<CR>", opts)           -- Floating terminal
map("n", "<leader>tv", ":ToggleTerm direction=vertical size=50<CR>", opts) -- Vertical terminal
map("n", "<leader>th", ":ToggleTerm direction=horizontal size=15<CR>", opts) -- Horizontal terminal

-- Multiple terminals management
map("n", "<leader>t1", ":1ToggleTerm<CR>", opts)                          -- Toggle terminal 1
map("n", "<leader>t2", ":2ToggleTerm<CR>", opts)                          -- Toggle terminal 2
map("n", "<leader>t3", ":3ToggleTerm<CR>", opts)                          -- Toggle terminal 3
map("n", "<leader>t4", ":4ToggleTerm<CR>", opts)                          -- Toggle terminal 4

-- Terminal navigation and interaction
map("t", "<Esc>", "<C-\\><C-n>", opts)                                   -- Exit terminal mode

-- Terminal send command without leaving current buffer
map("n", "<leader>tc", function() 
  local cmd = vim.fn.input("Command: ")
  if cmd ~= "" then
    vim.cmd('TermExec cmd="' .. cmd .. '"')
  end
end, opts)                                                                -- Send command to terminal

-- Quick file operations
map("n", "<leader>e", function()
  -- Prefer LazyVim's Explorer picker when available.
  if _G.Snacks and _G.Snacks.explorer then
    _G.Snacks.explorer()
    return
  end

  -- Fallback for setups where Snacks explorer is unavailable.
  vim.cmd("NvimTreeFindFileToggle")
end, { noremap = true, silent = true, desc = "Open Explorer" })
map("n", "<leader>o", ":NvimTreeFocus<CR>", opts)

-- Pane management
-- Creating splits
map("n", "<leader>-", ":split<CR>", opts)             -- Horizontal split
map("n", "<leader>\\", ":vsplit<CR>", opts)            -- Vertical split
map("n", "<leader>sc", ":close<CR>", opts)            -- Close split

-- Converting between splits
map("n", "<leader>th", "<C-w>t<C-w>H", opts)          -- Change to vertical layout
map("n", "<leader>tk", "<C-w>t<C-w>K", opts)          -- Change to horizontal layout

-- Resize splits
map("n", "<C-Up>", ":resize +5<CR>", opts)            -- Increase height
map("n", "<C-Down>", ":resize -5<CR>", opts)          -- Decrease height
map("n", "<C-Right>", ":vertical resize +5<CR>", opts) -- Increase width
map("n", "<C-Left>", ":vertical resize -5<CR>", opts)  -- Decrease width

-- Equal sizing
map("n", "<leader>=", "<C-w>=", opts)                 -- Make splits equal size

-- Rotate and swap
map("n", "<leader>rr", "<C-w>r", opts)                -- Rotate splits clockwise
map("n", "<leader>rR", "<C-w>R", opts)                -- Rotate splits counter-clockwise
map("n", "<leader>rx", "<C-w>x", opts)                -- Swap current with next

-- Quick edit config
-- map("n", "<leader>ec", ":e ~/.config/nvim/init.lua<CR>", opts)
-- map("n", "<leader>er", ":source ~/.config/nvim/init.lua<CR>", opts) 

-- Quit all
map("n", "<leader>qa", ":qa<CR>", { desc = "Quit all" })
map("v", "<leader>qa", ":qa<CR>", { desc = "Quit all" })