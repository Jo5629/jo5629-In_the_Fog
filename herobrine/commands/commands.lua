herobrine.commands = {}
herobrine.commands_list = {}

local cmd = chatcmdbuilder.register("herobrine", {
    description = "Command used for the In the Fog mod. Do /herobrine help to get started.",
    privs = {
        interact = true
    }
})

function herobrine.register_subcommand(name, def)
    if def.description == nil then
        def.description = "Not defined."
    end
    herobrine.commands[name] = def
    if not def.hidden then --> Not be shown during /herobrine help
        table.insert(herobrine.commands_list, name)
    end
    cmd:sub(name, def)
end

herobrine.register_subcommand("help", {
    description = "Gets the help commands for the In the Fog mod.",
    func = function(name)
        table.sort(herobrine.commands_list, function(a, b)
            return string.upper(a) < string.upper(b)
        end)

        minetest.chat_send_player(name, minetest.colorize("#BFFF00", "Commands for the In the Fog mod:"))
        for _, v in pairs(herobrine.commands_list) do
            minetest.chat_send_player(name, string.format("%s - %s", minetest.colorize("#BFFF00", v), herobrine.commands[v].description))
        end
    end,
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

local function stalk_player(pname, waypoint)
     local player = minetest.get_player_by_name(pname)
    if player then
        local pos = herobrine.find_position_near(player:get_pos())
        herobrine.stalk_player(pname, pos)

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
    hidden = true,
    description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name)
        return stalk_player(name)
    end,
})

herobrine.register_subcommand("stalk_player :waypoint", {
    description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, waypoint)
        return stalk_player(name, waypoint)
    end
})

herobrine.register_subcommand("stalk_player :target :waypoint", {
    description = "Stalks a player. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    privs = {server = true},
    func = function(name, target, waypoint)
        local player = minetest.get_player_by_name(target)
        if player then
            return stalk_player(target, waypoint)
        else
            return false, "Unable to find " .. target .. "."
        end
    end,
})

herobrine.register_subcommand("save_settings", {
    description = "Saves the current settings to a config file.",
    privs = {server = true},
    func = function(name)
        local status = herobrine_settings.save_settings()
        if status then
            minetest.chat_send_player(name, "Able to save to config file.")
        else
            minetest.chat_send_player(name, "Was not able to save to config file,")
        end
    end,
})