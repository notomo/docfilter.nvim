local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)

function helper.before_each()
  helper.test_data_path = "spec/test_data/" .. math.random(1, 2 ^ 30) .. "/"
  helper.test_data_dir = helper.root .. "/" .. helper.test_data_path
  helper.new_directory("")
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
  vim.fn.delete(helper.root .. "/spec/test_data", "rf")
  vim.cmd([[lua collectgarbage("collect")]])
end

function helper.new_file(path, ...)
  local f = io.open(helper.test_data_dir .. path, "w")
  for _, line in ipairs({ ... }) do
    f:write(line .. "\n")
  end
  f:close()
end

function helper.new_directory(path)
  vim.fn.mkdir(helper.test_data_dir .. path, "p")
end

function helper.delete(path)
  vim.fn.delete(helper.test_data_dir .. path, "rf")
end

function helper.on_finished()
  local finished = false
  return setmetatable({
    wait = function()
      local ok = vim.wait(1000, function()
        return finished
      end, 10, false)
      if not ok then
        error("wait timeout")
      end
    end,
  }, {
    __call = function()
      finished = true
    end,
  })
end

function helper.wait(promise)
  local on_finished = helper.on_finished()
  promise:finally(function()
    on_finished()
  end)
  on_finished:wait()
end

function helper.print_buffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  print(table.concat(lines, "\n"))
end

local asserts = require("vusted.assert").asserts

asserts.create("exists_pattern"):register(function(self)
  return function(_, args)
    local pattern = args[1]
    pattern = pattern:gsub("\n", "\\n")
    local result = vim.fn.search(pattern, "n")
    self:set_positive(("`%s` not found"):format(pattern))
    self:set_negative(("`%s` found"):format(pattern))
    return result ~= 0
  end
end)
return helper
