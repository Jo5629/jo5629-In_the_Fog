function herobrine.find_position_near(pos)
    local range = math.random(40, 60)
    local pos1 = {x = pos.x - range, y = pos.y, z = pos.z - range}
    local pos2 = {x = pos.x + range, y = pos.y + range, z = pos.z + range}
    local nodes = minetest.find_nodes_in_area_under_air(pos1, pos2, herobrine_settings.settings.spawnable_on)
    table.shuffle(nodes, 1, #nodes)
    local found = false
    local newpos = pos
    for _, node_pos in pairs(nodes) do
        if vector.distance(pos, node_pos) > 30 then
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
    local objref = minetest.add_entity(pos, "herobrine:herobrine_stalker")
    local obj = objref:get_luaentity()
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
        herobrine.stalk_player(name, pos)
        timer = 0
    end
end)