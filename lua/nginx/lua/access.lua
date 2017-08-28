local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000) 
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
  ngx.say("failed to connect: ", err)
  return
end

val = red:get(ngx.var.urlkey)
if val == ngx.null then
  ngx.say("Could not find a url for that id, maybe it expired?")
  return
end

ngx.redirect(val)
