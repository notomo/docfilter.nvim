local Promise = require("docfilter.lib.promise")

local M = {}

local JobFactory = {}
JobFactory.__index = JobFactory
M.JobFactory = JobFactory

function JobFactory.new()
  local tbl = {}
  return setmetatable(tbl, JobFactory)
end

function JobFactory.create(_, cmd, opts)
  local ok, id_or_err = pcall(vim.fn.jobstart, cmd, opts)
  if not ok then
    return nil, id_or_err
  end
  return id_or_err
end

local Output = {}
Output.__index = Output
M.Output = Output

function Output.new()
  local tbl = { _lines = { "" } }
  return setmetatable(tbl, Output)
end

function Output.collector(self)
  return function(_, data)
    self._lines[#self._lines] = self._lines[#self._lines] .. data[1]
    vim.list_extend(self._lines, vim.list_slice(data, 2))
  end
end

function Output.lines(self)
  if self._lines[#self._lines] ~= "" then
    return self._lines
  end
  return vim.list_slice(self._lines, 1, #self._lines - 1)
end

function Output.str(self)
  return table.concat(self:lines(), "")
end

local JobStarter = {}
JobStarter.__index = JobStarter
M.JobStarter = JobStarter

function JobStarter.start(cmd, opts)
  opts = opts or {}
  opts.handle_stdout = opts.handle_stdout or function(stdout)
    return stdout:lines()
  end
  local stdout = Output.new()
  local stderr = Output.new()
  return Promise.new(function(resolve, reject)
    local _, err = JobFactory.new():create(cmd, {
      on_exit = function(_, code)
        if code ~= 0 then
          local err = { table.concat(cmd, " "), unpack(stderr:lines()) }
          return reject(err)
        end
        return resolve(opts.handle_stdout(stdout))
      end,
      on_stdout = stdout:collector(),
      on_stderr = stderr:collector(),
      stderr_buffered = true,
      stdout_buffered = true,
      cwd = opts.cwd,
    })
    if err then
      return reject(err)
    end
  end)
end

return M
