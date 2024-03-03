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
    privs = {interact = true, shout = true},
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

herobrine.register_subcommand("save_settings", {
    description = "Saves the current settings to a config file.",
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    func = function(name)
        local status = herobrine_settings.save_settings()
        if status then
            minetest.chat_send_player(name, "Able to save to config file.")
        else
            minetest.chat_send_player(name, "Was not able to save to config file,")
        end
    end,
})

herobrine.register_subcommand("load_settings", {
    description = "Load the settings from herobrine_settings.conf",
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    func = function(name)
        local success = herobrine_settings.load_settings()
        if success then
            minetest.chat_send_player(name, "Able to load from config file.")
        else
            minetest.chat_send_player(name, "Was not able to load from config file,")
        end
    end
})