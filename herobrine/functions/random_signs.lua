local signs_lib_enabled = minetest.get_modpath("signs_lib")
if signs_lib_enabled then
    minetest.log("info", "[In the Fog] signs_lib is enabled, using that for random_signs.lua")    
end

herobrine.signs = {}

local words_table = {
    ["en"] = {
        "I am watching you...",
        "On your six!",
    },
}
words_table["default"] = words_table["en"]

function herobrine.signs.register_text(lang_table, text_table)
    for _, lang in pairs(lang_table) do
        for _, text in pairs(text_table) do
            table.insert(words_table[lang], text)
        end
    end
end

function herobrine.signs.get_full_lang_table()
    return words_table
end

function herobrine.signs.get_lang_table(lang)
    if not lang then lang = "default" end
    return words_table[lang]
end

function herobrine.signs.generate_random_text(lang)
    if not words_table[lang] or not lang then
        lang = "default"
    end
    return words_table[lang][math.random(1, #words_table[lang])], true
end

--> Took and updated the function from herobrine.find_position_near()
function herobrine.signs.find_position_near(pos)
    local range = math.random(40, 60) --> As long as the range is <= 160 we will be okay.
    local pos1 = {x = pos.x - range, y = pos.y - range, z = pos.z - range}
    local pos2 = {x = pos.x + range, y = pos.y + range, z = pos.z + range}
    local nodes = minetest.find_nodes_in_area_under_air(pos1, pos2, herobrine_settings.get_setting("signs_spawnable_on"))
    table.shuffle(nodes)
    local found = false
    local newpos = pos
    for _, node_pos in pairs(nodes) do
        local temp_pos = {x = node_pos.x, y = node_pos.y + 2, z = node_pos.z}
        if minetest.get_node(temp_pos).name == "air"  then
            newpos = node_pos
            found = true
            break
        end
    end
    if found then
        return newpos, found
    else
        return pos, found
    end
end

local sign_node = "default:sign_wall_wood" --> Use this so that signs_lib is not usually needed.
function herobrine.signs.place_sign(pos, text)
    minetest.set_node(pos, {name = sign_node})
    if signs_lib_enabled then
        signs_lib.update_sign(pos, {text = text})
        return true
    else
        minetest.get_meta(pos):set_string("infotext", text)
        return true
    end
end