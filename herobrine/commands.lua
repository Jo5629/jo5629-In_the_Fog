local cmd = chatcmdbuilder.register("herobrine", {
    description = "Command used for the In the Fog mod.",
    privs = {
        interact = true
    }
})

local function hud_waypoint_def(pos)
    local def = {
    hud_elem_type = "waypoint",
    name = "Position of Herobrine:",
    text = "m",
    number = 0x85FF00,
    world_pos = pos
    }
    return def
end

cmd:sub("stalk_player :waypoint", function(name, waypoint)
    local player = minetest.get_player_by_name(name)
    if player then
        local pos = herobrine.find_position_near(player:get_pos())
        herobrine.stalk_player(name, pos)

        if waypoint == "true" then
            local id = player:hud_add(hud_waypoint_def(pos))
            minetest.after(5, function()
                player:hud_remove(id)
            end)
        end

        return true, "Herobrine is spawned at: " .. minetest.pos_to_string(pos, 1)
    else
        return false, "Command is unable to execute."
    end
end)

cmd:sub("stalk_player :target :waypoint", function(name, target, waypoint)
    local player = minetest.get_player_by_name(target)
    if player then
        local pos = herobrine.find_position_near(player:get_pos())
        herobrine.stalk_player(target, pos)

        if waypoint == "true" then
            local id = player:hud_add(hud_waypoint_def(pos))
            minetest.after(5, function()
                player:hud_remove(id)
            end)
        end

        return true, "Herobrine is spawned at: " .. minetest.pos_to_string(pos, 1)
    else
        return false, "Unable to find " .. target .. "."
    end
end)