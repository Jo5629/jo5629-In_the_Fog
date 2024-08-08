herobrine_commands.register_subcommand("save_settings", {
    description = "Saves the current settings to a config file.",
    privs = herobrine_commands.default_privs,
    func = function(name)
        local success = herobrine_settings.save_settings()
        if success then
            minetest.chat_send_player(name, "Able to save to config file.")
        else
            minetest.chat_send_player(name, "Was not able to save to config file,")
        end
    end,
})

herobrine_commands.register_subcommand("load_settings", {
    description = "Load the settings from herobrine_settings.conf",
    privs = herobrine_commands.default_privs,
    func = function(name)
        local success = herobrine_settings.load_settings()
        if success then
            minetest.chat_send_player(name, "Able to load from config file.")
        else
            minetest.chat_send_player(name, "Was not able to load from config file,")
        end
    end
})

herobrine_commands.register_subcommand("settings", {
    description = "Shows the settings page for the In the Fog mod.",
    privs = {interact = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if not player then return end

        herobrine_settings.setting_formspec:show(player)
    end
})

herobrine_commands.register_subcommand("ambience :word", {
    description = "Plays ambience. Use *random to play a random sound.",
    privs = herobrine_commands.default_privs,
    func = function(name, word)
        local duration = math.random(20, 25)
        if word == "*random" then
            local sound = herobrine_ambience.get_random_sound()
            herobrine_ambience.play_ambience(sound, duration)
            return true, string.format("Playing ambience sound: %s", sound)
        end
        local found = false
        local sound_list = herobrine_ambience.get_ambience_list()
        for _, sound in ipairs(sound_list) do
            if sound == word then
                found = true
                break
            end
        end
        if found then
            herobrine_ambience.play_ambience(word, duration)
            return true, string.format("Playing ambience sound: %s", word)
        else
            minetest.chat_send_player(name, table.concat(herobrine_ambience.get_ambience_list(), ","))
            return false, string.format("Was not able to find sound %s.", word)
        end
    end
})