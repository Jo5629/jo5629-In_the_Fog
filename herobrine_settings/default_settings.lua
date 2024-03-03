--> Default settings before they are overriden by other mods.

herobrine_settings.register_setting("spawnable_on", {
    type = "table",
    description = "Node that Stalking Herobrine can spawn on",
    value = {"group:soil", "group:stone", "group:sand", "group:grass"},
})

herobrine_settings.register_setting("despawn_timer", {
    type = "number",
    description = "How long it takes in seconds for Stalking Herobrine to despawn (in seconds).",
    value = 20,
})

herobrine_settings.register_setting("despawn_radius", {
    type = "number",
    description = "How close a player has to be to Stalking Herobrine for him to despawn.",
    value = 5,
})

herobrine_settings.register_setting("stalking_days", {
    type = "number",
    description = "How much in-game days it takes until Herobrine starts stalking players.",
    value = 3,
})

herobrine_settings.register_setting("stalking_timer", {
    type = "number",
    description = "Interval between when Herobrine stalks a player (in seconds).",
    value = 120,
})

herobrine_settings.register_setting("stalking_chance", {
    type = "number",
    description = "The chance for Herobrine to stalk a player. Calculated by value/100",
    value = 50,
    max = 100,
})

herobrine_settings.register_setting("random_door_opening", {
    type = "number",
    description = "The chance of a door being randomly open in your world.",
    value = 20,
    max = 100,
})

herobrine_settings.register_setting("random_door_opening_interval", {
    type = "number",
    description = "The interval between the ABM of randomly opening doors (in seconds).",
    value = 600,
})

herobrine_settings.register_setting("game_crash", {
    type = "boolean",
    description = "Enable/disable Herobrine being able to crash your world.",
    value = false,
})

herobrine_settings.register_setting("game_crash_interval", {
    type = "number",
    description = "How long it takes before the game can randomly crash (in seconds).",
    value = 600,
})

herobrine_settings.register_setting("game_crash_chance", {
    type = "number",
    description = "The chance of Herobrine crashing your world. Calculated by: value/100",
    value = 10,
    max = 100,
})