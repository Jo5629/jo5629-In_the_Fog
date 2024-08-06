function herobrine.spawnHerobrine(name, pos)
    if not herobrine.registered_on_spawn:RunCallbacks(true, name, pos) then
        return false
    end
    return true, mobs:add_mob(pos, {
        name = name,
        ignore_count = true,
    })
end

function herobrine.despawnHerobrine(luaentity)
    herobrine.registered_on_despawn:RunCallbacks(false, luaentity.name, luaentity.object:get_pos())
    mobs:remove(luaentity)
end

herobrine._spawned = false
herobrine.register_on_spawn(function(name, pos)
    if herobrine._spawned then
        return false
    end
    herobrine._spawned = true
    return true
end)

herobrine.register_on_despawn(function(name, pos)
    if herobrine._spawned then
        herobrine._spawned = false
    end
end)