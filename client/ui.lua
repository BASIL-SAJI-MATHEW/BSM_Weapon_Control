-- BSM | Basil Saji Mathew
-- UI Handlers

RegisterNetEvent('bsm_weapon_control:client:notify', function(title, description, pType)
    CustomNotify(title, description, pType)
end)

RegisterNetEvent('bsm_weapon_control:client:useItemProgress', function(action)
    local label = action == 'disable' and 'Disabling Nearby Weapons...' or 'Enabling Nearby Weapons...'
    local duration = 5000 -- 5 Seconds
    
    CustomProgress(label, duration, function(success)
        if success then
            -- Trigger server action
            TriggerServerEvent('bsm_weapon_control:server:executeRadiusAction', action)
        else
            CustomNotify('Cancelled', 'Action was cancelled.', 'error')
        end
    end)
end)
