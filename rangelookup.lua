-- rangelookup.lua
-- http://stackoverflow.com/questions/32185898/redis-get-member-where-score-is-between-min-and-max/32186675
-- A non inclusive range search on a Sorted Set with the following data:
--   score = <StartNumber>
--   member = <EndNumber>:<LocationId>
--
-- KEYS[1] - Sorted Set key name
-- ARGV[1] - the number to search
--
-- reply - the relevant id, nil if range doesn't exist
-- 
-- usage example: redis-cli --eval rangelookup.lua ranges , 7

local number = tonumber(ARGV[1])
local data = redis.call('ZREVRANGEBYSCORE', KEYS[1], number, '-inf', 'WITHSCORES', 'LIMIT', 0, 1)
local reply = nil

if data ~= nil and number > tonumber(data[2]) then
  local to, id = data[1]:match( '(.*):(.*)' )
  if tonumber(to) > number then
    reply = id
  end
end

return reply
