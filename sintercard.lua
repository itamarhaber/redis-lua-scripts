local i = redis.call('SINTER', unpack(KEYS))
return #i
