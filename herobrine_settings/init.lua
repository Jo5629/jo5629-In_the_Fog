local modpath = minetest.get_modpath(minetest.get_current_modname())

herobrine_settings = {
    settings = {},
    settings_list = {},
    settings_defs = {},
}

dofile(modpath .. "/settings.lua")
dofile(modpath .. "/default_settings.lua")
herobrine_settings.get_settings()

minetest.register_on_mods_loaded(function() --> Need to do something about this in the future.
    dofile(modpath .. "/formspec.lua")
end)