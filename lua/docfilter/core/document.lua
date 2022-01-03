local JobStarter = require("docfilter.lib.job").JobStarter
local Promise = require("docfilter.lib.promise")
local MultiError = require("docfilter.lib.multi_error").MultiError
local modulelib = require("docfilter.lib.module")

local M = {}

local Document = {}
Document.__index = Document
M.Document = Document

function Document.open(resouce, opts)
  local cmd = {
    opts.pandoc,
    "--from=" .. opts.from,
    "--to=" .. opts.to,
    "--columns=" .. opts.get_columns(),
  }

  local errs = MultiError.new()

  for _, module_path in ipairs(opts.filters) do
    local path, err = modulelib.to_path("lua/docfilter/filter/" .. module_path)
    if err then
      errs:add(err)
    else
      vim.list_extend(cmd, { "--lua-filter", path })
    end
  end

  local err = errs:err()
  if err then
    return Promise.reject(err)
  end
  table.insert(cmd, resouce)

  return JobStarter.start(cmd)
end

return M
