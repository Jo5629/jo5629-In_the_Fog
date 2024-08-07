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
        if math.random(1, 5) <= 1 then
            local props = self.object:get_properties()
            props.show_on_minimap = true
            self.object:set_properties(props)
        end
    end,
	do_custom = function(self, dtime)
        self.despawn_timer = self.despawn_timer + dtime
		local object = self.object
        if self.despawn_timer >= 30 then
            if math.random(1, 10) <= 1 then
                herobrine.lightning_strike(object:get_pos())
            end
			herobrine.despawnHerobrine(self)
            return false
        end

        local objs = minetest.get_objects_inside_radius(object:get_pos(), 3)
        for _, obj in pairs(objs) do
            if obj:is_player() then
                if math.random(1, 10) <= 1 then
                    herobrine.lightning_strike(object:get_pos())
                end
				herobrine.despawnHerobrine(self)
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

		local pos, success = herobrine.find_position_near(randplayer:get_pos(), math.random(25, 35))
		if success then
			herobrine.spawnHerobrine("herobrine:herobrine_footsteps", pos)
		end
	end
end)

--> Chatcommands.
local function hud_waypoint_def(pos)
    return {
    	hud_elem_type = "waypoint",
    	name = "Position of Footsteps Herobrine:",
    	text = "m",
    	number = 0x85FF00,
    	world_pos = pos
	}
end

local function footsteps_player(pname, target, waypoint)
    local playerobj = minetest.get_player_by_name(pname)
    local targetobj = minetest.get_player_by_name(target)
    if targetobj then
        local ppos = targetobj:get_pos()
        ppos.y = ppos.y + 1
        local pos, success = herobrine.find_position_near(ppos, math.random(25, 35))
        if success then
            if not herobrine.spawnHerobrine("herobrine:herobrine_footsteps", pos) then
                return false, "A Herobrine has already been spawned."
            end
        else
            return false, string.format("Could not find an eligible node.", target)
        end

        if waypoint == "true" then
            local id = playerobj:hud_add(hud_waypoint_def(pos))
            minetest.after(7, function()
                playerobj:hud_remove(id)
            end)
        end

        return true, "Herobrine is spawned at: " .. minetest.pos_to_string(pos, 1)
    else
        return false, "Command is unable to execute."
    end
end

herobrine_commands.register_subcommand("footsteps_player", {
    privs = herobrine_commands.default_privs,
    hidden = true,
    --description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name)
        return footsteps_player(name, name)
    end,
})

herobrine_commands.register_subcommand("footsteps_player :waypoint", {
    privs = herobrine_commands.default_privs,
    --description = "Stalks yourself. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, waypoint)
        return footsteps_player(name, name, waypoint)
    end
})

herobrine_commands.register_subcommand("footsteps_player :target :waypoint", {
    privs = herobrine_commands.default_privs,
    --description = "Stalks a player. If waypoint is true, wherever Herobrine is spawned at will be marked.",
    func = function(name, target, waypoint)
        local player = minetest.get_player_by_name(target)
        if player then
            return footsteps_player(name, target, waypoint)
        else
            return false, "Unable to find " .. target .. "."
        end
    end,
})