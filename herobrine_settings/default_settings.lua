--> Default settings before they are overriden by other mods.

herobrine_settings.register_setting("spawnable_on", {
    type = "table",
    description = "Node list that Stalking Herobrine can spawn on",
    value = {"group:soil", "group:stone", "group:sand", "group:grass"},
}, true)

herobrine_settings.register_setting("despawn_timer", {
    type = "number",
    description = "How long it takes in seconds for Stalking Herobrine to despawn (in seconds).",
    value = 20,
}, true)

herobrine_settings.register_setting("despawn_radius", {
    type = "number",
    description = "How close a player has to be to Stalking Herobrine for him to despawn.",
    value = 5,
}, true)

herobrine_settings.register_setting("stalking_days", {
    type = "number",
    description = "How much in-game days it takes until Herobrine starts stalking players.",
    value = 1,
}, true)

herobrine_settings.register_setting("stalking_timer", {
    type = "number",
    description = "Interval between when Herobrine stalks a player (in seconds).",
    value = 120,
}, true)

herobrine_settings.register_setting("stalking_chance", {
    type = "table",
    description = "The chance for Herobrine to stalk a player.",
    value = {
        days = {1, 3, 5, 8, 10},
        vals = {0, 10, 30, 30, 40},
    },
}, true)

herobrine_settings.register_setting("random_door_opening", {
    type = "number",
    description = "The chance of a door being randomly open in your world.",
    value = 20,
    max = 100,
}, true)

herobrine_settings.register_setting("random_door_opening_interval", {
    type = "number",
    description = "The interval between the ABM of randomly opening doors (in seconds).",
    value = 600,
}, true)

herobrine_settings.register_setting("game_crash", {
    type = "boolean",
    description = "Enable/disable Herobrine being able to crash your world. ENABLE AT YOUR OWN RISK.",
    value = false,
})

herobrine_settings.register_setting("game_crash_interval", {
    type = "number",
    description = "How long it takes before the game can randomly crash (in seconds).",
    value = 600,
}, true)

herobrine_settings.register_setting("game_crash_chance", {
    type = "number",
    description = "The chance of Herobrine crashing your world. Calculated by: value/100",
    value = 5,
    max = 100,
}, true)

herobrine_settings.register_setting("footsteps_chance", {
    type = "table",
    description = "The chance of Footsteps Herobrine spawning.",
    value = {
        days = {1, 3, 4, 6},
        vals = {35, 50, 35, 0},
    },
}, true)

herobrine_settings.register_setting("footsteps_interval", {
    type = "number",
    description = "Interval between footsteps playing (in seconds)",
    value = 600,
}, true)

herobrine_settings.register_setting("leafless_trees_enabled", {
    type = "boolean",
    description = "Enable/disable leafless trees. ENABLE AT YOUR OWN RISK.",
    value = false,
})

herobrine_settings.register_setting("schematics_enabled", {
    type = "boolean",
    description = "Enable/disable schematics.",
    value = true,
})

herobrine_settings.register_setting("jumpscare_chance", {
    type = "number",
    description = "The chance of getting jumpscared by Stalking Herobrine.",
    value = 50,
    max = 100,
}, true)

herobrine_settings.register_setting("jumpscare_volume", {
    type = "number",
    description = "How loud the jumpscare sound is. Number is divided by 100.",
    value = 80,
})

herobrine_settings.register_setting("shrine_interval", {
    type = "number",
    description = "Interval between lighting shrines (in seconds)",
    value = 2400,
}, true)

herobrine_settings.register_setting("ambience_interval", {
    type = "number",
    description = "Interval between random sounds playing (in seconds).",
    value = 480,
}, true)

herobrine_settings.register_setting("ambience_chance", {
    type = "table",
    description = "The chance of a random sound playing.",
    value = {
        days = {0, 2, 5, 10},
        vals = {0, 10, 15, 20}
    }
}, true)

herobrine_settings.register_setting("ambience_volume", {
    type = "number",
    description = "How loud the ambience sounds will play. Number is divided by 100.",
    value = 10,
})

herobrine_settings.register_setting("convert_stalker", {
    type = "number",
    description = "The chance of Stalking Herobrine will convert to Regular Herobrine.",
    value = 3,
    max = 100,
}, true)

herobrine_settings.register_setting("signs_enabled", {
    type = "boolean",
    description = "Enable/Disable signs randomly generated in your world.",
    value = true,
})

herobrine_settings.register_setting("signs_spawnable_on", {
    type = "table",
    description = "Node that random signs can spawn on",
    value = {"group:soil", "group:stone", "group:sand"},
}, true)

herobrine_settings.register_setting("signs_spawn_interval", {
    type = "number",
    description = "How long until a sign can randomly spawn (in seconds)",
    value = 1200,
}, true)

herobrine_settings.register_setting("signs_spawn_chance", {
    type = "table",
    description = "The chance of a random sign to spawn. (Out of 100)",
    value = {
        days = {5, 6, 8, 12},
        vals = {0, 10, 20, 30},
    },
}, true)