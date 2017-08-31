local template = require "resty.template"
-- Using template.new
local view = template.new "view.html"
view:render()
