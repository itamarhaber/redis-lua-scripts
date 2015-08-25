--[[

]]--

if redis.call('ZCARD', KEYS[1]) < ARGV[1] then
   redis.call('ZADD', KEYS[1], ARGV[2], ARGV[3])

