minetest.register_decoration({
    deco_type = "schematic",
    place_on = "group:stone",
    sidelen = 8,
    fill_ratio = 0.02,
    y_min = -30000,
    y_max = -10,
    flags = "force_placement",
    schematic = "tunnel.mts",
    place_offset_y = -10,
})