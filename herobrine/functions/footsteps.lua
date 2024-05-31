herobrine.register_subcommand("footsteps", {
    privs = herobrine.commands.default_privs,
    description = "Plays footsteps to all of the players in a world.",
    func = function(name)
        for _, player in pairs(minetest.get_connected_players()) do
            minetest.sound_play({name = "footsteps-on-gravel"}, {to_player = player:get_player_name()}, true)
        end
    end
})

local chance = herobrine_settings.get_setting("footsteps_chance")
local max_time = herobrine_settings.get_setting("footsteps_interval")
local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= max_time then
        for _, player in pairs(minetest.get_connected_players()) do
            if math.random(1, 100) <= chance then
                minetest.sound_play({name = "footsteps-on-gravel", {to_player = player:get_player_name()}})
            end
        end
        timer = 0
    end
end)