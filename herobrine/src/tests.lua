herobrine.register_on_day_change(function(daycount)
    minetest.log("action", string.format("[In the Fog] NEW DAYCOUNT: %d.", daycount))
end)

herobrine.register_on_spawn(function(luaentity)
    minetest.log("action", string.format("[In the Fog] %s spawned at %s.", luaentity.name, minetest.pos_to_string(luaentity.object:get_pos(), 1)))
    return true
end)

herobrine.register_on_despawn(function(luaentity)
    minetest.log("action", "Herobrine has been despawned at " .. minetest.pos_to_string(luaentity.object:get_pos(), 1))
end)