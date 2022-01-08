local messagelib = require("docfilter.lib.message")
local Promise = require("docfilter.lib.promise")

local M = {}

local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler
M.ErrorHandler = ErrorHandler

function ErrorHandler.new(f)
  local tbl = { _return = f }
  return setmetatable(tbl, ErrorHandler)
end

function ErrorHandler.for_return_promise()
  return ErrorHandler.new(function(f)
    local ok, result = xpcall(f, debug.traceback)
    if not ok then
      messagelib.error(result)
      return Promise.resolve()
    elseif result then
      return Promise.resolve(result):catch(function(err)
        return messagelib.warn(err)
      end)
    end
    return Promise.resolve(result)
  end)
end

function ErrorHandler.methods(self)
  local methods = {}
  for key in pairs(self) do
    methods[key] = function(...)
      return self(key, ...)
    end
  end
  return methods
end

function ErrorHandler.__call(self, key, ...)
  local args = vim.F.pack_len(...)
  local f = function()
    return self[key](vim.F.unpack_len(args))
  end
  return self._return(f)
end

return M
