return {
  -- Explicitly disable all plugins that might cause vertical lines
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
  },
  {
    "folke/edgy.nvim",
    enabled = false,
  },
  
  -- Add a keybinding to reload config
  {
    "LazyVim/LazyVim",
    config = function()
      -- Disable all vertical line highlights
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          -- Clear indent-blankline highlights
          vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "NONE" })
          vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "NONE" })
          vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", { fg = "NONE" })
          vim.api.nvim_set_hl(0, "IndentBlanklineSpaceCharBlankline", { fg = "NONE" })
          
          -- Clear any other vertical line highlights
          vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "NONE" })
          
          -- Disable colorcolumn
          vim.opt.colorcolumn = ""
        end,
      })
      
      -- Add a keymap to reload config
      vim.keymap.set("n", "<leader>cr", function()
        -- Clear Neovim cache
        vim.cmd("LazyClear")
        -- Reload config
        vim.cmd("luafile ~/.config/nvim/init.lua")
        -- Sync plugins
        vim.cmd("Lazy sync")
        -- Notify user
        vim.notify("Config reloaded!", vim.log.levels.INFO)
      end, { desc = "Reload Neovim config" })
    end,
  },
}
