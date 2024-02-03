local modpath = minetest.get_modpath(minetest.get_current_modname())

herobrine_settings = {
    settings = {},
    settings_list = {}
}

dofile(modpath .. "/settings.lua")
dofile(modpath .. "/default_settings.lua")
herobrine_settings.get_settings()