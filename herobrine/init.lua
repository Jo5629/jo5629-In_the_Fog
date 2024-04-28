herobrine = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.register_privilege("herobrine_admin", {
    description = "Allows the player to use advanced commands with the In the Fog mod.",
    give_to_singleplayer = false,
})

--> Commands.
dofile(modpath .. "/commands/commands.lua")

--> Functions.
dofile(modpath .. "/functions/stalking.lua")
dofile(modpath .. "/functions/footsteps.lua")
dofile(modpath .. "/functions/lightning.lua")
dofile(modpath .. "/functions/shrine.lua")
dofile(modpath .. "/functions/doors.lua")
dofile(modpath .. "/functions/jumpscare.lua")
--dofile(modpath .. "/functions/trees.lua") Disabled till further notice. Works but needs more technical fixing.

--> Mobs.
dofile(modpath .. "/mobs/stalker.lua")
dofile(modpath .. "/mobs/herobrine.lua")