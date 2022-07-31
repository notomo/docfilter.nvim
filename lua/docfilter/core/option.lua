local M = {}

local OpenOption = {}
OpenOption.__index = OpenOption
M.OpenOption = OpenOption

OpenOption.default = {
  pandoc = "pandoc",
  from = "html",
  to = "markdown",
  filters = { "default" },
  filetype = "markdown",
  open = function(bufnr)
    vim.cmd.tabedit()
    vim.cmd.buffer({ count = bufnr })
  end,
  get_columns = function()
    return vim.o.columns - 10
  end,
}

function OpenOption.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}
  return vim.tbl_deep_extend("force", OpenOption.default, raw_opts)
end

return M
