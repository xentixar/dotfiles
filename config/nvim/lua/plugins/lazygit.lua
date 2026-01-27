return {
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim", -- Ensure toggleterm is available
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
      { "<leader>lG", "<cmd>LazyGitConfig<CR>", desc = "LazyGit Config" },
      { "<leader>lF", "<cmd>LazyGitCurrentFile<CR>", desc = "LazyGit Current File" },
    },
    config = function()
      -- Configuration is handled by the plugin defaults
    end,
  },
}
