local structure_modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/structures"

--> Tunnel.
minetest.register_decoration({
    deco_type = "schematic",
    place_on = {"group:stone"},
    sidelen = 80,
    fill_ratio = 0.00008,
    flags = "place_center_x,place_center_z,force_placement,all_floors",
    y_max = -30000,
    y_min = -20,
    schematic = structure_modpath .. "/tunnel.mts",
    rotation = "random",
})