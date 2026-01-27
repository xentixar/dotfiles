return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Your preferred style: 'storm', 'moon', 'night', 'day'
      style = "night",
      -- Enable transparent background
      transparent = false,
      -- Make terminal colors compatible
      terminal_colors = true,
      -- Configure other styling options
      styles = {
        comments = { italic = true },
        keywords = { italic = true, bold = true },
        functions = { bold = true },
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      -- Adjusting the brightness for dark styles
      on_colors = function(colors)
        colors.bg = "#1a1b26"  -- Slightly darker background
        colors.bg_dark = "#16161e"
      end,
      -- Custom highlights
      on_highlights = function(highlights, colors)
        -- Better cursor line highlight
        highlights.CursorLine = { bg = "#292e42" }
        -- Better selection color
        highlights.Visual = { bg = "#2E3C64" }
        -- Better floating window colors
        highlights.NormalFloat = { bg = colors.bg_dark }
        highlights.FloatBorder = { fg = colors.blue, bg = colors.bg_dark }
        -- Status line colors
        highlights.StatusLine = { fg = colors.fg, bg = colors.bg_dark }
      end
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },
  
  -- Lualine with Tokyo Night integration
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
