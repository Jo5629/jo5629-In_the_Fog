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
	glow = 4,

	on_spawn = function(self)
		self.despawn_timer = 0
		self.staring_timer = 0

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
		minetest.sound_fade(self.herobrine_ambience, 0.1, 0)
		herobrine.despawnHerobrine(self)
		return false
	end,
    do_custom = function(self, dtime)
		self.owner = nil
		local object = self.object
		local obj_pos = object:get_pos()

	    self.despawn_timer = self.despawn_timer + dtime
		if self.despawn_timer >= despawn_timer then
			herobrine.despawnHerobrine(self)
			minetest.sound_fade(self.herobrine_ambience, 0.1, 0)
			minetest.log("action", "[In the Fog] Herobrine despawned due to the despawn timer.")

			if math.random(1, 100) <= herobrine_settings.get_setting("convert_stalker") then
				minetest.after(0.25, function()
					herobrine.spawnHerobrine("herobrine:herobrine", obj_pos)
				end)
			end
			return false
		end

		local objects = minetest.get_objects_inside_radius(obj_pos, despawn_radius)
		for _, obj in pairs(objects) do
			if obj:is_player() then
				herobrine.despawnHerobrine(self)
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
				herobrine.despawnHerobrine(self)
				return false
			end

			pos.y = pos.y + 1
			if not herobrine.line_of_sight(pos, obj_pos) then
				return
			end
			self.staring_timer = self.staring_timer + dtime
			local dir = vector.direction(pos, obj_pos)
			local pdir = player:get_look_dir()
			local diff = vector.length(vector.subtract(dir, pdir))
			if diff <= 0.325 and vector.distance(pos, obj_pos) <= 40 and self.despawn_timer >= 6 and self.staring_timer >= 3 then
				if math.random(1, 10000) <= 1 then
					self.object:set_pos(player:get_pos())
				end
				if math.random(1, 10000) <= 1 then
					herobrine.despawnHerobrine(self)

					local id = player:hud_add({
						hud_elem_type = "image",
						alignment = {x = 0, y = 0},
						position = {x = 0.5, y = 0.5},
						scale = {x = 80, y = 80},
						text = "[fill:80x80:#000000",
						z_index = 1000,
					})
					minetest.after(3, function()
						player:hud_remove(id)
					end)
					return false
				end
			end
		end
    end,
}

local mob_name = "herobrine:herobrine_stalker"
mobs:register_mob(mob_name, def)
mobs:register_egg(mob_name, "Spawn Stalking Herobrine", "herobrine_spawn_egg.png", 0, false)