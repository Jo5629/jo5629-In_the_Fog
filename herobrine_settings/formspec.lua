local gui = flow.widgets

herobrine_settings.setting_formspec = flow.make_gui(function(player, ctx)
    local has = minetest.check_player_privs(player, {herobrine_admin = true})
    table.sort(herobrine_settings.get_settings_list(), function (a, b)
        return string.upper(a) < string.upper(b)
    end)

    local vbox = {name = "vbox1", h = 15, w = 15, spacing = 0.5}
    for _, name in pairs(herobrine_settings.get_settings_list()) do
        local def = herobrine_settings.get_setting_def(name)
        local default = herobrine_settings.get_setting(name) or def.value
        local type = def.type
        if type == "table" then
            default = minetest.serialize(default)
        elseif type ~= "string" then
            default = tostring(default)
        end

        local label = string.format("%s - %s", minetest.colorize("#BFFF00", name), def.description)
        if type == "boolean" then
            table.insert(vbox, gui.Checkbox{name = name, label = label,})
        else
            table.insert(vbox, gui.Field{name = name, label = label, default = default, h = 1.3})
        end
    end

    if has then
        table.insert(vbox, gui.Button{
            label = "Save Settings",
            h = 1.3,
            on_event = function(player, ctx)
                local pname = player:get_player_name()
                for _, name in pairs(herobrine_settings.get_settings_list()) do
                    local def = herobrine_settings.get_setting_def(name)
                    local value = herobrine_settings.convert_value(ctx.form[name], def.type) or def.value
                    local success = herobrine_settings.set_setting(name, value)
                    if not success then
                        minetest.chat_send_player(pname, minetest.colorize("#FFFF00", string.format("Was not able to override setting %s, defaulting to old value.", name)))
                    end
                    if def.type == "table" then
                        ctx.form[name] = minetest.serialize(value)
                    else
                        ctx.form[name] = value
                    end
                end
                local success = herobrine_settings.save_settings()
                if success then
                    minetest.chat_send_player(pname, "Successfully saved to config file.")
                    minetest.chat_send_player(pname, minetest.colorize("#FF0000", "Some changes may require a restart to be fully activated."))
                else
                    minetest.chat_send_player(pname, "Was not able to save to config file.")
                end

                return true
            end
        })
    end

    local formspec = gui.VBox{
        gui.Label{label = "In the Fog Settings Page:", align_h = "centre"},
        gui.ScrollableVBox(vbox),
    }
   return formspec
end)