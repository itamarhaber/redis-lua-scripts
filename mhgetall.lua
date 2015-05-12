--[[
mhgetall.lua - like HGETALL but for multiple Hashes
usage: redis-cli -eval mhgetall.lua <hash1> <hash2> ...

local r = {}
for _, v in pairs(KEYS) do
  r[#r+1] = redis.call('HGETALL', v)
end

return r
