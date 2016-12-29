-- ZDIFF key [key ...]
-- Returns the elements in the first key that are also present in all other keys

local key = table.remove(KEYS,1)
local elems = redis.call('ZRANGE', key, 0, -1)
local reply = {}

if #KEYS > 0 and #elems > 0 then
  for i, e in ipairs(elems) do
    local exists = true
    for j, k in ipairs(KEYS) do
      local score = redis.call('ZSCORE', k, e)
      if not score then
        exists = false
        break
      end
    end
    if exists then
      reply[#reply+1] = e
    end
  end
end

return reply
