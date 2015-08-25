-- heappump.lua
-- KEYS: none
-- ARGV: #1 - size
--       #2 - number of allocations

local t = redis.call('TIME')[1]
local v = string.rep('x', ARGV[1])

for i = 1, tonumber(ARGV[2]) do
  rawset(_G, t .. i, v .. i)
end

return "Created " .. ARGV[2] .. " allocations"
