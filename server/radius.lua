-- BSM | Basil Saji Mathew
-- Radius Logic

function HandleRadiusAction(source, action, duration)
    -- actions: 'disable', 'enable'
    local srcTimer = duration or Config.Timer.DefaultDisableTime
    local srcPed = GetPlayerPed(source)
    local srcCoords = GetEntityCoords(srcPed)

    local players = GetPlayers()
    local count = 0

    for _, pid in ipairs(players) do
        local tSrc = tonumber(pid)
        -- Skip self
        if tSrc ~= source then
            local bypass = false
            if action == 'disable' then
                 if BSM.HasJob(tSrc, Config.BypassJobs) then bypass = true end
            end

            if not bypass then
                local tPed = GetPlayerPed(tSrc)
                local tCoords = GetEntityCoords(tPed)
                local dist = #(srcCoords - tCoords)
                
                if dist <= Config.Radius.Distance then
                    if action == 'disable' then
                        exports.bsm_weapon_control:disableWeapons(tSrc, srcTimer, "Radius Disarmed by Player " .. source)
                        count = count + 1
                    elseif action == 'enable' then
                        exports.bsm_weapon_control:enableWeapons(tSrc)
                        count = count + 1
                    end
                end
            end
        end
    end

    if action == 'disable' then
        TriggerClientEvent('bsm_weapon_control:client:notify', source, 'Success', ('Disabled weapons for %s nearby players.'):format(count), 'success')
        SendLog("Disarm Used", ("Player ID %s used disarm in radius, affected %s players."):format(source, count))
    else
        TriggerClientEvent('bsm_weapon_control:client:notify', source, 'Success', ('Enabled weapons for %s nearby players.'):format(count), 'success')
        SendLog("Enabler Used", ("Player ID %s used enabler in radius, affected %s players."):format(source, count))
    end
end
