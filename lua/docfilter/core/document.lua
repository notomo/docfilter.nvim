local JobStarter = require("docfilter.lib.job").JobStarter
local Promise = require("docfilter.lib.promise")
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
    "--columns=" .. tostring(vim.o.columns - 10),
  }
  for _, module_path in ipairs(opts.filters) do
    local path, err = modulelib.to_path("lua/docfilter/filter/" .. module_path)
    if err then
      return Promise.reject(err)
    end
    vim.list_extend(cmd, { "--lua-filter", path })
  end
  table.insert(cmd, resouce)

  return JobStarter.start(cmd)
end

return M
