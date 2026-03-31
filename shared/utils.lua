-- BSM | Basil Saji Mathew
-- Shared Context: Server + Client Utils

SharedUtils = {}

function SharedUtils.DebugPrint(msg)
    if Config.Debug then
        print('^6[BSM-WEAPON-CONTROL]^0 ' .. msg)
    end
end
