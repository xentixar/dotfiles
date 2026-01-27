return {
  -- Completely disable indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  
  -- Override LazyVim colorscheme
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "tokyonight",
  --   },
  -- },

  { "projekt0n/github-nvim-theme", config = function()
    vim.g.github_theme = "light"
end }
} 