-- BSM | Basil Saji Mathew
-- Server Main Script

-- Anti-Tampering: Check script name
if GetCurrentResourceName() ~= 'bsm_weapon_control' then
    print('^1[BSM-WEAPON-CONTROL] WARNING: Script name has been changed! This may cause issues. Please keep the resource name as "bsm_weapon_control".^0')
end

local PlayersState = {}

-- Utility: Logging to Discord
function SendLog(title, message)
    if not Config.Logs.Enabled or Config.Logs.Webhook == "" then return end
    
    local embed = {
        {
            ["color"] = 16711680,
            ["title"] = "**" .. title .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "BSM Weapon Control | " .. os.date("%Y-%m-%d %H:%M:%S"),
            },
        }
    }
    
    PerformHttpRequest(Config.Logs.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "BSM Logs", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Core Function: Disable Weapons
local function _DisableWeapons(src, minutes, reason)
    local identifier = BSM.GetPlayerIdentifier(src)
    if not identifier then return end

    local msDelay = tonumber(minutes) * 60000
    local endTime = (os.time() * 1000) + msDelay

    PlayersState[src] = endTime

    if Config.Features.SaveToDatabase then
        BSM.DB.SaveDisarm(identifier, endTime, reason or "Admin/System Disarm")
    end

    TriggerClientEvent('ox_inventory:disarm', src, false) -- disarm with animation
    TriggerClientEvent('bsm_weapon_control:client:setDisarm', src, true, endTime)
    TriggerClientEvent('bsm_weapon_control:client:notify', src, 'Disarmed', 'Your weapons have been disabled for ' .. minutes .. ' minutes.', 'error')
end

-- Core Function: Enable Weapons
local function _EnableWeapons(src)
    local identifier = BSM.GetPlayerIdentifier(src)
    if not identifier then return end

    PlayersState[src] = nil

    if Config.Features.SaveToDatabase then
        BSM.DB.ClearDisarm(identifier)
    end

    TriggerClientEvent('bsm_weapon_control:client:setDisarm', src, false, 0)
    TriggerClientEvent('bsm_weapon_control:client:notify', src, 'Weapons Allowed', 'Your weapons have been enabled.', 'success')
end

-- Exports
exports('disableWeapons', function(src, minutes, reason)
    _DisableWeapons(src, minutes, reason)
end)

exports('enableWeapons', function(src)
    _EnableWeapons(src)
end)

-- Player Load/Connect
RegisterNetEvent('bsm_weapon_control:server:playerLoaded', function()
    local src = source
    local identifier = BSM.GetPlayerIdentifier(src)
    if not identifier then return end

    if Config.Features.SaveToDatabase and Config.Timer.RelogRestore then
        BSM.DB.GetDisarm(identifier, function(endTime)
            local currentOS = os.time() * 1000
            if endTime > currentOS then
                PlayersState[src] = endTime
                TriggerClientEvent('bsm_weapon_control:client:setDisarm', src, true, endTime)
                TriggerClientEvent('bsm_weapon_control:client:notify', src, 'Disarmed', 'You are still disarmed due to a previous penalty.', 'error')
            end
        end)
    end
end)

-- Death Event Handling
RegisterNetEvent('bsm_weapon_control:server:onPlayerDeath', function()
    local src = source
    if not Config.Features.DeathDisarm then return end
    
    if BSM.HasJob(src, Config.BypassJobs) then return end
    
    _DisableWeapons(src, Config.Timer.DeathDisableTime, "Player Death")
    SendLog("Disarm on Death", "Player ID " .. src .. " died and was disarmed.")
end)

-- Dropping handling (clean up state)
AddEventHandler("playerDropped", function(reason)
    local src = source
    if PlayersState[src] then
        PlayersState[src] = nil
    end
end)

-- Admin Commands

-- Disable weapons for all players in radius
RegisterCommand("wdallradius", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /wdallradius.", "error")
        return
    end
    if source == 0 then
        BSM.Notify(source, "Weapons", "This command can only be used in-game.", "error")
        return
    end
    local minutes = BSM.ParsePositiveNumber(args[1])
    local radius = BSM.ParsePositiveNumber(args[2])
    if not minutes or not radius then
        BSM.Notify(source, "Weapons", "Usage: /wdallradius [minutes] [radius]", "error")
        return
    end
    local count = BSM.ForEachPlayerInRadius(source, radius, function(target)
        _DisableWeapons(target, minutes, "Admin radius command by " .. source)
        BSM.Notify(target, "Weapons", "Your weapons are disabled for " .. minutes .. " minutes.", "warning")
    end)
    BSM.Notify(source, "Weapons", "Disabled weapons for " .. count .. " players within " .. radius .. " meters for " .. minutes .. " minutes.", "success")
    SendLog("Admin Command", "Player " .. source .. " used /wdallradius, affected " .. count .. " players.")
end, false)

-- Enable weapons for all players in radius
RegisterCommand("weallradius", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /weallradius.", "error")
        return
    end
    if source == 0 then
        BSM.Notify(source, "Weapons", "This command can only be used in-game.", "error")
        return
    end
    local radius = BSM.ParsePositiveNumber(args[1])
    if not radius then
        BSM.Notify(source, "Weapons", "Usage: /weallradius [radius]", "error")
        return
    end
    local count = BSM.ForEachPlayerInRadius(source, radius, function(target)
        _EnableWeapons(target, true)
        BSM.Notify(target, "Weapons", "Your weapons are now enabled.", "success")
    end)
    BSM.Notify(source, "Weapons", "Enabled weapons for " .. count .. " players within " .. radius .. " meters.", "success")
    SendLog("Admin Command", "Player " .. source .. " used /weallradius, affected " .. count .. " players.")
end, false)

-- Disable weapons for a specific player
RegisterCommand("wddisable", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /wddisable.", "error")
        return
    end
    local targetId = tonumber(args[1])
    local minutes = BSM.ParsePositiveNumber(args[2])
    if not targetId or not minutes then
        BSM.Notify(source, "Weapons", "Usage: /wddisable [player_id] [minutes]", "error")
        return
    end
    if not GetPlayerName(targetId) then
        BSM.Notify(source, "Weapons", "Player not found.", "error")
        return
    end
    _DisableWeapons(targetId, minutes, "Admin Command by " .. source)
    BSM.Notify(source, "Weapons", "Disabled weapons for player " .. targetId .. " for " .. minutes .. " minutes.", "success")
    BSM.Notify(targetId, "Weapons", "Your weapons are disabled for " .. minutes .. " minutes by an admin.", "warning")
    SendLog("Admin Command", "Player " .. source .. " disabled weapons for player " .. targetId .. " for " .. minutes .. " minutes.")
end, false)

-- Enable weapons for a specific player
RegisterCommand("wenable", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /wenable.", "error")
        return
    end
    local targetId = tonumber(args[1])
    if not targetId then
        BSM.Notify(source, "Weapons", "Usage: /wenable [player_id]", "error")
        return
    end
    if not GetPlayerName(targetId) then
        BSM.Notify(source, "Weapons", "Player not found.", "error")
        return
    end
    _EnableWeapons(targetId)
    BSM.Notify(source, "Weapons", "Enabled weapons for player " .. targetId .. ".", "success")
    BSM.Notify(targetId, "Weapons", "Your weapons are now enabled by an admin.", "success")
    SendLog("Admin Command", "Player " .. source .. " enabled weapons for player " .. targetId .. ".")
end, false)

-- Disable weapons for all players
RegisterCommand("wdall", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /wdall.", "error")
        return
    end
    local minutes = BSM.ParsePositiveNumber(args[1]) or Config.Timer.DefaultDisableTime
    local players = GetPlayers()
    local count = 0
    for _, pid in ipairs(players) do
        local tSrc = tonumber(pid)
        _DisableWeapons(tSrc, minutes, "Admin Command by " .. source)
        BSM.Notify(tSrc, "Weapons", "Your weapons are disabled for " .. minutes .. " minutes by an admin.", "warning")
        count = count + 1
    end
    BSM.Notify(source, "Weapons", "Disabled weapons for all " .. count .. " players for " .. minutes .. " minutes.", "success")
    SendLog("Admin Command", "Player " .. source .. " used /wdall, affected " .. count .. " players.")
end, false)

-- Enable weapons for all players
RegisterCommand("weall", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /weall.", "error")
        return
    end
    local players = GetPlayers()
    local count = 0
    for _, pid in ipairs(players) do
        local tSrc = tonumber(pid)
        _EnableWeapons(tSrc)
        BSM.Notify(tSrc, "Weapons", "Your weapons are now enabled by an admin.", "success")
        count = count + 1
    end
    BSM.Notify(source, "Weapons", "Enabled weapons for all " .. count .. " players.", "success")
    SendLog("Admin Command", "Player " .. source .. " used /weall, affected " .. count .. " players.")
end, false)

-- Check disarm status
RegisterCommand("wdstatus", function(source, args)
    if not BSM.IsAdmin(source) then
        BSM.Notify(source, "Weapons", "You don't have permission to use /wdstatus.", "error")
        return
    end
    local targetId = tonumber(args[1]) or source
    if not GetPlayerName(targetId) then
        BSM.Notify(source, "Weapons", "Player not found.", "error")
        return
    end
    local endTime = PlayersState[targetId]
    if endTime then
        local remaining = math.ceil((endTime - (os.time() * 1000)) / 60000)
        BSM.Notify(source, "Weapons", "Player " .. targetId .. " is disarmed for " .. remaining .. " more minutes.", "info")
    else
        BSM.Notify(source, "Weapons", "Player " .. targetId .. " is not disarmed.", "info")
    end
end, false)
