-- Force reload function to ensure changes are applied
vim.api.nvim_create_user_command("ReloadConfig", function()
    -- Clear module caches
    for _, module in ipairs({
        "config.options",
        "config.lazy",
        "config.autocmds",
        "config.keymaps",
    }) do
        package.loaded[module] = nil
        require(module)
    end
    
    -- Force plugin sync
    pcall(function()
        vim.cmd("Lazy sync")
    end)
    
    -- Notify the user
    vim.notify("Configuration reloaded successfully!", vim.log.levels.INFO)
end, {})

-- Add keymap for quick access
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("ReloadConfig")
end, { desc = "Reload config" })
