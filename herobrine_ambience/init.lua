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
    local sound_name = sounds[herobrine_settings.random(1, #sounds)]
    return sound_name, true
end

local ambience_volume = herobrine_settings.get_setting("ambience_volume") / 100

local ids = {}
function herobrine_ambience.play_sound(spec, duration, parameters)
    if type(spec) ~= "table" then
        spec = {name = spec, gain = 1.0}
    end

    if type(parameters) ~= "table" then
        parameters = {}
    end
    if not parameters.gain then
        parameters.gain = ambience_volume
    end

    local sound = minetest.sound_play(spec, parameters, false)
    ids[sound] = true

    local job = minetest.after(duration or 10, function()
        herobrine_ambience.fade_sound(sound, 0.1, 0)
    end)
    return sound, job
end

function herobrine_ambience.fade_sound(handle, step, gain)
    if not ids[handle] then
        return false
    end
    minetest.sound_fade(handle, step, gain)
    ids[handle] = nil
    return true
end

for i = 1, 4 do
    herobrine_ambience.register_sound("herobrine_ambience" .. tostring(i))
end

local timer = 0
minetest.register_globalstep(function(dtime)
    local chance = herobrine_settings.get_setting_val_from_day_count("ambience_chance", herobrine.get_day_count())
    local interval = herobrine_settings.get_setting("ambience_interval")

    timer = timer + dtime
    if timer >= interval then
        if herobrine_settings.random(1, 100, chance) then
            local sound = herobrine_ambience.get_random_sound()
            herobrine_ambience.play_sound(sound, herobrine_settings.random(20, 25))
        end
        timer = 0
    end
end)