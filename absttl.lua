-- Returns a key's absolute TTL

local t = tonumber(redis.call('TTL', KEYS[1]))
if t > 0 then
  t = t + tonumber(redis.call('TIME')[1])
end

return t
