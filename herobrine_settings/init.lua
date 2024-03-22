local modpath = minetest.get_modpath(minetest.get_current_modname())

herobrine_settings = {
    settings = {},
    settings_list = {},
    settings_defs = {},
}

dofile(modpath .. "/api.lua")
dofile(modpath .. "/default_settings.lua")
dofile(modpath .. "/formspec.lua")

herobrine_settings.load_settings()