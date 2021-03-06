local template = require "resty.template"
local redis = require "resty.redis"
local red = redis:new()
red:set_timeout(1000) 
ngx.req.read_body()


-- Read URL from form
local url, err = ngx.req.get_post_args()['newurl']
if not url then
  ngx.say("failed to get post args: ", err)
  return
end

-- Connect to Redis
local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
  ngx.say("failed to connect: ", err)
  return
end

-- Assign a free ID
newkey = math.random(100000)
attempts = 0
while red:get(newkey) ~= ngx.null and attempts < 100 do
  newkey = newkey + 1
  attempts = attempts + 1
end

if attempts == 100 then
  ngx.say("Could not generate unique key")
  return
end

red:set(newkey, url)

local view = template.new "post.html"
view.full_link_url = ngx.var.serverpath .. "/url/" .. newkey
view:render()
