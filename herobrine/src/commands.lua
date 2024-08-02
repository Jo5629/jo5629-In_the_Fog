herobrine.commands = {}
herobrine.commands_list = {}
herobrine.commands.default_privs = {server = true, interact = true, shout = true, herobrine_admin = true}

local cmd = chatcmdbuilder.register("herobrine", {
    description = "Command used for the In the Fog mod. Do /herobrine help to get started. Do /herobrine help true for the formspec version.",
    privs = {
        interact = true
    }
})

function herobrine.register_subcommand(name, def, hidden)
    if def.description == nil then
        def.description = "Undefined."
    end
    herobrine.commands[name] = def

    if def.hidden == nil then
        def.hidden = hidden or false
    end

    if not def.hidden then --> Not be shown during /herobrine help
        table.insert(herobrine.commands_list, name)
    end
    cmd:sub(name, def)
end

local gui = flow.widgets
herobrine.commands.formspec = flow.make_gui(function(player, ctx)
    local vbox = {name = "vbox1", h = 10, w = 15, spacing = 0.3}
    table.sort(herobrine.commands_list, function(a, b)
        return string.upper(a) < string.upper(b)
    end)
    for _, command_name in pairs(herobrine.commands_list) do
        local text = string.format("%s - %s", minetest.colorize("#16FF16", command_name), herobrine.commands[command_name].description)
        table.insert(vbox, gui.Label{label = minetest.wrap_text(text, 130)})
    end
    local formspec = gui.Vbox{
        gui.Label{label = "In the Fog Commands:", align_h = "centre"},
        gui.ScrollableVBox(vbox),
    }
    return formspec
end)

--> Miscellaneous commands to stop a looping.
local function regular_help_func(pname)
    table.sort(herobrine.commands_list, function(a, b)
        return string.upper(a) < string.upper(b)
    end)
    minetest.chat_send_player(pname, minetest.colorize("#16FF16", "Commands for the In the Fog mod:"))
    for _, v in pairs(herobrine.commands_list) do
        minetest.chat_send_player(pname, string.format("%s - %s", minetest.colorize("#16FF16", v), herobrine.commands[v].description))
    end
end

herobrine.register_subcommand("help", {
    description = "Gets the help commands for the In the Fog mod.",
    privs = {interact = true, shout = true},
    func = function(name)
        regular_help_func(name)
    end,
})

herobrine.register_subcommand("help :formspec", {
    description = "Gets the help commands for the In the Fog mod. Execute /herobrine help true to view the formspec version.",
    privs = {interact = true, shout = true},
    func = function(name, formspec)
        if formspec == "true" then
            herobrine.commands.formspec:show(minetest.get_player_by_name(name))
        else
            regular_help_func(name)
        end
    end
})

herobrine.register_subcommand("save_settings", {
    description = "Saves the current settings to a config file.",
    privs = herobrine.commands.default_privs,
    func = function(name)
        local success = herobrine_settings.save_settings()
        if success then
            minetest.chat_send_player(name, "Able to save to config file.")
        else
            minetest.chat_send_player(name, "Was not able to save to config file,")
        end
    end,
})

herobrine.register_subcommand("load_settings", {
    description = "Load the settings from herobrine_settings.conf",
    privs = herobrine.commands.default_privs,
    func = function(name)
        local success = herobrine_settings.load_settings()
        if success then
            minetest.chat_send_player(name, "Able to load from config file.")
        else
            minetest.chat_send_player(name, "Was not able to load from config file,")
        end
    end
})

herobrine.register_subcommand("settings", {
    description = "Shows the settings page for the In the Fog mod.",
    privs = {interact = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then return end

        herobrine_settings.setting_formspec:show(player)
    end
})

herobrine.register_subcommand("ambience :word", {
    description = "Plays ambience. Use *random to play a random sound.",
    privs = herobrine.commands.default_privs,
    func = function(name, word)
        local duration = math.random(15, 20)
        if word == "*random" then
            local sound = herobrine_ambience.get_random_sound()
            herobrine_ambience.play_ambience(sound, duration)
            return true, string.format("Playing ambience sound: %s", sound)
        end
        local found = false
        local sound_list = herobrine_ambience.get_ambience_list()
        for i = 1, #sound_list do
            if sound_list[i] == word then
                found = true
                break
            end
        end
        if found then
            herobrine_ambience.play_ambience(word, duration)
            return true, string.format("Playing ambience sound: %s", word)
        else
            return false, string.format("Was not able to find sound %s.", word)
        end
    end
})