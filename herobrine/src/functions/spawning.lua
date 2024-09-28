function herobrine.spawnHerobrine(name, pos)
    local luaentity = mobs:add_mob(pos, {
        name = name,
        ignore_count = true,
    })
    if not herobrine.registered_on_spawn:RunCallbacks(true, luaentity) then
        luaentity.object:remove()
        return false
    end
    return true, luaentity
end

function herobrine.despawnHerobrine(luaentity)
    herobrine.registered_on_despawn:RunCallbacks(false, luaentity)
    mobs:remove(luaentity)
end

local jobs = {}

herobrine._spawned = false --> Only change this if you know what you are doing.
herobrine.register_on_spawn(function(luaentity)
    if herobrine._spawned then
        return false
    end
    herobrine._spawned = true

    local sound, job = herobrine_ambience.play_sound({
        name = herobrine_ambience.get_random_sound(),
        max_hear_distance = 80,
        pos = luaentity.object:get_pos(),
        fade = 0.1,
    }, herobrine_settings.random(20, 25), {
        gain = 2.0,
    })

    luaentity.sound_id = sound
    jobs[sound] = job

    return true
end)

herobrine.register_on_despawn(function(luaentity)
    if herobrine._spawned then
        herobrine._spawned = false
    end
    minetest.chat_send_all("DESPAWNED.")
    local id = luaentity.sound_id
    herobrine_ambience.fade_sound(id, 0.1, 0)
    if jobs[id] then
        jobs[id]:cancel()
    end
end)