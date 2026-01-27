local api = vim.api

-- Auto-format on save for C/C++
api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
  callback = function()
    -- Try LSP format first, fallback to conform
    local success = pcall(vim.lsp.buf.format, { async = false })
    if not success then
      vim.cmd("FormatWrite")
    end
  end,
})

-- Auto-close brackets and quotes
api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.autoindent = true
    vim.bo.smartindent = true
    vim.bo.cindent = true
  end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Remove trailing whitespace
api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Auto-resize splits
api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Remember last position
api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-save on focus lost
api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command = "silent! wa",
})

-- C/C++ specific settings
api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    -- Set comment string
    vim.bo.commentstring = "// %s"

    -- Set include path for better completion
    vim.bo.include = "^\\s*#\\s*include"
    vim.bo.define = "^\\s*#\\s*define"

    -- Set path for header files
    vim.bo.path = vim.bo.path .. ",/usr/include,/usr/local/include"
  end,
})

-- Auto-compile and run C/C++ files
api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    -- Set makeprg based on file type
    if vim.bo.filetype == "c" then
      vim.bo.makeprg = "gcc -Wall -Wextra -std=c99 % -o %:r"
    elseif vim.bo.filetype == "cpp" then
      vim.bo.makeprg = "g++ -Wall -Wextra -std=c++17 % -o %:r"
    end
  end,
})

-- Quickfix window settings
api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "*",
  callback = function()
    vim.cmd("cwindow")
  end,
})

-- Auto-close quickfix window when it's the last window
api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.bo.buftype == "quickfix" and vim.fn.winnr("$") == 1 then
      vim.cmd("quit")
    end
  end,
})

-- Ensure LSP is attached for C/C++ files
api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    -- Wait a bit for LSP to attach
    vim.defer_fn(function()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        vim.cmd("LspStart clangd")
      end

      -- Generate compile_commands.json if it doesn't exist
      local project_root = vim.fn.getcwd()
      if vim.fn.filereadable(project_root .. "/compile_commands.json") == 0 and
         vim.fn.filereadable(project_root .. "/build/compile_commands.json") == 0 then
        -- Create compile_commands.json with proper include flags
        local cpp_helpers = require("config.cpp-helpers")
        local current_file = vim.fn.expand("%:p")
        local flags = cpp_helpers.get_compile_flags(current_file, project_root)
        local flags_str = table.concat(flags, " ")

        -- Create minimal compile_commands.json with the current file
        local compile_commands = string.format([[
[
  {
    "directory": "%s",
    "command": "clang %s -c %s",
    "file": "%s"
  }
]
]], project_root, flags_str, current_file, current_file)

        vim.fn.mkdir(project_root .. "/build", "p")
        vim.fn.writefile(vim.split(compile_commands, "\n"), project_root .. "/build/compile_commands.json")
        vim.notify("Created compile_commands.json with proper include paths", vim.log.levels.INFO)
      end
    end, 100)
  end,
})

-- Auto-detect headers in includes directory (similar to VSCode)
api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.cpp", "*.c"},
  callback = function()
    -- Get the current buffer's content
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local includes = {}

    -- Find all include statements in the file
    for _, line in ipairs(lines) do
      local include_path = line:match('#%s*include%s*"([^"]+)"')
      if include_path then
        table.insert(includes, include_path)
      end
    end

    -- Process all found include paths
    for _, include_path in ipairs(includes) do
      -- Determine if this is a project include (not a system include)
      if not include_path:match("^<") then
        -- Check common include directory patterns
        local project_root = vim.fn.getcwd()
        local possible_paths = {
          project_root .. "/include/" .. include_path,
          project_root .. "/src/include/" .. include_path,
          project_root .. "/" .. include_path
        }

        -- Create a compilation database entry for this include if needed
        for _, path in ipairs(possible_paths) do
          if vim.fn.filereadable(path) == 1 then
            -- Add to path hints for LSP if not already in compile_commands.json
            local include_dir = vim.fn.fnamemodify(path, ":h")
            -- vim.notify("Found project include: " .. include_path .. " in " .. include_dir, vim.log.levels.INFO)
            break
          end
        end
      end
    end
  end,
})
