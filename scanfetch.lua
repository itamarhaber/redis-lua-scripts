--[[
Scans the keyspace for pattern, and returns the values.

SCAN-like usage, i.e. call repeatedly until cursor zeros:
redis-cli --eval scanfetch.lua , <cursor> <pattern>

Known issues:
* String-based types (HLL, bitmaps and bitfields) are not handled
]]--

local cursor = tonumber(ARGV[1])
local pattern = ARGV[2]

local getters = {
  ['string'] = {
    {'GET'},
    {}
  },
  ['list'] = {
    {'LRANGE'},
    {0, -1}
  },
  ['set'] = {
    {'SMEMBERS'},
    {}
  }, 
  ['zset'] = {
    {'ZRANGE'},
    {0, -1, 'WITHSCORES'}
  },
  ['hash'] = {
    {'HGETALL'},
    {}
  },
  ['stream'] = {
    {'XRANGE'},
    {'-', '+'}
  }
}

local scan = redis.call('SCAN', cursor, 'MATCH', pattern)
for i, key in ipairs(scan[2]) do
  local t = redis.call('TYPE', key)['ok']
  local val = redis.call(unpack(getters[t][1]), key, unpack(getters[t][2]))
  scan[2][i] = { t, key, val }
end

return scan