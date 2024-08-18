if not herobrine_settings.get_setting("torch_enabled") then
    return
end

minetest.log("action", "[In the Fog] Random torch breaking has been enabled.")

local timer = 0
minetest.register_globalstep(function(dtime)
    local interval = herobrine_settings.get_setting("torch_interval")
    local chance = herobrine_settings.get_setting_val_from_day_count("torch_chance", herobrine.get_day_count())
    timer = timer + dtime
    if timer >= interval then
        for _, player in pairs(minetest.get_connected_players()) do
            local ppos = player:get_pos()
            local pos1, pos2 = vector.add(ppos, 10), vector.subtract(ppos, 10)
            for _, pos in pairs(minetest.find_nodes_in_area(pos1, pos2, "group:torch")) do
                if herobrine_settings.random(1, 100, chance) then
                    minetest.dig_node(pos)
                    minetest.log("action", "[In the Fog] Removed the torch at: " .. minetest.pos_to_string(pos, 1))
                end
            end
        end

        timer = 0
    end
end)