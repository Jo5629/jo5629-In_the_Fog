herobrine = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())

--> Commands.
dofile(modpath .. "/commands.lua")

--> Mobs.
dofile(modpath .. "/mobs/stalker.lua")
dofile(modpath .. "/mobs/herobrine.lua")

--> Functions.
dofile(modpath .. "/functions/stalking.lua")