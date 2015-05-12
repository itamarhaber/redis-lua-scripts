--[[
Kill idle clients - ideally cron the execution
usage: redis-cli -eval hitman.lua , <idle limit>
]]--

local l = redis.call('client', 'list')
local k = 0
 
for r in l:gmatch('[^\n]+') do
  for c,i in r:gmatch('addr=(.+:%d+).*idle=(%d+).*') do 
    if tonumber(i) > tonumber(ARGV[1]) then
      redis.call('client', 'kill', c)
      k = k + 1
    end
  end
end
 
return(k)
