local despawn_radius = herobrine_settings.get_setting("despawn_radius")
local despawn_timer = herobrine_settings.get_setting("despawn_timer")

local def = {
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
    visual = "mesh",
    mesh = "herobrine.b3d",
    textures = {"herobrine.png"},
    type = "npc", --> Somehow an npc-type mob will not despawn but a monster-type will???.
    passive = false,
    attack_type = "dogfight",
    hp_min = 300,
    hp_max = 300,
	damage = 100,
    walk_velocity = 0,
    run_velocity = 0,
	pushable = true,
	view_range = 150,
	fear_height = 0,
	fall_damage = 0,
	knock_back = false,
    immune_to = {"all"},
	glow = 8,

	on_spawn = function(self)
		self.despawn_timer = 0

		local pos = {}
		if self.facing_pname == nil then
			local players = minetest.get_connected_players()
	    	pos = players[math.random(1, #players)]:get_pos()
		else
			local player = minetest.get_player_by_name(self.facing_pname)
			pos = player:get_pos()
		end
		self:yaw_to_pos(pos, 0)
	end,
	do_punch = function (self)
		minetest.log("action", "[In the Fog] Herobrine despawned because he was punched.")
		mobs:remove(self)
		return false
	end,
    do_custom = function(self, dtime)
		self.owner = nil
		local object = self.object
		local obj_pos = object:get_pos()

	    self.despawn_timer = self.despawn_timer + dtime

		local pos = {}
		if self.facing_pname == nil then
			local players = minetest.get_connected_players()
	    	pos = players[math.random(1, #players)]:get_pos()
		else
			local player = minetest.get_player_by_name(self.facing_pname)
			pos = player:get_pos()
		end

		if self.despawn_timer >= despawn_timer then
			mobs:remove(self)
			minetest.log("action", "[In the Fog] Herobrine despawned due to the despawn timer.")
			return false
		end

		local objects = minetest.get_objects_inside_radius(obj_pos, despawn_radius)
		for _, obj in pairs(objects) do
			if obj:is_player() then
				mobs:remove(self)
				herobrine.jumpscare_player(obj, nil, true)
				minetest.log("action", string.format("[In the Fog] Herobrine despawned due to a player being within %d blocks of it.", despawn_radius))
				return false
			end
		end

		self:yaw_to_pos(pos, 0)
	    self:stop_attack()
    end,
}

--> Update the setting values because they do not work?
minetest.register_globalstep(function(dtime)
	despawn_radius = herobrine_settings.get_setting("despawn_radius")
	despawn_timer = herobrine_settings.get_setting("despawn_timer")
end)

mobs:register_mob("herobrine:herobrine_stalker", def)
mobs:register_egg("herobrine:herobrine_stalker", "Spawn Stalking Herobrine", "herobrine_spawn_egg.png", 0, false)