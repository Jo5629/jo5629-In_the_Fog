local enabled, interval, chance = herobrine_settings.get_setting("game_crash"), herobrine_settings.get_setting("game_crash_interval"), herobrine_settings.get_setting("game_crash_chance")

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= interval and enabled then
        if math.random(1, 100) <= chance then
            minetest.request_shutdown("ANOMALY FOUND. SHUTTING DOWN WORLD IMMEDIATELY.", false, 0)
        end
    end
end)