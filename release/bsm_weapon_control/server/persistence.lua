-- BSM | Basil Saji Mathew
-- Database interactions

BSM.DB = {}

function BSM.DB.SaveDisarm(identifier, msUntil, reason)
    if not Config.Features.SaveToDatabase then return end
    if not identifier then return end

    local query = [[
        INSERT INTO bsm_weapon_disarm_states (identifier, disarmed_until, reason) 
        VALUES (?, ?, ?) 
        ON DUPLICATE KEY UPDATE disarmed_until = ?, reason = ?
    ]]
    MySQL.Async.execute(query, {identifier, msUntil, reason, msUntil, reason})
end

function BSM.DB.GetDisarm(identifier, cb)
    if not Config.Features.SaveToDatabase then return cb(0) end
    if not identifier then return cb(0) end

    MySQL.Async.fetchAll('SELECT disarmed_until FROM bsm_weapon_disarm_states WHERE identifier = ?', {identifier}, function(result)
        if result[1] then
            local currentOS = os.time() * 1000
            if tonumber(result[1].disarmed_until) > currentOS then
                cb(tonumber(result[1].disarmed_until))
            else
                -- Expired
                BSM.DB.ClearDisarm(identifier)
                cb(0)
            end
        else
            cb(0)
        end
    end)
end

function BSM.DB.ClearDisarm(identifier)
    if not Config.Features.SaveToDatabase then return end
    if not identifier then return end

    MySQL.Async.execute('DELETE FROM bsm_weapon_disarm_states WHERE identifier = ?', {identifier})
end
