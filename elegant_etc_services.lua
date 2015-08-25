--[[

As appeared at http://stackoverflow.com/questions/29833041/whats-the-most-elegant-way-to-add-redis-to-etc-services/29921466#29921466

]]--

local s = redis.call("GET", KEYS[1])
local b, p, name, port, proto

p = 1
repeat
    b, p, name, port, proto = string.find(s, "([%a%w\-]*)%s*(%d+)/(%w+)", p)
    if (p and tonumber(port) > tonumber(ARGV[2])) then
        s = string.sub(s, 1, b-1) .. ARGV[1] .. "\t\t" .. ARGV[2] 
        .. "/" .. ARGV[3] .. "\t\t\t# " .. ARGV[4] .. "\n" 
        .. string.sub(s, b, string.len(s))
        return s
    end 
until not(p)
