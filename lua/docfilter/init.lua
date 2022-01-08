local M = {}

--- Open a buffer with conveted resouce.
--- @param resouce string: url or file path
--- @param opts table|nil:
--- @return table: Promise
function M.open(resouce, opts)
  return require("docfilter.command").open(resouce, opts)
end

--- Navigate to resouce in docfilter buffer.
--- @param opts table|nil:
--- @return table: Promise
function M.navigate(opts)
  return require("docfilter.command").navigate(opts)
end

return M
