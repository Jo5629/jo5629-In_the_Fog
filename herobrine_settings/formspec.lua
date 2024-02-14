local gui = flow.widgets

local my_gui = flow.make_gui(function(player, ctx)
    table.sort(herobrine_settings.settings_list, function (a, b)
        return string.upper(a) < string.upper(b)
    end)

    local vbox = {name = "vbox1", h = 15, w = 12}
    for _, v in pairs(herobrine_settings.settings_list) do
        table.insert(vbox, gui.Field{type = "field", label = v})
    end

   return gui.VBox{
        gui.Label{label = "In the Fog Settings Page:"},
        gui.ScrollableVBox(vbox)
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