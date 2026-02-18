return {
  -- PHP LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- PHP Intelephense
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
                associations = { "*.php", "*.phtml", "*.blade.php" },
                exclude = {
                  "**/.git/**",
                  "**/.svn/**",
                  "**/.hg/**",
                  "**/CVS/**",
                  "**/.DS_Store/**",
                  "**/node_modules/**",
                  "**/bower_components/**",
                  "**/vendor/**/{Tests,tests}/**",
                  "**/.history/**",
                  "**/vendor/**/vendor/**",
                },
              },
              stubs = {
                "apache",
                "bcmath",
                "bz2",
                "calendar",
                "com_dotnet",
                "Core",
                "ctype",
                "curl",
                "date",
                "dba",
                "dom",
                "enchant",
                "exif",
                "FFI",
                "fileinfo",
                "filter",
                "fpm",
                "ftp",
                "gd",
                "gettext",
                "gmp",
                "hash",
                "iconv",
                "imap",
                "intl",
                "json",
                "ldap",
                "libxml",
                "mbstring",
                "meta",
                "mysqli",
                "oci8",
                "odbc",
                "openssl",
                "pcntl",
                "pcre",
                "PDO",
                "pdo_ibm",
                "pdo_mysql",
                "pdo_pgsql",
                "pdo_sqlite",
                "pgsql",
                "Phar",
                "posix",
                "pspell",
                "readline",
                "Reflection",
                "session",
                "shmop",
                "SimpleXML",
                "snmp",
                "soap",
                "sockets",
                "sodium",
                "SPL",
                "sqlite3",
                "standard",
                "superglobals",
                "sysvmsg",
                "sysvsem",
                "sysvshm",
                "tidy",
                "tokenizer",
                "xml",
                "xmlreader",
                "xmlrpc",
                "xmlwriter",
                "xsl",
                "Zend OPcache",
                "zip",
                "zlib",
                -- Laravel specific
                "Laravel",
                "Livewire",
                "Nova",
                "Cashier",
                "Dusk",
                "Echo",
                "Horizon",
                "Jetstream",
                "Mix",
                "Passport",
                "Sail",
                "Sanctum",
                "Scout",
                "Socialite",
                "Spark",
                "Telescope",
                "Tinker",
                "Vapor",
              },
              completion = {
                fullyQualifyGlobalConstantsAndFunctions = false,
                triggerParameterHints = true,
                insertUseDeclaration = true,
                maxItems = 100,
              },
              format = {
                enable = true,
                braces = "psr12",
              },
              environment = {
                includePaths = {},
                phpVersion = "8.3.0",
                shortOpenTag = false,
              },
              diagnostics = {
                enable = true,
                run = "onType",
                embeddedLanguages = true,
              },
              telemetry = {
                enabled = false,
              },
              phpdoc = {
                returnVoid = true,
                textFormat = "text",
                classTemplate = {
                  summary = "$1",
                  description = "",
                  tags = {
                    "author ${1:Author Name}",
                    "package ${1:PackageName}",
                  },
                },
                propertyTemplate = {
                  summary = "$1",
                  description = "",
                  tags = {
                    "var ${1:mixed}",
                  },
                },
                functionTemplate = {
                  summary = "$1",
                  description = "",
                  tags = {
                    "param ${1:mixed} $${2:paramName}",
                    "return ${1:mixed}",
                    "throws ${1:Exception}",
                  },
                },
              },
              rename = {
                exclude = {
                  "**/vendor/**",
                  "**/node_modules/**",
                },
                namespaceMode = "single",
              },
            },
          },
        },
      },
    },
  },

  -- Blade Templating Support for Laravel
  {
    "jwalton512/vim-blade",
    ft = { "blade" },
  },

  -- Better PHP Syntax
  {
    "StanAngeloff/php.vim",
    ft = { "php", "blade" },
  },

  -- Laravel Blade Snippets
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
          })
        end,
      },
    },
  },

  -- Treesitter configuration for PHP
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "php", "phpdoc", "php_only" })
      end
    end,
  },

  -- Mason for installing PHP tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "intelephense",
        "phpstan",
        "php-cs-fixer",
        "blade-formatter",
      })
    end,
  },

  -- Laravel.nvim for Laravel-specific features
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
    },
    cmd = { "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lr", ":Laravel routes<cr>", desc = "Laravel Routes" },
      { "<leader>lm", ":Laravel related<cr>", desc = "Laravel Related Files" },
    },
    event = { "VeryLazy" },
    config = function()
      require("laravel").setup({
        lsp_server = "intelephense",
        features = {
          null_ls = {
            enable = true,
          },
          route_info = {
            enable = true,
            position = "top",
          },
        },
      })
    end,
  },

  -- PHP Refactoring tools
  {
    "phpactor/phpactor",
    build = "composer install --no-dev --optimize-autoloader",
    ft = { "php", "blade" },
    keys = {
      { "<leader>pm", ":PhpactorContextMenu<cr>", desc = "PHP Context Menu", ft = "php" },
      { "<leader>pn", ":PhpactorClassNew<cr>", desc = "PHP New Class", ft = "php" },
      { "<leader>pi", ":PhpactorImportClass<cr>", desc = "PHP Import Class", ft = "php" },
      { "<leader>pe", ":PhpactorExtractMethod<cr>", desc = "PHP Extract Method", ft = "php", mode = "v" },
    },
  },

  -- PHP Debugging with XDebug (optional)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "php-debug-adapter" })
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          log = false,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
      }
    end,
  },

  -- Conform for PHP formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" },
        blade = { "blade-formatter" },
      },
      formatters = {
        php_cs_fixer = {
          command = "php-cs-fixer",
          args = {
            "fix",
            "$FILENAME",
            "--rules=@PSR12",
            "--using-cache=no",
          },
          stdin = false,
        },
      },
    },
  },

  -- Linting with PHPStan
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        php = { "phpstan" },
      },
    },
  },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = false, -- We'll set up custom Tab behavior below
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          php = true,
          blade = true,
          ["*"] = true,
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
      })
    end,
  },

  -- Copilot CMP integration (disabled - using inline suggestions instead)
  -- Uncomment if you have nvim-cmp installed and want completion menu integration
  --[[
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Update nvim-cmp to include copilot source
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "zbirenbaum/copilot-cmp" },
    },
    opts = function(_, opts)
      local has_copilot = pcall(require, "copilot_cmp")
      if has_copilot then
        opts.sources = opts.sources or {}
        table.insert(opts.sources, 1, { name = "copilot", group_index = 2 })
        
        -- Add copilot formatting
        if not opts.formatting then
          opts.formatting = {}
        end
        local format_kinds = opts.formatting.format
        opts.formatting.format = function(entry, item)
          if entry.source.name == "copilot" then
            item.kind = "🤖 Copilot"
            item.kind_hl_group = "CmpItemKindCopilot"
            return item
          end
          if format_kinds then
            return format_kinds(entry, item)
          end
          return item
        end
      end
      return opts
    end,
  },
  --]]
}
