local def = {
	type = "monster", -->  --> Somehow an npc-type mob will not despawn but a monster-type will???.
    passive = false,
    attack_type = "dogfight",
	pathfinding = true,
	hp_min = 300,
    hp_max = 300,
	armor = 100,
	damage = 15,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
    visual = "mesh",
    mesh = "herobrine.b3d",
    textures = {"herobrine.png"},
	jump = true,
	makes_footstep_sound = true,
	sounds = {},
    walk_velocity = 1.3,
    run_velocity = 7,
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
	glow = 4,
	fire_damage = 0,

	on_spawn = function(self)
		self.despawn_timer = 0
	end,
	on_die = function(self, pos)
		herobrine.lightning_strike(pos)
		return false
	end,
	do_custom = function(self, dtime)
		self.despawn_timer = self.despawn_timer + dtime
		if self.despawn_timer >= herobrine_settings.get_setting("despawn_timer") then
			herobrine.lightning_strike(self.object:get_pos())
			herobrine.despawnHerobrine(self)
			return false
		end
	end,
}

mobs:register_mob("herobrine:herobrine", def)
mobs:register_egg("herobrine:herobrine", "Spawn Herobrine", "herobrine_spawn_egg.png", 0, false)

--> Despawn Herobrine after he kills a player.
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	local luaentity = hitter:get_luaentity()
	if player:get_hp() > 0 and player:get_hp() - damage <= 0 and luaentity.name == "herobrine:herobrine" and minetest.is_player(player) then --> From https://github.com/appgurueu/deathlist/blob/master/main.lua#L242
		minetest.after(2, function()
			herobrine.lightning_strike(hitter:get_pos())
			herobrine.despawnHerobrine(luaentity)
			minetest.chat_send_all(minetest.format_chat_message("Herobrine", "I will return."))
			herobrine.set_day_count(0)
		end)
	end
end)