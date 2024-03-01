herobrine.register_subcommand("footsteps", {
    privs = {server = true, interact = true, shout = true, herobrine_admin = true},
    description = "Plays footsteps to all of the players in a world.",
    func = function(name)
        for _, player in pairs(minetest.get_connected_players()) do
            minetest.sound_play({name = "footsteps-on-gravel"}, {to_player = player:get_player_name()}, true)
        end
    end
})