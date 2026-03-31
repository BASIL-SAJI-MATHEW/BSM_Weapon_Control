-- BSM | Basil Saji Mathew
-- Server Main Script

local PlayersState = {}
local ItemCooldowns = {}

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

-- Usable Items (ox_inventory hook)
CreateThread(function()
    Wait(1000)
    if Config.Features.ItemUsage then
        exports.ox_inventory:RegisterUsableItem(Config.Items.Disabler, function(source, name, item)
            -- Check Cooldown
            local lastUse = ItemCooldowns[source] or 0
            local current = os.time()
            if current - lastUse < Config.Items.Cooldown then
                TriggerClientEvent('bsm_weapon_control:client:notify', source, 'Cooldown', 'You must wait ' .. (Config.Items.Cooldown - (current - lastUse)) .. ' seconds before using this again.', 'error')
                return false
            end
            
            ItemCooldowns[source] = current
            TriggerClientEvent('bsm_weapon_control:client:useItemProgress', source, 'disable')
            -- Return true to consume if required, but generally admin tools aren't consumed
            -- Returning nil or false prevents default consume in some frameworks, we will not remove the item.
            return false 
        end)

        exports.ox_inventory:RegisterUsableItem(Config.Items.Enabler, function(source, name, item)
            local lastUse = ItemCooldowns[source] or 0
            local current = os.time()
            if current - lastUse < Config.Items.Cooldown then
                TriggerClientEvent('bsm_weapon_control:client:notify', source, 'Cooldown', 'You must wait ' .. (Config.Items.Cooldown - (current - lastUse)) .. ' seconds before using this again.', 'error')
                return false
            end
            
            ItemCooldowns[source] = current
            TriggerClientEvent('bsm_weapon_control:client:useItemProgress', source, 'enable')
            return false
        end)
    end
end)

RegisterNetEvent('bsm_weapon_control:server:executeRadiusAction', function(action)
    local src = source
    HandleRadiusAction(src, action, Config.Timer.DefaultDisableTime)
end)
