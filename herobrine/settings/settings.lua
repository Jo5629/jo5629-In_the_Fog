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
        --> Write in the logs what settings were modified in the config file. Good for debugging.
        local old_val = herobrine.settings[k] 
        if type(old_val) == "table" then
            local new_table = minetest.serialize(old_val)
            old_val = new_table
        end

        if tostring(old_val) ~= v and herobrine.settings[k] ~= nil then
            local log = string.format("[In the Fog] Setting %s has been modified from %s to %s.", k, tostring(old_val), v)
            minetest.log("action", log)
        end

        --> Actually write to the in-game settings table.
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