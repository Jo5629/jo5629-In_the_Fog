local despawn_radius = herobrine_settings.get_setting("despawn_radius")
local despawn_timer = herobrine_settings.get_setting("despawn_timer")

local def = {
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
    visual = "mesh",
    mesh = "herobrine.b3d",
    textures = {"herobrine.png"},
    type = "monster", --> Somehow an npc-type mob will not despawn but a monster-type will???.
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
		self.herobrine_ambience = herobrine_ambience.play_ambience(herobrine_ambience.get_random_sound(), math.random(15, 20))
	end,
	do_punch = function (self, hitter)
		minetest.log("action", "[In the Fog] Herobrine despawned because he was punched.")
		if math.random(1, 100) <= herobrine_settings.get_setting("jumpscare_chance") then herobrine.jumpscare_player(hitter, nil, true) end
		mobs:remove(self)
		minetest.sound_fade(self.herobrine_ambience, 0.1, 0)
		return false
	end,
    do_custom = function(self, dtime)
		self.owner = nil
		local object = self.object
		local obj_pos = object:get_pos()

	    self.despawn_timer = self.despawn_timer + dtime
		if self.despawn_timer >= despawn_timer then
			mobs:remove(self)
			if math.random(1, 100) <= herobrine_settings.get_setting("convert_stalker") then
				mobs:add_mob(obj_pos, {
					name = "herobrine:herobrine",
					ignore_count = true,
				})
			end
			minetest.sound_fade(self.herobrine_ambience, 0.1, 0)
			minetest.log("action", "[In the Fog] Herobrine despawned due to the despawn timer.")
			return false
		end

		local objects = minetest.get_objects_inside_radius(obj_pos, despawn_radius)
		for _, obj in pairs(objects) do
			if obj:is_player() then
				mobs:remove(self)
				minetest.sound_fade(self.herobrine_ambience, 0.1, 0)
				if math.random(1, 100) <= herobrine_settings.get_setting("jumpscare_chance") then herobrine.jumpscare_player(obj, nil, true) end
				minetest.log("action", string.format("[In the Fog] Herobrine despawned due to a player being within %d blocks of it.", despawn_radius))
				return false
			end
		end

		local pos = {}
		if self.facing_pname == nil then
			local players = minetest.get_connected_players()
	    	pos = players[math.random(1, #players)]:get_pos()
		else
			local player = minetest.get_player_by_name(self.facing_pname)
			pos = player:get_pos()
			self:yaw_to_pos(pos, 0)
			self:stop_attack()
			if vector.distance(obj_pos, pos) > 120 then
				minetest.log("action", "[In the Fog] Herobrine despawned because he was too far from the player.")
				mobs:remove(self)
				return false
			end
			--[[ STILL VERY WIP. WILL IMPLEMENT IN THE FUTURE.
			local dir = player:get_look_dir()
			local temp_obj_pos = {x = obj_pos.x, y = obj_pos.y + 1, z = obj_pos.z}
			local rayend = vector.subtract(temp_obj_pos, 5)
			local ray = minetest.raycast(player:get_pos(), rayend, true, false)
			for pointed_thing in ray do
				if pointed_thing.type ~= "object" then return end
				if pointed_thing.ref ~= player and pointed_thing.ref ~= nil and pointed_thing.ref:get_luaentity().name == self.name then
					if math.random(1, 100) <= (herobrine_settings.get_setting("jumpscare_chance") * 100000)then
						herobrine.jumpscare_player(player, nil, true)
						mobs:remove(self)
						minetest.log("action", string.format("[In the Fog] Herobrine despawned through a player looking at him."))
						return false
					end
				end
			end
			]]
		end
    end,
}

mobs:register_mob("herobrine:herobrine_stalker", def)
mobs:register_egg("herobrine:herobrine_stalker", "Spawn Stalking Herobrine", "herobrine_spawn_egg.png", 0, false)