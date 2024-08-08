local enabled = herobrine_settings.get_setting("schematics_enabled")
if not enabled then return end

minetest.log("action", "[In the Fog] Schematic generation has been enabled.")

local structure_modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/schematics"

--> Tunnel.
minetest.register_decoration({
    deco_type = "schematic",
    place_on = {"group:stone"},
    sidelen = 9,
    fill_ratio = 0.00003,
    y_max = -30000,
    y_min = -50,
    schematic = structure_modpath .. "/tunnel.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random"
})

--> Sandstone Pyramid.
minetest.register_decoration({
    deco_type = "schematic",
    place_on = {"group:sand", "group:water"},
    sidelen = 9,
    fill_ratio = 0.00003,
    y_max = 30000,
    y_min = 2,
    schematic = structure_modpath .. "/sandstone_pyramid.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
    biomes = {
        "taiga_ocean",
        "snowy_grassland_ocean",
        "grassland_ocean",
        "coniferous_forest_ocean",
        "deciduous_forest_ocean",
        "sandstone_desert_ocean",
        "cold_desert_ocean",
        "desert",
        "sandstone_desert",
        "cold_desert",
    },
})