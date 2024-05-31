local jumpscare_volume = herobrine_settings.get_setting("jumpscare_volume") / 100
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
        minetest.sound_play({name = "herobrine_jumpscare", gain = jumpscare_volume}, {object = player, max_hear_distance = 10}, true)
    end
    minetest.log("action", string.format("[In the Fog] Jumpscared %s.", player:get_player_name()))
end

herobrine.register_subcommand("jumpscare", {
    hidden = true,
    privs = herobrine.commands.default_privs,
    description = "Jumpscare a player.",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            herobrine.jumpscare_player(player, nil, true)
        end
    end,
})

herobrine.register_subcommand("jumpscare :target", {
    privs = herobrine.commands.default_privs,
    description = "Jumpscare a player.",
    func = function(name, target)
        local player = minetest.get_player_by_name(target)
        if player then
            herobrine.jumpscare_player(player, nil, true)
        else
            return string.format("Was not able to find %s.", target)
        end
    end,
})