herobrine = {}

local version = "v2.0.0-dev"
local srcpath = minetest.get_modpath(minetest.get_current_modname()) .. "/src"

minetest.register_privilege("herobrine_admin", {
    description = "Allows the player to use advanced commands with the In the Fog mod.",
    give_to_singleplayer = false,
    give_to_admin = true,
})

--> Callbacks.
dofile(srcpath .. "/callbacks.lua")

--> Do not know where the functions should go for the moment.
function herobrine.spawnHerobrine(name, pos)
    if not herobrine.registered_on_spawn:runCallbacks(true, name, pos) then
        return false
    end
    return true, mobs:add_mob(pos, {
        name = name,
        ignore_count = true,
    })
end

function herobrine.despawnHerobrine(luaentity)
    herobrine.registered_on_despawn:runCallbacks(false, luaentity.name, luaentity.object:get_pos())
    mobs:remove(luaentity)
end

--> Commands.
dofile(srcpath .. "/commands.lua")

--> Functions.
dofile(srcpath .. "/functions/daycount.lua")
dofile(srcpath .. "/functions/stalking.lua")
dofile(srcpath .. "/functions/lightning.lua")
dofile(srcpath .. "/functions/shrine.lua")
dofile(srcpath .. "/functions/doors.lua")
dofile(srcpath .. "/functions/jumpscare.lua")
dofile(srcpath .. "/functions/random_signs.lua")
--dofile(srcpath .. "/functions/crashing.lua") Might remove this feature in the future.
--dofile(srcpath .. "/functions/trees.lua") Disabled till further notice. Works but needs more technical fixing.

--> Mobs.
dofile(srcpath .. "/mobs/stalker.lua")
dofile(srcpath .. "/mobs/herobrine.lua")
dofile(srcpath .. "/mobs/footsteps.lua")

--> Tests.
dofile(srcpath .. "/tests.lua")

minetest.log("action", "[In the Fog] Mod initialized. VERSION: " .. version)