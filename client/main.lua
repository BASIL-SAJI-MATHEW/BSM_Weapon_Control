-- BSM | Basil Saji Mathew
-- Client Core Loop

local isDisarmed = false
local disarmEndTime = 0
local bypassJobs = Config.BypassJobs
local PlayerJob = nil

-- Framework Job Sync
CreateThread(function()
    Wait(2000)
    if Config.Framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        local pData = ESX.GetPlayerData()
        if pData and pData.job then PlayerJob = pData.job.name end
        RegisterNetEvent('esx:setJob', function(job) PlayerJob = job.name end)
    elseif Config.Framework == 'qbcore' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local pData = QBCore.Functions.GetPlayerData()
        if pData and pData.job then PlayerJob = pData.job.name end
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo.name end)
    elseif Config.Framework == 'qbox' then
        local pData = exports.qbx_core:GetPlayerData()
        if pData and pData.job then PlayerJob = pData.job.name end
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo.name end)
    end
end)

local function IsBypassed()
    if not PlayerJob then return false end
    for _, job in ipairs(bypassJobs) do
        if job == PlayerJob then return true end
    end
    return false
end

RegisterNetEvent('bsm_weapon_control:client:setDisarm', function(state, endTime)
    isDisarmed = state
    if endTime then
        disarmEndTime = endTime
    end
end)

-- Main enforcement loop
CreateThread(function()
    local sleep = 1000
    while true do
        sleep = 1000
        
        local ped = PlayerPedId()
        
        if isDisarmed then
            sleep = 5
            local current = GetCloudTimeAsInt() * 1000
            if current >= disarmEndTime and disarmEndTime ~= 0 then
                isDisarmed = false
                TriggerEvent('bsm_weapon_control:client:notify', 'Disarm Expired', 'Your weapons are enabled.', 'success')
            else
                -- Enforce disarm controls
                DisableControlAction(0, 37, true) -- Weapon Wheel
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 140, true) -- Melee
                DisableControlAction(0, 141, true) -- Melee
                DisableControlAction(0, 142, true) -- Melee
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 263, true) -- Melee
                DisableControlAction(0, 264, true) -- Melee
            end
        end

        -- Safe zones check
        if Config.Features.SafeZones and not IsBypassed() and not isDisarmed then
            local coords = GetEntityCoords(ped)
            local inZone = false
            for _, zone in ipairs(Config.SafeZones) do
                if #(coords - zone.coords) <= zone.radius then
                    inZone = true
                    break
                end
            end

            if inZone then
                sleep = 5
                DisableControlAction(0, 37, true) 
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true) 
                DisableControlAction(0, 25, true) 
                DisableControlAction(0, 140, true) 
                DisableControlAction(0, 141, true) 
                DisableControlAction(0, 142, true) 
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 263, true) 
                DisableControlAction(0, 264, true) 
                
                -- Force unequip weapon continuously if drawn
                if GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED` then
                    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                end
            end
        end

        Wait(sleep)
    end
end)
