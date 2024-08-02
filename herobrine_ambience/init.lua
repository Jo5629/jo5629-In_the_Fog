herobrine_ambience = {}

local sounds = {}
function herobrine_ambience.register_sound(name)
    table.insert(sounds, name)
    return true
end

function herobrine_ambience.unregister_sound(name)
    for i, v in pairs(sounds) do
        if v == name then
            table.remove(herobrine_ambience.registered_sounds, i)
            return true
        end
    end
    return false
end

function herobrine_ambience.get_ambience_list()
    return sounds
end

function herobrine_ambience.get_random_sound()
    local sound_name = sounds[math.random(1, #sounds)]
    return sound_name, true
end

local ambience_volume = herobrine_settings.get_setting("ambience_volume") / 100
function herobrine_ambience.play_ambience(sound_name, duration)
    local sound = minetest.sound_play({name = sound_name, gain = ambience_volume}, nil, false)
    local job = minetest.after(duration, function()
        if not sound then return end
        minetest.sound_fade(sound, 0.1, 0)
    end)
    return sound, job
end

herobrine_ambience.register_sound("herobrine_ambience1")
herobrine_ambience.register_sound("herobrine_ambience2")

local timer = 0
minetest.register_globalstep(function(dtime)
    local chance = herobrine_settings.get_setting_val_from_day_count("ambience_chance", herobrine.get_day_count())
    local interval = herobrine_settings.get_setting("ambience_interval")

    timer = timer + dtime
    if timer >= interval then
        if math.random(1, 100) <= chance then
            local sound = herobrine_ambience.get_random_sound()
            herobrine_ambience.play_ambience(sound, math.random(15, 20))
        end
        timer = 0
    end
end)