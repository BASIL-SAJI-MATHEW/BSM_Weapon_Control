# Installation Guide

Follow these simple steps to install **BSM Weapon Control System** into your FiveM server.

## 1. Database Setup
Import the provided SQL schema to structure the persistence data:
1. Open your MySQL interface (e.g., HeidiSQL, phpMyAdmin).
2. Select your FiveM database.
3. Import the `sql/weapon_control.sql` file.

## 2. Resource Placement
1. Drag and drop the `bsm_weapon_control` folder into your `resources/` directory.
2. Open your `server.cfg` file.
3. Ensure the resource starts **after** your framework and `ox_inventory` / `ox_lib`.
```cfg
ensure oxmysql
ensure ox_lib
ensure ox_inventory
# ... your framework core ...
ensure bsm_weapon_control
```

## 3. Configure Items (ox_inventory)
Since the script uses items instead of commands, you must register them in your `ox_inventory` configuration.

Open `ox_inventory/data/items.lua` and add the following definitions:
```lua
['weapon_disabler'] = {
    label = 'Weapon Disabler Handheld',
    weight = 500,
    stack = false,
    close = true,
    description = 'An admin tool that disables weapons in a 15m radius.',
},
['weapon_enabler'] = {
    label = 'Weapon Enabler Handheld',
    weight = 500,
    stack = false,
    close = true,
    description = 'An admin tool that enables weapons in a 15m radius.',
},
```

*(You can spawn these items via your framework's admin menu, e.g., `/giveitem [id] weapon_disabler 1`)*

## 4. Finalize
1. Review the `config.lua` and tune it to your liking. (See `CONFIG.md`)
2. Restart your server or run `ensure bsm_weapon_control` in your live console.
3. Enjoy!
