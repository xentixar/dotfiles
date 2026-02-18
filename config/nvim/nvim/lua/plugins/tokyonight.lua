return {
  -- Tokyo Night with Gruvbox background (hybrid theme)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true, bold = true },
        functions = { bold = true },
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      -- Override with Gruvbox background colors
      on_colors = function(colors)
        colors.bg = "#282828"        -- Gruvbox background
        colors.bg_dark = "#1d2021"   -- Gruvbox dark background
        colors.bg_highlight = "#3c3836" -- Gruvbox highlight
        colors.bg_sidebar = "#282828"
        colors.bg_statusline = "#282828"
        colors.bg_float = "#282828"
      end,
      on_highlights = function(highlights, colors)
        -- Use Gruvbox background for all UI elements
        highlights.Normal = { fg = colors.fg, bg = "#282828" }
        highlights.NormalFloat = { bg = "#282828" }
        highlights.NormalNC = { fg = colors.fg, bg = "#282828" }
        highlights.CursorLine = { bg = "#3c3836" }
        highlights.Visual = { bg = "#504945" }
        highlights.FloatBorder = { fg = colors.blue, bg = "#282828" }
        highlights.StatusLine = { fg = colors.fg, bg = "#282828" }
        highlights.SignColumn = { bg = "#282828" }
        highlights.LineNr = { bg = "#282828" }
        highlights.CursorLineNr = { bg = "#282828" }
      end
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },
  
  -- Lualine with Tokyo Night theme
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "tokyonight",
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
          globalstatus = true,
        },
        sections = {
          lualine_a = {{'mode', icon = ''}},
          lualine_b = {{'branch', icon = ''}, 'diff', 'diagnostics'},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'},
        },
        extensions = {"lazy", "mason", "nvim-tree", "trouble"},
      }
    end,
  },
}
