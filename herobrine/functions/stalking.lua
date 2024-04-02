function herobrine.find_position_near(pos)
    local range = math.random(40, 60) --> As long as the range is <= 160 we will be okay.
    local min = herobrine_settings.get_setting("despawn_radius") + 10
    local outside = minetest.get_node_light(pos, 0.5) == 15
    if not outside then min = herobrine_settings.get_setting("despawn_radius") + 5 end
    local pos1 = {x = pos.x - range, y = pos.y - range, z = pos.z - range}
    local pos2 = {x = pos.x + range, y = pos.y + range, z = pos.z + range}
    local nodes = minetest.find_nodes_in_area_under_air(pos1, pos2, herobrine_settings.get_setting("spawnable_on"))
    table.shuffle(nodes)
    local found = false
    local newpos = pos
    for _, node_pos in pairs(nodes) do
        local temp_pos = {x = node_pos.x, y = node_pos.y + 2, z = node_pos.z}
        if vector.distance(pos, node_pos) > min and minetest.line_of_sight(pos, temp_pos) and minetest.get_node(temp_pos).name == "air"  then
            newpos = node_pos
            found = true
            break
        end
    end
    if found then
        newpos.y = newpos.y + 2
        return newpos, found
    else
        return pos, found
    end
end

function herobrine.stalk_player(pname, pos)
    local obj = mobs:add_mob(pos, {
        name = "herobrine:herobrine_stalker",
        ignore_count = true
    })
    obj:yaw_to_pos(minetest.get_player_by_name(pname):get_pos(), 0)
    obj.facing_pname = pname
    minetest.sound_play({name = "herobrine_stalking"}, {to_player = pname}, true)
    minetest.log("action", "[In the Fog] Herobrine is spawned at: " .. minetest.pos_to_string(pos, 1) .. " stalking " .. pname .. ".")
end

local max_time = herobrine_settings.get_setting("stalking_timer")
local timer = 0
local chance = herobrine_settings.get_setting("stalking_chance")
minetest.register_globalstep(function(dtime)
    if minetest.get_day_count() < herobrine_settings.get_setting("stalking_days") or not (math.random(1, 100) <= chance) then
        timer = 0
        return
    end

    timer = timer + dtime
    if timer >= max_time then
        local players = minetest.get_connected_players()
        local player = players[math.random(1, #players)]
        local name = player:get_player_name()
        local pos = herobrine.find_position_near(player:get_pos())
        if minetest.pos_to_string(pos, 1) ~= minetest.pos_to_string(player:get_pos(), 1) then
            herobrine.stalk_player(name, pos)
        end
        timer = 0
    end
end)

--> Chatcommands.
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

local function stalk_player(pname, waypoint)
     local player = minetest.get_player_by_name(pname)
    if player then
        local ppos = player:get_pos()
        ppos.y = ppos.y + 1
        local pos, success = herobrine.find_position_near(ppos)
        if success then
            herobrine.stalk_player(pname, pos)
        else
            return false, string.format("Could not find an eligible node to stalk player %s.", pname)
        end

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
end

herobrine.register_subcommand("stalk_player", {
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    hidden = true,
    description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name)
        return stalk_player(name)
    end,
})

herobrine.register_subcommand("stalk_player :waypoint", {
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, waypoint)
        return stalk_player(name, waypoint)
    end
})

herobrine.register_subcommand("stalk_player :target :waypoint", {
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    description = "Stalks a player. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, target, waypoint)
        local player = minetest.get_player_by_name(target)
        if player then
            return stalk_player(target, waypoint)
        else
            return false, "Unable to find " .. target .. "."
        end
    end,
})