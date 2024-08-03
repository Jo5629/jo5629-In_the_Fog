local def = {
	type = "monster", -->  --> Somehow an npc-type mob will not despawn but a monster-type will???.
    passive = false,
    attack_type = "dogfight",
	pathfinding = true,
	hp_min = 65536,
    hp_max = 65536,
	armor = 100,
	damage = 0,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
    selectionbox = {0, 0, 0, 0, 0, 0},
    visual = "mesh",
    mesh = "herobrine.b3d",
    textures = {"herobrine_footsteps.png"},
	jump = true,
	makes_footstep_sound = true,
	sounds = {},
    walk_velocity = 1.3,
    run_velocity = 3,
	pushable = true,
	view_range = 150,
	fear_height = 0,
	fall_damage = 0,
	knock_back = false,
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 189, --200
		punch_end = 198 --219
	},
	fire_damage = 0,

    on_spawn = function(self)
        self.despawn_timer = 0
    end,
	do_custom = function(self, dtime)
        self.despawn_timer = self.despawn_timer + dtime
        if self.despawn_timer >= 30 then
            mobs:remove(self)
            return false
        end

        local object = self.object
        local objs = minetest.get_objects_inside_radius(object:get_pos(), 3)
        for _, obj in pairs(objs) do
            if obj:is_player() then
                mobs:remove(self)
                return false
            end
        end
	end,
}

mobs:register_mob("herobrine:herobrine_footsteps", def)
mobs:register_egg("herobrine:herobrine_footsteps", "Spawn Footsteps Herobrine", "herobrine_spawn_egg.png", 0, false)

local timer = 0
minetest.register_globalstep(function(dtime)
	local chance = herobrine_settings.get_setting_val_from_day_count("footsteps_chance", herobrine.get_day_count())
	local interval = herobrine_settings.get_setting("footsteps_interval")

	timer = timer + dtime
	if timer >= interval and math.random(1, 100) <= chance then
		local players = minetest.get_connected_players()
		local randplayer = players[math.random(1, #players)]

		local pos, success = herobrine.find_position_near(randplayer:get_pos(), math.random(30, 50))
		if success then
			mobs:add_mob(pos, {
				name = "herobrine:herobrine_footsteps",
				ignore_count = true,
			})

			for _, callback in ipairs(herobrine.registered_on_spawn) do
				callback("herobrine:herobrine_footsteps", pos)
			end
		end
	end
end)