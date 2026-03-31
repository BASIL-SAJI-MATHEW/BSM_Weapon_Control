-- BSM | Basil Saji Mathew
-- Progress Bar Customization Override

function CustomProgress(label, duration, cb)
    if Config.UI.ProgressStyle == 'ox_lib' then
        if lib.progressBar({
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            }
        }) then
            cb(true)
        else
            cb(false)
        end
    else
        -- Add a custom progress bar implementation here!
        -- Fallback: Call callback immediately if not defined
        cb(true)
    end
end
