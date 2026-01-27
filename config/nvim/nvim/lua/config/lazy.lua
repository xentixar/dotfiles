local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    
    -- Advanced C/C++ support
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    
    -- Essential tools
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    
    -- Custom plugins
    { import = "plugins" },
    
    -- Override indent-blankline to disable it
    {
      "lukas-reineke/indent-blankline.nvim",
      enabled = false,
    },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})



-- Disable indent-blankline plugin
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "NONE" })
    vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "NONE" })
    vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", { fg = "NONE" })
    vim.api.nvim_set_hl(0, "IndentBlanklineSpaceCharBlankline", { fg = "NONE" })
  end,
})
