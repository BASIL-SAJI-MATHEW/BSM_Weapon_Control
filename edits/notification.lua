-- BSM | Basil Saji Mathew
-- Notification Customization Override

function CustomNotify(title, description, type)
    if Config.UI.NotificationStyle == 'ox_lib' then
        lib.notify({
            title = title,
            description = description,
            type = type,
            position = 'center-right',
            icon = 'shield-halved'
        })
    else
        -- Add your custom notification export here!
        -- Example (ESX):
        -- TriggerEvent('esx:showNotification', description)
        -- Example (QBCore):
        -- TriggerEvent('QBCore:Notify', description, type)
        print("[Notify] " .. title .. " | " .. description)
    end
end
