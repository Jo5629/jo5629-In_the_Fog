--> Works with the "lightning" mod by sofar.
local lightning_enabled = minetest.get_modpath("lightning")
if lightning_enabled then
    lightning.auto = false
    minetest.log("action", "[In the Fog] Lightning has been enabled.")
end

function herobrine.lightning_strike(pos)
    if lightning_enabled then
        lightning.strike(pos)
    end
end