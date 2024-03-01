--> Default settings before they are overriden by other mods.

herobrine_settings.register_setting("stalking_timer", {
    type = "number",
    description = "Interval between when Herobrine stalks a player.",
    value = 120,
})

herobrine_settings.register_setting("spawnable_on", {
    type = "table",
    description = "Node that Stalking Herobrine can spawn on",
    value = {"group:soil", "group:stone", "group:sand", "group:leaves", "group:grass"}
})

herobrine_settings.register_setting("despawn_timer", {
    type = "number",
    description = "How long it takes in seconds for Stalking Herobrine to despawn.",
    value = 20
})

herobrine_settings.register_setting("despawn_radius", {
    type = "number",
    description = "How close a player has to be to Stalking Herobrine for him to despawn.",
    value = 5
})

herobrine_settings.register_setting("object_radius", {
    type = "number",
    description = "How far Herobrine can detect a player to attack",
    value = 20
})

herobrine_settings.register_setting("stalking_days", {
    type = "number",
    description = "How much in-game days it takes until Herobrine starts stalking players.",
    value = 3
})

herobrine_settings.register_setting("random_door_opening", {
    type = "number",
    description = "The chance of a door being randomly open in your world.",
    value = 20,
    max = 100,
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
    description = "The chance of Herobrine crashing your world.",
    value = 10,
    max = 100,
})