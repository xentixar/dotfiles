local M = {}

-- Helper function to determine appropriate language standard based on file type
function M.get_language_standard(file_path)
  -- Get file extension from path
  local filename = file_path and vim.fn.fnamemodify(file_path, ":e") or vim.fn.expand("%:e")
  
  -- Determine language standard based on extension
  if filename == "cpp" or filename == "hpp" or filename == "cc" or filename == "cxx" then
    return "-std=c++17"
  elseif filename == "c" then
    return "-std=c11"
  else
    -- Default to C standard if we can't determine
    return ""
  end
end

-- Get include directories for the current project
function M.get_include_dirs(root_dir)
  local project_root = root_dir or vim.fn.getcwd()
  
  -- Create a list of include directories
  local include_dirs = {}
  
  -- Add common include directories
  table.insert(include_dirs, "-I" .. project_root .. "/include")
  table.insert(include_dirs, "-I" .. project_root .. "/src/include")
  
  return include_dirs
end

-- Generate compile flags for the current file
function M.get_compile_flags(file_path, root_dir)
  local flags = M.get_include_dirs(root_dir)
  
  -- Add language standard flag if we can determine it
  local std_flag = M.get_language_standard(file_path)
  if std_flag and std_flag ~= "" then
    table.insert(flags, std_flag)
  end
  
  return flags
end

return M
