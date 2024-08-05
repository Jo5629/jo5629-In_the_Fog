herobrine.register_on_day_change(function(daycount)
    minetest.log("warning", string.format("[In the Fog] DAYCOUNT: %d.", daycount))
end)

herobrine.register_on_spawn(function(name, pos)
    minetest.log("warning", string.format("[In the Fog] %s spawned at %s.", name, minetest.pos_to_string(pos, 2)))
    return true
end)