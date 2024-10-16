function herobrine.line_of_sight(pos1, pos2)
    local success, pos = true, nil
    local ray = minetest.raycast(pos1, pos2, false)
    for pointed_thing in ray do
        if pointed_thing.type ~= "node" then
            return
        end

        local drawtypes = {
            ["allfaces"] = true, ["allfaces_optional"] = true, ["airlike"] = true,
            ["glasslike"] = true, ["glasslike_framed"] = true, ["glasslike_framed_optional"] = true,
            ["plantlike"] = true, ["plantlike_rooted"] = true,
        }
        local def = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name]
        if not drawtypes[def.drawtype] then
            success, pos = false, pointed_thing.under
            break
        end
    end

    return success, pos
end

function herobrine.find_position_near(pos, radius)
    if not radius or radius > 70 then --> As long as the radius is <= 79 we will be okay. Lower the bar a little more too be safe.
        radius = herobrine_settings.random(40, 60)
    end
    local min = herobrine_settings.get_setting("despawn_radius") + 10
    local outside = minetest.get_node_light(pos, 0.5) == 15
    if not outside then min = herobrine_settings.get_setting("despawn_radius") + 5 end
    local pos1 = vector.add(pos, radius)
    local pos2 = vector.subtract(pos, radius)
    local nodes = minetest.find_nodes_in_area_under_air(pos1, pos2, herobrine_settings.get_setting("spawnable_on"))
    table.shuffle(nodes)
    local found = false
    local newpos = pos
    for _, node_pos in pairs(nodes) do
        local temp_pos = {x = node_pos.x, y = node_pos.y + 2, z = node_pos.z}
        if vector.distance(pos, node_pos) > min and herobrine.line_of_sight(pos, temp_pos) and minetest.get_node(temp_pos).name == "air"  then
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
    local success, obj = herobrine.spawnHerobrine("herobrine:herobrine_stalker", pos)
    if not success then
        return false
    end

    obj:yaw_to_pos(minetest.get_player_by_name(pname):get_pos(), 0)
    obj.facing_pname = pname
    minetest.sound_play({name = "herobrine_stalking"}, {to_player = pname}, true)

    minetest.log("action", "[In the Fog] Herobrine is spawned at: " .. minetest.pos_to_string(pos, 1) .. " stalking " .. pname .. ".")
    return true
end

local timer = 0
local chance = 0
minetest.register_globalstep(function(dtime)
    chance = herobrine_settings.get_setting_val_from_day_count("stalking_chance", herobrine.get_day_count())

    local temp_chance = chance

    timer = timer + dtime
    local time = minetest.get_timeofday() * 24
    if (time >= 20 or time <= 4) and chance ~= 0 then --> Try some weighted chance.
        temp_chance = chance + 25
    end
    if timer >= herobrine_settings.get_setting("stalking_timer") then
        if not herobrine_settings.random(1, 100, temp_chance) then
            return
        end

        local players = minetest.get_connected_players()
        local player = players[herobrine_settings.random(1, #players)]
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

local function stalk_player(pname, target, waypoint)
    local playerobj = minetest.get_player_by_name(pname)
    local targetobj = minetest.get_player_by_name(target)
    if targetobj then
        local ppos = targetobj:get_pos()
        ppos.y = ppos.y + 1
        local pos, success = herobrine.find_position_near(ppos)
        if success then
            if not herobrine.stalk_player(target, pos) then
                return false, "A Herobrine has already been spawned."
            end
            
        else
            return false, string.format("Could not find an eligible node to stalk player %s.", target)
        end

        if waypoint == "true" then
            local id = playerobj:hud_add(hud_waypoint_def(pos))
            minetest.after(7, function()
                playerobj:hud_remove(id)
            end)
        end

        return true, "Herobrine is spawned at: " .. minetest.pos_to_string(pos, 1)
    else
        return false, "Command is unable to execute."
    end
end

herobrine_commands.register_subcommand("stalk_player", {
    privs = herobrine_commands.default_privs,
    hidden = true,
    description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name)
        return stalk_player(name, name)
    end,
})

herobrine_commands.register_subcommand("stalk_player :waypoint", {
    privs = herobrine_commands.default_privs,
    description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, waypoint)
        return stalk_player(name, name, waypoint)
    end
})

herobrine_commands.register_subcommand("stalk_player :target :waypoint", {
    privs = herobrine_commands.default_privs,
    description = "Stalks a player. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, target, waypoint)
        local player = minetest.get_player_by_name(target)
        if player then
            return stalk_player(name, target, waypoint)
        else
            return false, "Unable to find " .. target .. "."
        end
    end,
})