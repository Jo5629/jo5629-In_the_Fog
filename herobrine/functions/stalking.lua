function herobrine.find_position_near(pos)
    local range = math.random(40, 60) --> As long as the range is <= 160 we will be okay.
    local min = herobrine_settings.settings.despawn_radius + 10
    local outside = minetest.get_node_light(pos, 0.5) == 15
    if not outside then min = herobrine_settings.settings.despawn_radius + 5 end
    local pos1 = {x = pos.x - range, y = pos.y - range, z = pos.z - range}
    local pos2 = {x = pos.x + range, y = pos.y + range, z = pos.z + range}
    local nodes = minetest.find_nodes_in_area_under_air(pos1, pos2, herobrine_settings.settings.spawnable_on)
    table.shuffle(nodes, 1, #nodes)
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
        return newpos
    else
        return pos
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

local max_time = herobrine_settings.settings.stalking_timer
local timer = 0
minetest.register_globalstep(function(dtime)
    if minetest.get_day_count() < herobrine_settings.settings.stalking_days then
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