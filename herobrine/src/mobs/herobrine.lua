local def = {
	type = "monster", -->  Somehow an npc-type mob will not despawn but a monster-type will???.
    passive = false,
    attack_type = "dogfight",
	--[[
	shoot_interval = 0.2,
	dogshoot_switch = 2,
	dogshoot_count_max = 2,
	dogshoot_count2_max = 6,
	arrow = "herobrine:fireball",
	shoot_offset = 2,
	]]
	pathfinding = true,
	hp_min = 200,
    hp_max = 200,
	armor = 100,
	damage = 8,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
    visual = "mesh",
    mesh = "herobrine.b3d",
    textures = {"herobrine.png"},
	jump = true,
	fly = true,
	makes_footstep_sound = true,
	sounds = {},
    walk_velocity = 4,
    run_velocity = 6,
	pushable = true,
	view_range = 150,
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
	fear_height = 0,
	fall_damage = 0,

	on_spawn = function(self)
		self.despawn_timer = 0

		self.texture_timer = 0
		self.invisible = false
	end,
	on_die = function(self, pos)
		herobrine.lightning_strike(pos)
		mobs:boom(self, pos, 5, 5, nil)
		return false
	end,
	do_custom = function(self, dtime)
		local object = self.object

		self.despawn_timer = self.despawn_timer + dtime
		if self.despawn_timer > 240 then
			herobrine.lightning_strike(object:get_pos())
			herobrine.despawnHerobrine(self)
			return false
		end

		self.texture_timer = self.texture_timer + dtime
		if self.texture_timer >= 4 then
			local props = object:get_properties()
			if not self.invisible then
				props.textures = {"herobrine_footsteps.png"}
			else
				props.textures = {"herobrine.png"}
			end
			self.invisible = not self.invisible
			object:set_properties(props)
			self.texture_timer = 0
		end
	end,
}

mobs:register_mob("herobrine:herobrine", def)
mobs:register_egg("herobrine:herobrine", "Spawn Herobrine", "herobrine_spawn_egg.png", 0, false)

local randmessages = {
	"I " .. minetest.colorize("#FF0000", "will") .. " return.",
	"Imagine dying to " .. minetest.colorize("#FF0000", "me") .. ".",
	"Nice try ... But you " .. minetest.colorize("#FF0000", "failed") .. ".",
}

local function despawnHerobrine(luaentity, pos)
	herobrine.lightning_strike(pos)
	herobrine.despawnHerobrine(luaentity)
	minetest.chat_send_all(minetest.format_chat_message("Herobrine", randmessages[herobrine_settings.random(1, #randmessages)]))
	herobrine.set_day_count(0)
end

--> Despawn Herobrine after he kills a player.
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	local luaentity = hitter:get_luaentity()
	if player:get_hp() > 0 and player:get_hp() - damage <= 0 and minetest.is_player(player) and luaentity then --> From https://github.com/appgurueu/deathlist/blob/master/main.lua#L242
		if luaentity.name == "herobrine:herobrine" then
			minetest.after(2, function()
				despawnHerobrine(luaentity, hitter:get_pos())
			end)
		end
	end
end)

--[[
local function find_luaentity(entity)
	local found, luaentity = false, nil
	for _, v in pairs(minetest.luaentities) do
		if tostring(v.object) == entity then
			found, luaentity = true, v
			break
		end
	end
	return found, luaentity
end

local count = 0
local function spawn_lightning(pos)
	local time = minetest.get_timeofday() * 24
	if time >= 20 or time <= 4 then
		count = count + 1
		if count > 3 then
			herobrine.lightning_strike(pos)
			count = 0
		end
	end
end

mobs:register_arrow("herobrine:fireball", {
	collisionbox = {-1, -1, -1, 1, 1, 1},
	visual = "sprite",
	visual_size = {x = 2.5, y = 2.5},
	textures = {"fireball.png"},
	velocity = 85,
	tail = 1,
	tail_texture = "smoke.png",
	glow = 12,

	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = math.random(4, 6)}
		}, nil)
		spawn_lightning(player:get_pos())
		mobs:boom(self, player:get_pos(), 2, 3, nil)
	end,
	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = math.random(4, 6)}
		}, nil)
		spawn_lightning(player:get_pos())
		mobs:boom(self, player:get_pos(), 2, 3, nil)
	end,
	hit_node = function(self, pos, node)
		spawn_lightning(pos)
		mobs:boom(self, pos, 2, 3, nil)
		self.object:remove()
	end,
})
]]