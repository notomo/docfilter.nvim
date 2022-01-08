local M = {}

local Resouce = {}
Resouce.__index = Resouce
M.Resouce = Resouce

local hl_groups = {
  "markdownUrl",
  "markdownLinkText",
  "markdownLinkTextDelimiter",
  "markdownLinkDelimiter",
  "markdownUrlTitle",
}

function Resouce.from_position(position)
  local row, column = unpack(position)

  -- TODO: tree sitter highlight
  local hl_group = vim.fn.synIDattr(vim.fn.synID(row, column + 1, 1), "name")
  if not vim.tbl_contains(hl_groups, hl_group) then
    return nil
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  if not line then
    return nil
  end

  local raw = Resouce._parse(line, column)
  if not raw then
    return nil
  end

  if vim.startswith(raw, "http") then
    return raw
  end

  local state = vim.b[bufnr].docfilter
  local base_path = state.resource or ""
  -- TODO: trim anchor

  if vim.startswith(raw, "#") then
    return base_path .. raw
  end
  return vim.fn.fnamemodify(base_path, ":h") .. "/" .. raw
end

function Resouce._parse(line, column)
  local right = line:sub(column)
  local right_s = right:find("%(")
  if right_s then
    local e = right:find("%)")
    local resouce = right:sub(right_s + 1, e - 1)
    return resouce
  end

  local left = line:sub(1, column)
  local left_s = left:find("%(")
  if left_s then
    local e = right:find("%)")
    local left_part = left:sub(left_s + 1):gsub("%)$", "")
    local resouce = left_part .. right:sub(2, e - 1)
    return resouce
  end
end

return M
