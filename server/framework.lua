-- BSM | Basil Saji Mathew
-- Framework Abstraction Layer

BSM = {}
BSM.Framework = nil

-- Identify Framework
CreateThread(function()
    Wait(500) -- Allow resources to load
    if Config.Framework == 'esx' or (Config.Framework == '' and GetResourceState('es_extended') == 'started') then
        BSM.Framework = 'esx'
        local ESX = exports['es_extended']:getSharedObject()
        BSM.GetPlayerIdentifier = function(src)
            local xPlayer = ESX.GetPlayerFromId(src)
            return xPlayer and xPlayer.identifier or nil
        end
        BSM.HasJob = function(src, jobs)
            local xPlayer = ESX.GetPlayerFromId(src)
            if not xPlayer then return false end
            for _, job in ipairs(jobs) do
                if xPlayer.job.name == job then return true end
            end
            return false
        end
    elseif Config.Framework == 'qbcore' or (Config.Framework == '' and GetResourceState('qb-core') == 'started') then
        BSM.Framework = 'qbcore'
        local QBCore = exports['qb-core']:GetCoreObject()
        BSM.GetPlayerIdentifier = function(src)
            local Player = QBCore.Functions.GetPlayer(src)
            return Player and Player.PlayerData.citizenid or nil
        end
        BSM.HasJob = function(src, jobs)
            local Player = QBCore.Functions.GetPlayer(src)
            if not Player then return false end
            for _, job in ipairs(jobs) do
                if Player.PlayerData.job.name == job then return true end
            end
            return false
        end
    elseif Config.Framework == 'qbox' or (Config.Framework == '' and GetResourceState('qbx_core') == 'started') then
        BSM.Framework = 'qbox'
        local qbx = exports.qbx_core
        BSM.GetPlayerIdentifier = function(src)
            local Player = qbx:GetPlayer(src)
            return Player and Player.PlayerData.citizenid or nil
        end
        BSM.HasJob = function(src, jobs)
            local Player = qbx:GetPlayer(src)
            if not Player then return false end
            for _, job in ipairs(jobs) do
                if Player.PlayerData.job.name == job then return true end
            end
            return false
        end
    else
        BSM.Framework = 'standalone'
        BSM.GetPlayerIdentifier = function(src)
            for _, id in ipairs(GetPlayerIdentifiers(src)) do
                if string.match(id, "license:") then
                    return id
                end
            end
            return GetPlayerIdentifier(src, 0)
        end
        BSM.HasJob = function(src, jobs)
            -- Standalone has no job concept, default to false
            return false
        end
    end
    print('^2[BSM-WEAPON-CONTROL]^0 Framework initialized: ' .. BSM.Framework)
end)
