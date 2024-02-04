--> Save the settings on a world-to-world basis.

function herobrine_settings.register_setting(name, def)
    local types = {["table"] = true, ["boolean"] = true, ["string"] = true, ["number"] = true}
    if def.type ~= type(def.value) or not types[def.type]  then
        minetest.log("error", string.format("[In the Fog] Was not able to register: %s"))
        return
    end
    if def.description == nil then def.description = "" end

    herobrine_settings.settings[name] = def.value
    herobrine_settings.settings_list[name] = def
    minetest.log("action", string.format("[In the Fog] Registered setting: %s", name))
end

function herobrine_settings.save_settings()
    local file = Settings(minetest.get_worldpath() .. "/herobrine_settings.conf")
    for k, v in pairs(herobrine_settings.settings) do
        local setting_type = herobrine_settings.settings_list[k].type
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
        local type = herobrine_settings.settings_list[k].type
        if type == "number" then
            herobrine_settings.settings[k] = tonumber(v)
        elseif type == "string" then
            herobrine_settings.settings[k] = v
        elseif type == "table" then
            herobrine_settings.settings[k] = minetest.deserialize(v)
        elseif type == "boolean" then
            local booleans = {["false"] = false, ["true"] = true}
            herobrine_settings.settings[k] = booleans[v]
        else
            minetest.log("error", string.format("[In the Fog] Was not able to write %s to herobrine_settings.", k))
        end
    end
end

minetest.register_on_shutdown(function()
    herobrine_settings.save_settings()
end)