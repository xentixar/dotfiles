return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false, -- We handle this in keymaps.lua
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        ["."] = false,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      model = "gpt-4",
      temperature = 0.1,
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      separator = "───",
      show_folds = true,
      show_help = true,
      auto_follow_cursor = true,
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,
      context = nil,
      history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
      callback = nil,
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
          callback = function(response, source)
            -- Optionally process the response
          end,
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Please generate tests for my code.",
        },
        FixDiagnostic = {
          prompt = "Please assist with the following diagnostic issue in file:",
          selection = function(source)
            return require("CopilotChat.select").diagnostics(source)
          end,
        },
        Commit = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source, true)
          end,
        },
      },
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.4, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = "Copilot Chat", -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
      mappings = {
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<C-r>",
          insert = "<C-r>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        yank_diff = {
          normal = "gy",
        },
        show_diff = {
          normal = "gd",
        },
        show_system_prompt = {
          normal = "gp",
        },
        show_user_selection = {
          normal = "gs",
        },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      
      chat.setup(opts)

      -- Create user commands
      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatModels", function()
        require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").help_actions())
      end, {})
    end,
    event = "VeryLazy",
    keys = {
      -- Quick chat toggle
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Explain", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Copilot Generate Tests", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Copilot Review Code", mode = { "n", "v" } },
      { "<leader>cR", "<cmd>CopilotChatRefactor<cr>", desc = "Copilot Refactor", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Copilot Fix", mode = { "n", "v" } },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Copilot Optimize", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Copilot Docs", mode = { "n", "v" } },
      { "<leader>cD", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Copilot Fix Diagnostic" },
      { "<leader>cm", "<cmd>CopilotChatCommit<cr>", desc = "Copilot Generate Commit" },
      { "<leader>cM", "<cmd>CopilotChatCommitStaged<cr>", desc = "Copilot Generate Commit (Staged)" },
      
      -- Inline chat
      {
        "<leader>ci",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Copilot Quick Chat",
        mode = { "n", "v" },
      },
      
      -- Visual mode chat
      {
        "<leader>cv",
        ":CopilotChatVisual ",
        desc = "Copilot Chat Visual",
        mode = "v",
      },
      
      -- Inline chat in visual mode
      {
        "<leader>cI",
        ":CopilotChatInline<cr>",
        desc = "Copilot Inline Chat",
        mode = "v",
      },
    },
  },
}
