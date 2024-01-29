herobrine = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())

--> Settings.
dofile(modpath .. "/settings/settings.lua")
dofile(modpath .. "/settings/default_settings.lua")
herobrine.get_settings()

--> Commands.
dofile(modpath .. "/commands.lua")

--> Mobs.
dofile(modpath .. "/mobs/stalker.lua")
dofile(modpath .. "/mobs/herobrine.lua")

--> Functions.
dofile(modpath .. "/functions/stalking.lua")