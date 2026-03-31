-- BSM | Basil Saji Mathew
-- Miscellaneous Client Events

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('^2[BSM-WEAPON-CONTROL]^0 Client started successfully.')
end)
