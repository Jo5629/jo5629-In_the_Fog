local sounds = {}
function herobrine.register_sound(name)
    table.insert(sounds, name)
    return true
end

function herobrine.unregister_sound(name)
    for i, v in pairs(sounds) do
        if v == name then
            table.remove(herobrine.registered_sounds, i)
            return true
        end
    end
    return false
end

function herobrine.get_ambience_list()
    return sounds
end

function herobrine.get_random_sound()
    local sound_name = sounds[math.random(1, #sounds)]
    return sound_name, true
end

function herobrine.play_ambience(sound_name, duration)
    local sound = minetest.sound_play({name = sound_name, gain = 0.9}, nil, false)
    local job = minetest.after(duration, function()
        if not sound then return end
        minetest.sound_fade(sound, 0.1, 0)
    end)
    return sound, job
end

herobrine.register_sound("herobrine_ambience1")
herobrine.register_sound("herobrine_ambience2")

local chance = herobrine_settings.get_setting("ambience_chance")
local interval = herobrine_settings.get_setting("ambience_interval")

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= interval then
        if math.random(1, 100) <= chance then
            local sound = herobrine.get_random_sound()
            herobrine.play_ambience(sound, math.random(15, 20))
        end
        timer = 0
    end
end)

herobrine.register_subcommand("ambience :word", {
    description = "Plays ambience. Use *random to play a random sound.",
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    func = function(name, word)
        local duration = math.random(15, 20)
        if word == "*random" then
            local sound = herobrine.get_random_sound()
            herobrine.play_ambience(sound, duration)
            return true, string.format("Playing ambience sound: %s", sound)
        end
        local found = false
        local sound_list = herobrine.get_ambience_list()
        for i = 1, #sound_list do
            if sound_list[i] == word then
                found = true
                break
            end
        end
        if found then
            herobrine.play_ambience(word, duration)
            return true, string.format("Playing ambience sound: %s", word)
        else
            return false, string.format("Was not able to find sound %s.", word)
        end
    end
})