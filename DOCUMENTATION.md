# In the Fog API Documentation

## Herobrine Settings API

### `herobrine_settings.register_setting(name, def, hidden)`

Returns `true` for success and `false` for failure.

- `name` is a string.
- `def` includes:
  - `type` = Could be `"table", "boolean", "string", "number"`
    - Some extra things about the `number` type.
      - `min` = Smallest value the number can be. Defaults to `0`.
      - `max` = Largest value the number can be. Defaults to `65536`.
  - `description` = Description of the setting. Defaults to `""`
  - `value`= Initial value to be registered. The value has to be equal to the type, otherwise it will not be registered.
- `hidden` is a boolean.
  - If true, the setting will not show up in `/herobrine settings`.
  - Default value is false.

**EXAMPLE:**

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
- `herobrine_settings.nearest_value(tbl, number)`  - Returns `index, val`.
  - Calculates the closest index to `number` in `tbl`.
  - `tbl` should be an array.
  - `index` is an numerical index from an array.
  - `val` is the value found using `tbl[index]`.
- `herobrine_settings.get_setting_val_from_day_count(name, days)` - Returns `val, success`
  - Calculated the output from a specific setting.
  - `name` is a string, but must be a valid setting name, whether hidden or not.
  - `days` is a number.
  - `val` could be `"table", "string", "boolean", "number"`.
  - `success` is a boolean. `true` for success and `false` for failure.
  - This function is super specific. See example below.

**EXAMPLE:**

``` lua
herobrine_settings.register_setting("ambience_chance", {
    type = "table",
    description = "The chance of a random sound playing.",
    value = {
        days = {0, 2, 5, 10},
        vals = {0, 10, 15, 20}
    }
}, true)

local chance, success = herobrine_settings.get_setting_val_from_day_count("ambience_chance", 3) --> 3 is closest to 2, so it will return whatever the second index is in the vals table.
print(chance) --> 10
print(success) --> true
```

## Herobrine Ambience API

- `herobrine_ambience.register_sound(name)` - Registers a sound name. Returns `true` for success.
- `herobrine_ambience.unregister_sound(name)` - Unregisters a sound. Returns `true` for success and `false` for failure.
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

**EXAMPLE:**

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
  - `player` is an `ObjectRef`
  - `duration` - How long the jumpscare photo will be shown on the player's screen.
  - `sound` - If `true`, a sound will go off when a player has been jumpscared.
- `herobrine.line_of_sight(pos1, pos2)` - Returns `boolean, pos`
  - Checks if there are any **opaque** blocks between `pos1` and `pos2`.
  - Returns false if unsuccessful.
  - Returns the position of the blocking node when `false`.
- `herobrine.lighting_strike(pos)` - Spawns a lightning strike at `pos`, only if the mod `lightning` by sofar is enabled.
- `herobrine.get_day_count()` - Returns a number.
  - Independent from what is returned in `minetest.get_day_count()`.
  - Used for internal calculations within the mod.
- `herobrine.set_day_count(num)`
  - Sets the daycount.
  - `num` is a number.

### Subcommands

- `herobrine.register_subcommand(name, def, hidden)` - Registers a subcommand under the `herobrine` command.
  - `name` and `def` are both the equivalent to `name` and `def` from [lib_chatcmdbuilder](https://content.minetest.net/packages/rubenwardy/lib_chatcmdbuilder/).
  - `hidden` is a boolean. If set to true, the command will not be shown when `/herobrine help` is executed. Default is false.

**EXAMPLE:**

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

The command can then be accessed using `/herobrine save_settings`.

## Registration Functions

- `herobrine.register_on_day_change(function(daycount))`
  - Called when the **internal** daycount has changed.
  - `daycount` is a number.
- `herobrine.register_on_spawn(function(name, pos))`
  - Called when a Herobrine mob is spawned.
  - Types: `"herobrine:herobrine", "herobrine:herobrine_footsteps", "herobrine:herobrine_stalker"`.
  - `pos` is a position where the mob was spawned at.

## In the Fog API Variables

- `herobrine.commands.default_privs` - Returns a table with the default privileges.
  - Can be used in both `minetest.register_subcommand` and `herobrine.register_subcommand`.
  - `server, interact, shout, herobrine_admin` are the default privileges.
- `herobrine_settings.conf_modpath` - Returns a filepath used in order to help store herobrine_settings.conf.
  - Defaults to what is returned from `minetest.get_worldpath()`.
