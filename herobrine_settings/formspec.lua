local gui = flow.widgets

local my_gui = flow.make_gui(function(player, ctx)
    table.sort(herobrine_settings.settings_list, function (a, b)
        return string.upper(a) < string.upper(b)
    end)

    local vbox = {name = "vbox1", h = 15, w = 12, spacing = 0.5}
    for _, v in pairs(herobrine_settings.settings_list) do
        local def = herobrine_settings.settings_defs[v]
        local default = def.value
        if def.type == "table" then
            default = minetest.serialize(default)
        elseif def.type ~= "string" then
            default = tostring(default)
        end

        table.insert(vbox, gui.Field{name = v, label = string.format("%s - %s", minetest.colorize("#BFFF00", v), def.description), default = default, h = 1.3})
    end

   return gui.VBox{
        gui.Label{label = "In the Fog Settings Page:", align_h = "centre"},
        gui.ScrollableVBox(vbox),
        gui.Button{
            label = "Save Settings",
            h = 1.3,
        }
    }
end)

herobrine.register_subcommand("settings", {
    description = "Shows the settings page for the In the Fog mod.",
    privs = {interact = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then return end

        my_gui:show(player)
    end
})