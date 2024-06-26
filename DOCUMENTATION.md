# In the Fog API Documentation

## Table of Contents

- [Herobrine Settings API](#herobrine-settings-api)
  - [herobrine_settings.register_setting(name, def)](#herobrine_settingsregister_settingname-def)
  - [Setting Example](#setting-example)
  - [More Settings API Functions](#more-settings-api-functions)
- [Herobrine Ambience API](#herobrine-ambience-api)
- [Herobrine Signs API](#herobrine-signs-api)
  - [Sign Example](#sign-example)
- [Miscellaneous API Functions](#miscellaneous-api-functions)
  - [Command Example](#command-example)
- [In the Fog API Variables](#in-the-fog-api-variables)

## Herobrine Settings API

### `herobrine_settings.register_setting(name, def)`

Returns `true` for success and `false` for failure.

1. `name` is a string.
2. `def` includes:
   1. `type` = Could be `"table", "boolean", "string", "number"`
      1. Some extra things about the `number` type.
         1. `min` = Smallest value the number can be. Defaults to `0`.
         2. `max` = Largest value the number can be. Defaults to `65536`.
   2. `description` = Description of the setting. Defaults to `""`
   3. `value`= Initial value to be registered. The value has to be equal to the type, otherwise it will not be registered.

### Setting Example

``` lua
herobrine_settings.register_setting("stalking_timer", {
    type = "number",
    description = "Interval between when Herobrine stalks a player.",
    value = 120,
})
```

### More Settings API Functions

- `herobrine_settings.get_setting(name)` - Returns a setting's value or `nil`
- `herobrine_settings.get_setting_def(name)` - Returns the definition of setting `name` or `nil`. Definition is the equivalent of the `def` in `herobrine_settings.register_setting`.
- `herobrine_settings.get_settings_list()` - Returns a table with all of the registered settings.
- `herobrine_settings.set_setting(name, val)` - Sets a setting `name` to `val`. Returns `true` for success and `false` for failure.
- `herobrine_settings.convert_value(val, to_type)` - Converts `val` to whatever is states in `to_type`. Returns `nil` if nothing is found. Returns anything but `nil` for success.
  - `to_type` could be `"table", "string", "boolean", "number"`
  - Might replaced for better functionality.
- `herobrine_settings.load_settings()` - Loads all of the settings in `herobrine_settings.conf` in your worldpath to `herobrine_settings`.
- `herobrine_settings.save_settings()` - Saves `herobrine_settings` to `herobrine_settings.conf`.

## Herobrine Ambience API

- `herobrine_ambience.register_sound(name)` - Registers a sound name. Returns `true` for success.
- `herobrine_ambience.unregister_sound(name)` - Unregistered a sound. Returns `true` for success and `false` for failure.
- `herobrine_ambience.get_ambience_list()` - Get all the registered sounds.
- `herobrine_ambience.get_random_sound()` - Gets a random sound from the registered list.
- `herobrine_ambience.play_sound(sound_name, duration)` - Plays sound `sound_name` for `duration` seconds. Returns `sound` and `job`, respectively.
  - `sound` - a handle returned by `minetest.sound_play`
  - `job` - Returns a job table from `minetest.after`

## Herobrine Signs API

- `herobrine.signs.register_text(lang_table, text_table)` - Registers all the strings in `text_table` into every single language in `lang_table`.
- `herobrine.signs.get_full_lang_table()` - Returns all of the languages in a key-value table.
- `herobrine.signs.get_lang_table(lang)` - Returns all the text values in a specific language, `lang`. Returns `nil` if language not found.
- `herobrine.signs.generate_random_text(lang)` - Returns a random string from a specific language.
- `herobrine.signs.find_position_near(pos, radius)` - Similar function to `herobrine.find_position_near(pos, radius)`.
  - Uses the setting `signs_spawnable_on`.
  - Returns an **AIR NODE** that is **ONE BLOCK** above the original position.
- `herobrine.signs.place_sign(pos, text)` - Places a sign at `pos` with `text` as a string on it.
  - Supports `sign_lib`.

### Sign Example

``` lua
herobrine.signs.register_text({"en"}, {
  "I am watching you...",
  "On your six!",
})
```

## Miscellaneous API Functions

- `herobrine.stalk_player(pname, pos)` - Spawns `herobrine:herobrine_stalker` at `pos` facing `pname`.
- `herobrine.find_position_near(pos, radius)` - This function is used in `herobrine/functions/stalking.lua`. Finds a position that meets the standards of `spawnable_on` . Returns `newpos` and `true` for success. Otherwise returns `pos` and `false`.
  - The node returned is an **AIR NODE** that is **TWO BLOCKS** above the original position.
  - `radius` is a number. Must be less than or equal to 79 to stop an overflow.
- `herobrine.jumpscare_player(player, duration, sound)` - Jumpscares a player.
  1. `player` is an `ObjectRef`
  2. `duration` - How long the jumpscare photo will be shown on the player's screen.
  3. `sound` - If `true`, a sound will go off when a player has been jumpscared.
- `herobrine.lighting_strike(pos)` - Spawns a lightning strike at `pos`, only if the mod `lightning` by sofar is enabled.
- `herobrine.register_subcommand(name, def)` - Registers a subcommand under the `herobrine` command.
  1. `name` and `def` are both the equivalent to `name` and `def` from lib_chatcmdbuilder.
  2. `hidden` - This is put in the definition so it will be hidden from the command `/herobrine help`.

### Command Example

``` lua
herobrine.register_subcommand("save_settings", {
  description = "Saves the current settings to a config file.",
  privs = herobrine.commands.default_privs,
  func = function(name)
      local success = herobrine_settings.save_settings()
      if success then
          minetest.chat_send_player(name, "Able to save to config file.")
      else
          minetest.chat_send_player(name, "Was not able to save to config file,")
      end
  end,
})
```

## In the Fog API Variables

- `herobrine.commands.default_privs` - Returns a table with the default privileges.
  - Can be used in both `minetest.register_subcommand` and `herobrine.register_subcommand`.
  - `server, interact, shout, herobrine_admin` are the default privileges.
- `herobrine_settings.conf_modpath` - Return a filepath used in order to help store herobrine_settings.conf.
  - Defaults to what is returned from `minetest.get_worldpath()`.
