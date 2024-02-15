# Settings

## How to register a setting.

### `herobrine_settings.register_setting(name, def)`
1. `name` is a string.
2. `def` includes:
   1. `type` = Could be `"table", "boolean", "string", "number"`
      1. Some extra things about the `number` type.
         1. `min` = Smallest value the number can be. Defaults to `0`.
         2. `max` = Largest value the number can be. Defaults to `65536`.
   2. `description` = Description of the setting. Defaults to `""`
   3. `value`= Initial value to be registered. The value has to be equal to the type, otherwise it will not be registered.

### An Example:
``` lua
herobrine_settings.register_setting("stalking_timer", {
    type = "number",
    description = "Interval between when Herobrine stalks a player.",
    value = 120,
})
```