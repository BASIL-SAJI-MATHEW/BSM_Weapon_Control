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
3. Ensure the resource starts **after** your framework and `ox_lib`.
```cfg
ensure oxmysql
ensure ox_lib
# ... your framework core ...
ensure bsm_weapon_control
```

## 3. Admin Commands
The script now uses admin commands instead of items. Admins with the configured groups can use the following commands:

- `/wdallradius [minutes] [radius]` - Disable weapons for all players in the specified radius for the given minutes.
- `/weallradius [radius]` - Enable weapons for all players in the specified radius.
- `/wddisable [player_id] [minutes]` - Disable weapons for a specific player.
- `/wenable [player_id]` - Enable weapons for a specific player.
- `/wdall [minutes]` - Disable weapons for all players (default minutes if not specified).
- `/weall` - Enable weapons for all players.
- `/wdstatus [player_id]` - Check the disarm status of a player (or yourself if no ID).

Ensure your admins have the groups defined in `config.lua` under `Config.AdminGroups`.

## 4. Finalize
1. Review the `config.lua` and tune it to your liking. (See `CONFIG.md`)
2. Restart your server or run `ensure bsm_weapon_control` in your live console.
3. Enjoy!
