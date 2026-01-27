-- Set up Tokyo Night colorscheme immediately
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    -- Set the colorscheme to Tokyo Night
    pcall(function()
      vim.cmd.colorscheme("tokyonight")
    end)
    
    -- If it fails, fall back to a built-in colorscheme
    if not vim.g.colors_name then
      pcall(function()
        vim.cmd.colorscheme("habamax")
      end)
    end
  end,
})
