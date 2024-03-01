function herobrine.jumpscare_player(player, duration, sound)
    duration = duration or 2.5
    if not player then return false end

    local id = player:hud_add({
        hud_elem_type = "image",
        alignment = {x = 0, y = 0},
        position = {x = 0.5, y = 0.5},
        scale = {x = 80, y = 80},
        text = "herobrine_jumpscare.png",
    })

    minetest.after(duration, function()
        player:hud_remove(id)
    end)

    if sound then
        minetest.sound_play({name = "herobrine_jumpscare"}, {object = player, max_hear_distance = 10}, true)
    end
end

herobrine.register_subcommand("jumpscare :target", {
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    description = "Jumpscare a player.",
    func = function(name, target)
        local player = minetest.get_player_by_name(target)
        herobrine.jumpscare_player(player, nil, true)
    end,
})