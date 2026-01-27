return {
  -- Markdown preview (in-editor, pure Lua, no external dependencies)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({
        headings = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
        bullets = { "󰅪 ", "󰅩 ", "󰅨 " },
        code_blocks = {
          highlight = true,
          line_numbers = true,
        },
        links = {
          enabled = true,
          underline = true,
        },
        emphasis = {
          bold = true,
          italic = true,
          underline = true,
          strikethrough = true,
        },
        horizontal_rule = "─",
        blockquote = "│",
      })

      -- Keybindings for markdown preview
      vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown<CR>", { desc = "Render Markdown Preview", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>mc", "<cmd>RenderMarkdownClose<CR>", { desc = "Close Markdown Preview", noremap = true, silent = true })
    end,
  },
}
