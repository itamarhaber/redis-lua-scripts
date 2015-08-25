--[[

]]--

local t = redis.call("SMEMBERS", KEYS[1])
local n = redis.call("SCARD", KEYS[1])
local r = math.random(1, n+1)
redis.call("SMOVE", KEYS[1], KEYS[2], t[r])
return t[r]
