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