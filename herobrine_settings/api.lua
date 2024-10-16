local CURRENT_SETTING_VERSION = "2"

--> Save the settings on a world-to-world basis.
local types = {["table"] = true, ["boolean"] = true, ["string"] = true, ["number"] = true}

function herobrine_settings.register_setting(name, def, hidden)
    if def.type ~= type(def.value) or not types[def.type]  then
        minetest.log("error", string.format("[In the Fog] Was not able to register: %s", name))
        return false
    end
    if def.description == nil then def.description = "Not defined." end

    herobrine_settings.settings_defs[name] = def
    herobrine_settings.set_setting(name, def.value)
    if not hidden then
        table.insert(herobrine_settings.settings_list, name)
    end
    minetest.log("action", string.format("[In the Fog] Registered setting: %s", name))
    return true
end

function herobrine_settings.convert_value(val, to_type)
    if type(val) == to_type then
        return val
    end
    if not types[to_type] then return nil end
    if to_type == "number" then
       return tonumber(val)
    elseif to_type == "table" then
        return minetest.deserialize(val)
    elseif to_type == "boolean" then
        local values = {["false"] = false, ["true"] = true}
        return values[val]
    elseif to_type == "string" then
        return tostring(val)
    end
end

function herobrine_settings.nearest_value(tbl, number) --> https://stackoverflow.com/questions/29987249/find-the-nearest-value.
    local smallestSoFar, smallestIndex
    for i, y in ipairs(tbl) do
        if not smallestSoFar or (math.abs(number-y) < smallestSoFar) then
            smallestSoFar = math.abs(number-y)
            smallestIndex = i
        end
    end
    return smallestIndex, tbl[smallestIndex]
end

function herobrine_settings.get_setting(name)
    return herobrine_settings.settings[name]
end

function herobrine_settings.get_setting_def(name)
    return herobrine_settings.settings_defs[name]
end

function herobrine_settings.get_settings_list()
    return herobrine_settings.settings_list
end

function herobrine_settings.set_setting(name, val)
    local def = herobrine_settings.get_setting_def(name)
    local min, max = def.min or 0, def.max or 65536
    if val == nil or def.type ~= type(val) or ( type(val) == "number" and not (val >= min and val <= max)) then
        minetest.log("warning", string.format("[In the Fog] Was not able to overwrite setting: %s.", name))
        return false
    end

    herobrine_settings.settings[name] = val
    minetest.log("action", string.format("[In the Fog] Was able to override setting: %s", name))
    return true
end

function herobrine_settings.save_settings()
    local file = Settings(herobrine_settings.conf_modpath .. "/herobrine_settings.conf")
    for k, v in pairs(herobrine_settings.settings) do
        local setting_type = herobrine_settings.get_setting_def(k).type
        if setting_type == "table" then
            file:set(k, minetest.serialize(v))
        elseif setting_type == "string" or setting_type == "number" or setting_type == "boolean" then
            file:set(k, tostring(v))
        end
    end
    file:set("setting_version", CURRENT_SETTING_VERSION)
    local success = file:write()
    return success
end

function herobrine_settings.load_settings()
    local settings = Settings(herobrine_settings.conf_modpath .. "/herobrine_settings.conf")
    local settings_table = settings:to_table()

    settings_table.setting_version = nil
    if not settings:get("setting_version") then
        return false
    end
    if not (tonumber(settings:get("setting_version")) >= tonumber(CURRENT_SETTING_VERSION)) then
        return false
    end

    for k, v in pairs(settings_table) do
        if k == nil then return end
        --> Write in the logs what settings were modified in the config file. Good for debugging.
        local old_val = herobrine_settings.get_setting(k)
        if type(old_val) == "table" then
            local new_table = minetest.serialize(old_val)
            old_val = new_table
        end

        if tostring(old_val) ~= v and old_val ~= nil then
            local log = string.format("[In the Fog] Setting %s has been modified from %s to %s.", k, tostring(old_val), v)
            minetest.log("action", log)
        end

        --> Actually write to the in-game settings table.
        local def = herobrine_settings.get_setting_def(k)
        local min, max = def.min or 0, def.max or 65536
        if def.type == "number" and tonumber(v) ~= nil and (tonumber(v) >= min and tonumber(v) <= max) then
            herobrine_settings.set_setting(k, herobrine_settings.convert_value(v, "number"))
        else
            herobrine_settings.set_setting(k, herobrine_settings.convert_value(v, def.type))
        end
    end
    return true
end

function herobrine_settings.get_setting_val_from_day_count(name, days)
    local def = herobrine_settings.get_setting_def(name)
    if not def or def.type ~= "table" then
        return 0, false
    end

    local tbl = def.value
    return tbl.vals[herobrine_settings.nearest_value(tbl.days, days)], true
end

local rng = PcgRandom(21862175432869)
function herobrine_settings.random(min, max, num)
    local rand = rng:next(min, max)
    if not rand then
        rand = math.random(min, max) --> Fallback just to be sure.
    end
    if not num then
        return rand
    end
    return rand <= num
end