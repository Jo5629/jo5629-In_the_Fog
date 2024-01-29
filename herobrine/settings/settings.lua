--> Save the settings on a world-to-world basis.
herobrine.settings = {}

function herobrine.save_settings()
    local file = Settings(minetest.get_worldpath() .. "/herobrine_settings.conf")
    for k, v in pairs(herobrine.settings) do
        if type(v) == "table" then
            file:set(k, minetest.serialize(v))
        else
            file:set(k, v)
        end
    end
    local success = file:write()
    return success
end

function herobrine.get_settings()
    local settings = Settings(minetest.get_worldpath() .. "/herobrine_settings.conf")
    local settings_table = settings:to_table()
    for k, v in pairs(settings_table) do
        if tonumber(v) == nil then
            if minetest.deserialize(v) == nil then
                herobrine.settings[k] = minetest.deserialize(v) --> Value is a table.
                return
            end
            herobrine.settings[k] = v --> Value is a string.
        else
            herobrine.settings[k] = tonumber(v) --> Value is a number.
        end
    end
end

minetest.register_on_shutdown(function()
    herobrine.save_settings()
end)