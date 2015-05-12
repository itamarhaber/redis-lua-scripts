--[[
infospect.lua - an introspective stats collector for Redis, in Redis

Each time you run this script, INFO lines are added to Lists with
matching respective names. Cron execution of script every 60s or so.
]]--
 
-- list of stat names/prefixes to collect
local collected_stats = 
  'cmdstat_,'..
  'connected_clients,'..
  'db0,'..
  'evicted_keys,'..
  'expired_keys,'..
  'instantaneous_ops_per_sec,'..
  'keyspace_hits,'..
  'keyspace_misses,'..
  'rejected_connections,'..
  'uptime_in_seconds,'..
  'used_memory,'
 
local samples_max = 100             -- the number of samples to keep
local samples_prefix = 'infospect'  -- the prefix for sample keys
 
local function store(key, value)
  redis.call('lpush', key, value)
  redis.call('ltrim', key, 0, samples_max - 1)
end
 
local function collect(l)
  if l:len() > 0 then           -- ignore empty lines
    if l:sub(1,1) == '#' then   -- section line
      stats_section = l:match('# (.*)')
    else
      local name, value = l:match('([%a%d_]+):(.*)')
      local pre, post = name:match('([%a%d_]+)_(.*)')
      if (collected_stats:find(name) ~= nil or 
        (pre ~= nil and collected_stats:find(pre..'_') ~= nil)) then
        local key = samples_prefix..':'..stats_section..':'..name
        if value:find(',') == nil then
          store(key, value)
        else
          for n,v in value:gmatch('([%a%d_]*)=([%a%d_]*),?') do
            store(key..':'..n, v)
          end
        end
      end
    end
  end
  return ''
end
 
local stats_section = ''
local raw_info = redis.call('INFO', 'all')
collect(raw_info:gsub('(.-)\r?\n', collect))
 
return 'OK'
