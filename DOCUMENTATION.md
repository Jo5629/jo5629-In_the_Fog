# In the Fog API Documentation

## Herobrine Settings API

### How to register a setting.

#### `herobrine_settings.register_setting(name, def)`

Returns `true` for success and `false` for failure.

1. `name` is a string.
2. `def` includes:
   1. `type` = Could be `"table", "boolean", "string", "number"`
      1. Some extra things about the `number` type.
         1. `min` = Smallest value the number can be. Defaults to `0`.
         2. `max` = Largest value the number can be. Defaults to `65536`.
   2. `description` = Description of the setting. Defaults to `""`
   3. `value`= Initial value to be registered. The value has to be equal to the type, otherwise it will not be registered.

#### An Example:

``` lua
herobrine_settings.register_setting("stalking_timer", {
    type = "number",
    description = "Interval between when Herobrine stalks a player.",
    value = 120,
})
```

### More Settings API Functions.

#### `herobrine_settings.get_setting(name)`

Returns a setting's value or `nil`,

#### `herobrine_settings.get_setting_def(name)`

Returns the definition of setting `name` or `nil`. Definition is the equivalent of the `def` in `herobrine_settings.register_setting`.

#### `herobrine_settings.get_settings_list()`

Returns a table with all of the registered settings.

#### `herobrine_settings.set_setting(name, val)`

Sets a setting `name` to `val`. Returns `true` for success and `false` for failure.

#### `herobrine_settings.convert_value(val, to_type)`

Converts `val` to whatever is states in `to_type`. Returns `nil` if nothing is found. Returns anything but `nil` for success.

1.  `to_type` could be `"table", "string", "boolean", "number"`

#### `herobrine_settings.load_settings()`

Loads all of the settings in `herobrine_settings.conf` in your worldpath to `herobrine_settings`.

#### `herobrine_settings.save_settings()`

Saves `herobrine_settings` to `herobrine_settings.conf`.

## Miscellaneous API Functions.

### `herobrine.register_subcommand(name, def)`

Registered a subcommand under the `herobrine` command.

1. `name` and `def` are both the equivalent to `name` and `def` from lib_chatcmdbuilder.
2. `hidden` - This is put in the definition so it will be hidden from the command `/herobrine help`

### `herobrine.jumpscare_player(player, duration, sound)`

Jumpscares a player.

1. `player` is an `ObjectRef`
2. `duration` - How long the jumpscare photo will be shown on the player's screen.
3. `sound` - If `true`, a sound will go off when a player has been jumpscared.

### `herobrine.lighting_strike(pos)`

Spawns a lightning strike at `pos`, only if the mod `lightning` by sofar is enabled.

### `herobrine.find_position_near(pos)`

This function is used in `herobrine/functions/stalking.lua`. Returns another position if one is found, otherwise returns `pos`.

### `herobrine.stalk_player(pname, pos)`

Spawns `herobrine:herobrine_stalker` at `pos` facing `pname`.