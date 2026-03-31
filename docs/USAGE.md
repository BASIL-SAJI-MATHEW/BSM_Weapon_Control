# Usage & API Guide

This resource replaces legacy command abuse (`/disarm`) with tactile, roleplay-ready items and scalable backend exports.

## How To Use Items
1. Ensure your character has `weapon_disabler` or `weapon_enabler` in their `ox_inventory`.
2. Navigate to an active scene or rule-breaking scenario.
3. Use the item. A progress bar will appear.
4. Once completed, all non-admin, non-exempt players within the configurable radius (default: 15.0 units) will be disarmed!

## Bypass & Exemption
Law Enforcement Officers (`Config.BypassJobs`) or administrators do not suffer from Safe Zone disarmament or Radius disarm items. Ensure your job titles correctly reflect your framework!

---

## Server Exports API
If you want to implement weapon disabling into other resources (e.g., Jail scripts, Robbery cooldowns, Custom Anticheat), use the globally accessible server exports:

### `disableWeapons`
Disables a specific player's weapons.
```lua
---@param src number Server ID of the player
---@param minutes number Duration in minutes
---@param reason string (Optional) Logged reason
exports.bsm_weapon_control:disableWeapons(src, minutes, reason)
```
**Example:**
```lua
-- Disarm player 5 for 30 minutes because they went to jail.
exports.bsm_weapon_control:disableWeapons(5, 30, "Jailed")
```

### `enableWeapons`
Instantly restores a player's combat functionality and wipes any pending cooldown in the database.
```lua
---@param src number Server ID of the player
exports.bsm_weapon_control:enableWeapons(src)
```
**Example:**
```lua
exports.bsm_weapon_control:enableWeapons(5)
```
