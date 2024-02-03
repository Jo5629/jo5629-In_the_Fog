--> Save the settings on a world-to-world basis.

function herobrine_settings.register_setting(name, def)
    herobrine_settings.settings[name] = def.initial_value
end

function herobrine_settings.save_settings()
    local file = Settings(minetest.get_worldpath() .. "/herobrine_settings.conf")
    for k, v in pairs(herobrine_settings.settings) do
        local setting_type = type(v)
        if setting_type == "table" then
            file:set(k, minetest.serialize(v))
        elseif setting_type == "string" or setting_type == "number" or setting_type == "boolean" then
            file:set(k, v)
        end
    end
    local success = file:write()
    return success
end

function herobrine_settings.get_settings()
    local settings = Settings(minetest.get_worldpath() .. "/herobrine_settings.conf")
    local settings_table = settings:to_table()
    for k, v in pairs(settings_table) do
        --> Write in the logs what settings were modified in the config file. Good for debugging.
        local old_val = herobrine_settings.settings[k]
        if type(old_val) == "table" then
            local new_table = minetest.serialize(old_val)
            old_val = new_table
        end

        if tostring(old_val) ~= v and herobrine_settings.settings[k] ~= nil then
            local log = string.format("[In the Fog] Setting %s has been modified from %s to %s.", k, tostring(old_val), v)
            minetest.log("action", log)
        end

        --> Actually write to the in-game settings table.
        if tonumber(v) == nil then
            if minetest.deserialize(v) == nil then
                herobrine_settings.settings[k] = minetest.deserialize(v) --> Value is a table.
                return
            end
            if v == "false" then
                herobrine_settings.settings[k] = false --> Value is a false boolean.
            elseif v == "true" then
                herobrine_settings.settings[k] = true --> Value is a true boolean.
            else
                herobrine_settings.settings[k] = v --> Value is a string.
            end
        else
            herobrine_settings.settings[k] = tonumber(v) --> Value is a number.
        end
    end
end

minetest.register_on_shutdown(function()
    herobrine_settings.save_settings()
end)