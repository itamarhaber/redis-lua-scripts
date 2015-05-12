--[[
mhgetall.lua - like HMGETA but for multiple Hashes
usage: redis-cli -eval mhgetall.lua <hash1> <hash2> ... , <field1> <field2> ...

local r = {}
for _, v in pairs(KEYS) do
  r[#r+1] = redis.call('HMGET', v, unpack(ARGV))
end

return r
