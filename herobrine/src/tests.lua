herobrine.register_on_day_change(function(daycount)
    minetest.log("action", string.format("[In the Fog] NEW DAYCOUNT: %d.", daycount))
end)

herobrine.register_on_spawn(function(name, pos)
    minetest.log("action", string.format("[In the Fog] %s spawned at %s.", name, minetest.pos_to_string(pos, 1)))
    return true
end)