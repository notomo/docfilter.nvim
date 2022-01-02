local M = {}

--- Open a buffer with conveted resouce.
--- @param resouce string: url or file path
--- @param opts table|nil:
--- @return table: Promise
function M.open(resouce, opts)
  return require("docfilter.command").open(resouce, opts)
end

return M
