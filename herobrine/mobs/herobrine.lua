local def = {
	type = "npc", -->  --> Somehow an npc-type mob will not despawn but a monster-type will???.
    passive = false,
    attack_type = "dogfight",
	pathfinding = 2,
	hp_min = 300,
    hp_max = 300,
	armor = 100,
	damage = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
    visual = "mesh",
    mesh = "herobrine.b3d",
    textures = {"herobrine.png"},
	jump = true,
	makes_footstep_sound = true,
	sounds = {},
    walk_velocity = 1,
    run_velocity = 10,
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
	glow = 8,

	do_custom = function(self, dtime)
		local object = self.object
		self.owner = nil
		local objs = minetest.get_objects_inside_radius(object:get_pos(), herobrine_settings.settings.object_radius)
		table.shuffle(objs, 1, #objs)
		for _, obj in pairs(objs) do
			if obj:is_player() then
				self:do_attack(obj)
				break
			end
		end
	end,
}

mobs:register_mob("herobrine:herobrine", def)
mobs:register_egg("herobrine:herobrine", "Spawn Herobrine", "herobrine_spawn_egg.png", 0, false)