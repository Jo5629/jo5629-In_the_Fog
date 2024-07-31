--> Works with the "lightning" mod by sofar.
function herobrine.lightning_strike(pos)
    if minetest.get_modpath("lightning") then
        lightning.strike(pos)
    end
end