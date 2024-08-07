herobrine_commands = {}
herobrine_commands.commands_list = {}
herobrine_commands.default_privs = {server = true, interact = true, shout = true, herobrine_admin = true}

local cmd = chatcmdbuilder.register("herobrine", {
    description = "Command used for the In the Fog mod. Do /herobrine help to get started. Do /herobrine help true for the formspec version.",
    privs = {
        interact = true
    }
})

function herobrine_commands.register_subcommand(name, def, hidden)
    if def.description == nil then
        def.description = "Undefined."
    end
    herobrine_commands[name] = def

    if def.hidden == nil then
        def.hidden = hidden or false
    end

    if not def.hidden then --> Not be shown during /herobrine help
        table.insert(herobrine_commands.commands_list, name)
    end
    cmd:sub(name, def)
end

local gui = flow.widgets
herobrine_commands.formspec = flow.make_gui(function(player, ctx)
    local vbox = {name = "vbox1", h = 10, w = 15, spacing = 0.3}
    table.sort(herobrine_commands.commands_list, function(a, b)
        return string.upper(a) < string.upper(b)
    end)
    for _, command_name in pairs(herobrine_commands.commands_list) do
        local text = string.format("%s - %s", minetest.colorize("#16FF16", command_name), herobrine_commands[command_name].description)
        table.insert(vbox, gui.Label{label = minetest.wrap_text(text, 130)})
    end
    local formspec = gui.Vbox{
        gui.Label{label = "In the Fog Commands:", align_h = "centre", style = {font = "bold", font_size = "*1.5"}},
        gui.ScrollableVBox(vbox),
    }
    return formspec
end)

--> Miscellaneous commands to stop a looping.
local function regular_help_func(pname)
    table.sort(herobrine_commands.commands_list, function(a, b)
        return string.upper(a) < string.upper(b)
    end)
    minetest.chat_send_player(pname, minetest.colorize("#16FF16", "Commands for the In the Fog mod:"))
    for _, v in pairs(herobrine_commands.commands_list) do
        minetest.chat_send_player(pname, string.format("%s - %s", minetest.colorize("#16FF16", v), herobrine_commands[v].description))
    end
end

herobrine_commands.register_subcommand("help", {
    description = "Gets the help commands for the In the Fog mod.",
    privs = {interact = true, shout = true},
    func = function(name)
        regular_help_func(name)
    end,
})

herobrine_commands.register_subcommand("help :formspec", {
    description = "Gets the help commands for the In the Fog mod. Execute /herobrine help true to view the formspec version.",
    privs = {interact = true, shout = true},
    func = function(name, formspec)
        if formspec == "true" then
            herobrine_commands.formspec:show(minetest.get_player_by_name(name))
        else
            regular_help_func(name)
        end
    end
})