-- BSM | Basil Saji Mathew
-- Death Event Handlers

CreateThread(function()
    if not Config.Features.DeathDisarm then return end
    
    local isDead = false
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local dead = IsPedDeadOrDying(ped, true) or IsEntityDead(ped)
        
        if dead and not isDead then
            isDead = true
            TriggerServerEvent('bsm_weapon_control:server:onPlayerDeath')
        elseif not dead and isDead then
            isDead = false
        end
    end
end)
