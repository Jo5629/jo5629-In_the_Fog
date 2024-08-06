local modpath = minetest.get_modpath(minetest.get_current_modname())

herobrine_settings = {
    settings = {},
    settings_list = {},
    settings_defs = {},
    conf_modpath = minetest.get_worldpath()
}

dofile(modpath .. "/api.lua")
dofile(modpath .. "/formspec.lua")
dofile(modpath .. "/default_settings.lua")

herobrine_settings.load_settings()
minetest.register_on_mods_loaded(function()
    herobrine_settings.load_settings()

    local tbl = herobrine_settings.get_setting("spawnable_on")
    local flags = {}
    for _, v in pairs(tbl) do
        flags[v] = true
    end

    for _, def in pairs(minetest.registered_biomes) do
        for _, name in pairs({def.node_dust, def.node_top, def.node_filler, def.node_stone}) do
            local exists = false
            for gname, _ in pairs(minetest.registered_nodes[name].groups) do
                if flags["group:" .. gname] or flags[name] then
                    exists = true
                end
            end
            if not exists then
                minetest.log("action", "[In the Fog] Registered node: " .. name)
                table.insert(tbl, name)
                flags[name] = true
            end
        end
    end
    herobrine_settings.set_setting("spawnable_on", tbl)
end)

local function settings_loop()
    herobrine_settings.save_settings()
    minetest.after(60, settings_loop)
end

minetest.after(0, settings_loop)

minetest.register_on_shutdown(function()
    herobrine_settings.save_settings()
end)