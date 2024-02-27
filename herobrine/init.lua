herobrine = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())

--> Commands.
dofile(modpath .. "/commands/commands.lua")
dofile(modpath .. "/commands/formspec.lua")

--> Mobs.
dofile(modpath .. "/mobs/stalker.lua")
dofile(modpath .. "/mobs/herobrine.lua")

--> Functions.
dofile(modpath .. "/functions/stalking.lua")
dofile(modpath .. "/functions/footsteps.lua")
dofile(modpath .. "/functions/lightning.lua")
dofile(modpath .. "/functions/shrine.lua")