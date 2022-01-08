local M = {}

local Window = {}
Window.__index = Window
M.Window = Window

function Window.open(resource, open, filetype)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.b[bufnr].docfilter = { resource = resource }
  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].filetype = filetype
  vim.bo[bufnr].bufhidden = "wipe"
  -- TODO: set buffer name

  open(bufnr)

  local tbl = { _bufnr = bufnr }
  return setmetatable(tbl, Window)
end

function Window.render(self, lines)
  vim.bo[self._bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(self._bufnr, 0, -1, false, lines)
  vim.bo[self._bufnr].modifiable = false
end

return M
