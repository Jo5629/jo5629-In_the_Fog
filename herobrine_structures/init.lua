local structure_modpath = minetest.get_modpath(minetest.get_current_modname()) .. "/schematics"

local enabled = herobrine_settings.get_setting("schematics_enabled")
if not enabled then return end

--> Tunnel.
minetest.register_decoration({
    name = "herobrine_structures:tunnel",
    deco_type = "schematic",
    place_on = {"group:stone"},
    sidelen = 80,
    fill_ratio = 0.008,
    flags = "place_center_x,place_center_z,force_placement",
    y_max = -30000,
    y_min = -100,
    schematic = structure_modpath .. "/tunnel.mts",
    rotation = "random",
})

--> Sandstone Pyramid.
minetest.register_decoration({
    name = "herobrine_structures:sandstone_pyramid",
    deco_type = "schematic",
    place_on = {"default:river_water_source", "default:water_source", "group:sand"},
    sidelen = 80,
    fill_ratio = 0.008,
    flags = "place_center_x,place_center_z,force_placement,liquid_surface",
    y_max = -30,
    y_min = 30,
    schematic = structure_modpath .. "/sandstone_pyramid.mts",
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