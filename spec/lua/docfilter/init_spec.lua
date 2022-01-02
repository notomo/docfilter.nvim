local helper = require("docfilter.lib.testlib.helper")
local docfilter = helper.require("docfilter")

describe("docfilter.open()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open buffer with converted contents", function()
    local target_file = "index.html"
    helper.new_file(
      target_file,
      [[
<html>
  <body>
    <h1>test header</h1>
  </body>
</html>
]]
    )

    local promise = docfilter.open(helper.test_data_dir .. target_file)
    helper.wait(promise)

    assert.exists_pattern("# test header")
  end)
end)
