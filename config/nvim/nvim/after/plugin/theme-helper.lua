-- Create a command to set Tokyo Night colorscheme directly
vim.api.nvim_create_user_command("TokyoNight", function()
  vim.cmd.colorscheme("tokyonight")
  vim.notify("Tokyo Night theme applied!", vim.log.levels.INFO)
end, {})

-- Add keymap for quick theme switching
vim.keymap.set("n", "<leader>ct", function()
  vim.cmd("TokyoNight")
end, { desc = "Set Tokyo Night theme" })
