return {
  -- Enhanced C/C++ support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--suggest-missing-includes",
            "--all-scopes-completion",
            "--cross-file-rename",
            "--limit-references=1000",
            "--limit-results=1000",
            "--pch-storage=memory",
            "--log=error",
            "--pretty",
            "-j=12",
            "--malloc-trim",
            "--background-index-priority=normal",
            "--enable-config",
            "--include-cleaner-stdlib",
            "--header-insertion=iwyu",
          },
          init_options = {
            compilationDatabaseDirectory = "build",
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
            detectExtensionConflicts = true,
          },
          settings = {
            clangd = {
              arguments = {
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
                "--suggest-missing-includes",
                "--all-scopes-completion",
                "--cross-file-rename",
                "--limit-references=1000",
                "--limit-results=1000",
                "--pch-storage=memory",
                "--log=error",
                "--pretty",
                "-j=12",
                "--malloc-trim",
                "--background-index-priority=normal",
                "--enable-config",
                "--include-cleaner-stdlib",
              },
              includeIneligibleResults = true,
              inlay_hints = {
                parameterNames = true,
                designators = true,
                deducedTypes = true,
              },
              fallbackFlags = {
                "-I${workspaceFolder}/include",
                "-I${workspaceFolder}/src/include",
                -- Standards will be added dynamically by on_new_config
              },
            },
          },
          on_new_config = function(new_config, new_root_dir)
            local cpp_helpers = require("config.cpp-helpers")
            -- Update the clangd flags to include correct standard flags based on file type
            new_config.init_options = new_config.init_options or {}
            
            -- Set different flags for different filetypes
            local bufnr = vim.api.nvim_get_current_buf()
            local filepath = vim.api.nvim_buf_get_name(bufnr)
            
            -- Get appropriate flags for this file
            local flags = cpp_helpers.get_compile_flags(filepath, new_root_dir)
            new_config.init_options.fallbackFlags = flags
          end,
        },
      },
    },
  },

  -- C/C++ snippets
  {
    "L3MON4D3/LuaSnip",
    opts = {
      snippet_engine = "luasnip",
    },
  },

  -- Advanced C/C++ snippets
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
      })
    end,
  },

  -- C/C++ specific treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "cmake",
        "make",
        "bash",
        "json",
        "yaml",
        "markdown",
        "lua",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      autotag = { enable = true },
      context_commentstring = { enable = true },
    },
  },

  -- C/C++ debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- C/C++ debugger configuration
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = "Attach",
          type = "lldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },

  -- C/C++ formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        h = { "clang_format" },
        hpp = { "clang_format" },
        lua = { "stylua" },
      },
      formatters = {
        clang_format = {
          prepend_args = {
            "-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, ColumnLimit: 0, UseTab: Never}",
            "-sort-includes",
            "-assume-filename",
          },
        },
        stylua = {
          prepend_args = {
            "--indent-type", "Spaces",
            "--indent-width", "4",
            "--column-width", "120",
            "--quote-style", "AutoPreferDouble",
            "--no-call-parentheses",
          },
        },
      },
    },
  },

  -- C/C++ project management
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
        },
      },
    },
  },

  -- C/C++ code actions
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      use_diagnostic_signs = true,
    },
  },

  -- C/C++ symbols
  {
    "simrat39/symbols-outline.nvim",
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false,
      position = "right",
      relative_width = true,
      width = 25,
      auto_close = false,
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      preview_bg_highlight = "Pmenu",
      autofold_depth = nil,
      auto_unfold_hover = true,
      fold_markers = { "├", "└" },
      wrap = false,
      keymaps = {
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W-<C-f>",
        unfold_all = "W-<C-m>",
        fold_reset = "R",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
        File = { icon = "󰈙", hl = "@text.uri" },
        Module = { icon = "󰆧", hl = "@namespace" },
        Namespace = { icon = "󰌗", hl = "@namespace" },
        Package = { icon = "󰏖", hl = "@namespace" },
        Class = { icon = "󰌗", hl = "@type" },
        Method = { icon = "󰆧", hl = "@method" },
        Property = { icon = "󰜢", hl = "@method" },
        Field = { icon = "󰇽", hl = "@field" },
        Constructor = { icon = "󰆧", hl = "@constructor" },
        Enum = { icon = "󰒻", hl = "@type" },
        Interface = { icon = "󰒻", hl = "@type" },
        Function = { icon = "󰊕", hl = "@function" },
        Variable = { icon = "󰂡", hl = "@constant" },
        Constant = { icon = "󰏿", hl = "@constant" },
        String = { icon = "󰀬", hl = "@string" },
        Number = { icon = "󰎠", hl = "@number" },
        Boolean = { icon = "◩", hl = "@boolean" },
        Array = { icon = "󰅪", hl = "@constant" },
        Object = { icon = "󰅩", hl = "@type" },
        Key = { icon = "󰌋", hl = "@type" },
        Null = { icon = "󰟢", hl = "@type" },
        EnumMember = { icon = "󰕘", hl = "@field" },
        Struct = { icon = "󰌗", hl = "@type" },
        Event = { icon = "󰅪", hl = "@type" },
        Operator = { icon = "󰆕", hl = "@operator" },
        TypeParameter = { icon = "󰊄", hl = "@parameter" },
        Component = { icon = "󰌗", hl = "@function" },
        Fragment = { icon = "󰐾", hl = "@constant" },
      },
    },
  },
} 