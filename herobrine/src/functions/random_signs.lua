local signs_lib_enabled = minetest.get_modpath("signs_lib")
if signs_lib_enabled then
    minetest.log("info", "[In the Fog] signs_lib is enabled, using that for random_signs.lua")
end
minetest.log("action", "[In the Fog] Sign generation has been enabled.")

herobrine.signs = {}

local words_table = {
    ["en"] = {},
}

function herobrine.signs.register_text(lang_table, text_table)
    for _, lang in pairs(lang_table) do
        for _, text in pairs(text_table) do
            table.insert(words_table[lang], text)
        end
    end
end

herobrine.signs.register_text({"en"}, {
        "I am watching you...",
        "On your six!",
})

function herobrine.signs.get_full_lang_table()
    return words_table
end

function herobrine.signs.get_lang_table(lang)
    if not lang then lang = "en" end
    return words_table[lang]
end

function herobrine.signs.generate_random_text(lang)
    if not words_table[lang] or not lang then
        lang = "en"
    end
    return words_table[lang][herobrine_settings.random(1, #words_table[lang])], true
end

--> Took and updated the function from herobrine.find_position_near()
function herobrine.signs.find_position_near(pos, radius)
    if not radius or radius > 70 then --> As long as the radius is <= 79 we will be okay. Lower the bar a little more to be safe.
        radius = herobrine_settings.random(40, 60)
    end
    local pos1 = {x = pos.x - radius, y = pos.y - radius, z = pos.z - radius}
    local pos2 = {x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}
    local nodes = minetest.find_nodes_in_area_under_air(pos1, pos2, herobrine_settings.get_setting("signs_spawnable_on"))
    table.shuffle(nodes)
    local found = false
    local newpos = pos
    for _, node_pos in pairs(nodes) do
        local temp_pos = {x = node_pos.x, y = node_pos.y + 2, z = node_pos.z}
        local node_light = minetest.get_node_light(temp_pos, 0.5)
        if not node_light or node_light < 9 then
            return
        end
        if minetest.get_node(temp_pos).name == "air"  then
            newpos = node_pos
            found = true
            break
        end
    end
    if found then
        newpos.y = newpos.y + 1
        return newpos, found
    else
        return pos, found
    end
end

local sign_node = "default:sign_wall_wood" --> Use this so that signs_lib is not usually needed.
function herobrine.signs.place_sign(pos, text)
    minetest.add_node(pos, {name = sign_node, param2 = 1,})
    minetest.log("action", string.format("[In the Fog] Placed a sign at %s with text: %s.", minetest.pos_to_string(pos, 1), text))
    if signs_lib_enabled then
        signs_lib.update_sign(pos, {text = text})
        return true
    else
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", text)
        meta:set_string("text", text) --> Hope to still be viewed after sign_lib is enabled.
        return true
    end
    return false
end

local function place_random_sign(pname, target, range, waypoint)
    local playerobj = minetest.get_player_by_name(pname)
    local targetobj = minetest.get_player_by_name(target)
    if not targetobj then
        return false, string.format("Could not find player %s.", target)
    end
    if type(range) ~= "number" then
        return false, "Range is not an actual number."
    end
    local pos, found = herobrine.signs.find_position_near(targetobj:get_pos(), range)
    if not found then
        return "Was not able to find an eligible node."
    end
    local success = herobrine.signs.place_sign(pos, herobrine.signs.generate_random_text())
    if waypoint == "true" then
        local id = playerobj:hud_add({
            hud_elem_type = "waypoint",
            name = "Position of Sign",
            text = "m",
            number = 0x85FF00,
            world_pos = pos,
        })
        minetest.after(7, function()
            playerobj:hud_remove(id)
        end)
    end
    if success then
        return true, string.format("Placed a sign at %s.", minetest.pos_to_string(pos, 1))
    end
end

herobrine_commands.register_subcommand("place_random_sign :target :num :waypoint", {
    privs = herobrine_commands.default_privs,
    description = "Places a random sign with text around the player",
    func = function(name, target, num, waypoint)
        return place_random_sign(name, target, tonumber(num), waypoint)
    end
})

--> Make it normal in the world.
local interval = herobrine_settings.get_setting("signs_spawn_interval")
local enabled = herobrine_settings.get_setting("signs_enabled")
local timer = 0
minetest.register_globalstep(function(dtime)
    local chance = herobrine_settings.get_setting_val_from_day_count("signs_spawn_chance", herobrine.get_day_count())
    
    timer = timer + dtime
    if timer >= interval then
        timer = 0
        if not enabled or not herobrine_settings.random(1, 100, chance) then
            return
        end
        local players = {}
        for _, playerobj in pairs(minetest.get_connected_players()) do
            table.insert(players, playerobj:get_player_name())
        end
        local randpname = players[herobrine_settings.random(1, #players)]
        local randpobj = minetest.get_player_by_name(randpname)
        if randpobj then
            local pos, found = herobrine.signs.find_position_near(randpobj:get_pos())
            if found then
                herobrine.signs.place_sign(pos, herobrine.signs.generate_random_text())
            end
        end
    end
end)