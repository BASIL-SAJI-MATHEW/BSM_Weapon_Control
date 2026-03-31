-- BSM | Basil Saji Mathew
-- BSM Weapon Control System | Configuration File

Config = {}

-- Framework Settings
-- Option: 'esx', 'qbcore', 'qbox', 'standalone' 
-- Default string '' enables auto-detection.
Config.Framework = ''

Config.Debug = false

Config.Timer = {
    DefaultDisableTime = 20, -- Default disabled time in minutes (used by exports/radius)
    DeathDisableTime = 20, -- Time in minutes to disable weapons upon death
    RelogRestore = true -- Should the script restore remaining disable time if the player relogs?
}

Config.Features = {
    DeathDisarm = true, -- Disarm players on death and keep disarmed after revive
    ItemUsage = false, -- Enable usage of items (weapon_disabler, weapon_enabler)
    RadiusSystem = true, -- Disable/Enable weapons for players in a radius
    SaveToDatabase = true, -- Enable persistence of disarm states
    SafeZones = true -- Enable safe zone auto-disarm feature
}

Config.Items = {
    Disabler = 'weapon_disabler',
    Enabler = 'weapon_enabler',
    Cooldown = 60 -- Cooldown in seconds before item can be used again
}

Config.Radius = {
    Distance = 15.0 -- Max distance to consider "nearby" for area disarm/enabler
}

-- Permissions & Bypass
Config.AdminGroups = {
    'admin', 'superadmin', 'god'
}

-- Immune Jobs (e.g., LEOs should not be auto-disarmed in safe zones or by area disarm)
Config.BypassJobs = {
    'police', 'sheriff', 'ambulance'
}

-- Safe Zones (Vector3 coordinates and radius)
-- Weapons will be automatically disarmed while inside, and allowed once outside.
Config.SafeZones = {
    { coords = vec3(228.0, -988.0, 30.0), radius = 50.0 } -- Example: Legion Square
}

Config.UI = {
    -- Notification options: 'ox_lib', 'wasabi', or 'custom' (edit edits/notification.lua)
    NotificationStyle = 'ox_lib', 
    -- Progress bar options: 'ox_lib' or 'custom' (edit edits/progressbar.lua)
    ProgressStyle = 'ox_lib' 
}

Config.Logs = {
    Enabled = true,
    Webhook = "" -- Discord Webhook URL for logs
}
