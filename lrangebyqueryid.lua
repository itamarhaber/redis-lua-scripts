-- returns a range of list elements that confirm to a given
-- query_id. Elements are stored as: 'campaign_id|telephone|query_id'
-- KEYS[1] - a list
-- ARGV[1] - a query_id

local l = redis.call('LRANGE', KEYS[1], 0, -1)
local r = {}

for _, v in pairs(l) do
  local id = v:match( '.*|.*|(.*)' )
  if id == ARGV[1] then
    r[#r+1] = v
  end
end

return r
