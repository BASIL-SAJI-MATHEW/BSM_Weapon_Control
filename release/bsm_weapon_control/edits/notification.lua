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

    elseif Config.UI.NotificationStyle == 'wasabi' then
        exports.wasabi_notify:notify(
            title or "Notification",     -- title
            description or "",           -- message
            5000,                        -- time (ms)
            type or 'info',              -- type (info/success/error/warning)
            false,                       -- sound (optional)
            nil                          -- icon (optional)
        )

    else
        -- Add your custom notification export here!
        -- Example (ESX):
        -- TriggerEvent('esx:showNotification', description)
        -- Example (QBCore):
        -- TriggerEvent('QBCore:Notify', description, type)

        print("[Notify] " .. title .. " | " .. description)
    end
end