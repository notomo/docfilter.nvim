local OpenOption = require("docfilter.core.option").OpenOption
local Document = require("docfilter.core.document").Document
local Window = require("docfilter.view.window").Window

local ReturnPromise = require("docfilter.lib.error_handler").ErrorHandler.for_return_promise()

function ReturnPromise.open(resource, raw_opts)
  vim.validate({ resource = { resource, "string" }, opts = { raw_opts, "table", true } })

  local opts = OpenOption.new(raw_opts)

  local window = Window.open(resource, opts.open, opts.filetype)
  return Document.open(resource, opts):next(function(lines)
    window:render(lines)
  end)
end

return ReturnPromise:methods()
