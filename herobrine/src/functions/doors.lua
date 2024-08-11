local registered_doors = {}

for door, v in pairs(doors.registered_doors) do
    local def = minetest.registered_nodes[door]
    if not def.protected and v then
        table.insert(registered_doors, door)
    end
end

minetest.register_abm({
    label = "[In the Fog] Randomly opening doors.",
    nodenames = registered_doors,
    interval = herobrine_settings.get_setting("random_door_opening_interval"),
    chance = 1,
    min_y = -32768,
    max_y = 32767,
    catch_up = true,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local chance = herobrine_settings.get_setting_val_from_day_count("random_door_opening", herobrine.get_day_count())
        if not (math.random(1, 100) <= chance) then return end
        local status = doors.door_toggle(pos, node, nil)
        if status then
            minetest.log("action", string.format("[In the Fog] Door at %s was toggled.", minetest.pos_to_string(pos, 1)))
        end
    end,
})