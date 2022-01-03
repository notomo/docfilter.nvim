local M = {}

function M.to_path(module_path)
  module_path = module_path:gsub("%.", "/")
  local path = vim.api.nvim_get_runtime_file(module_path .. ".lua", false)[1]
  if not path then
    return nil, "not found: " .. module_path
  end
  return path, nil
end

return M
