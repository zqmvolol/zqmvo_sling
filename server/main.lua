local slingState = {}

local function broadcastState(src)
    TriggerClientEvent('scully_sling:syncAll', -1, slingState)
end

RegisterNetEvent('scully_sling:setState', function(slot, data)
    local src = source
    slingState[src] = slingState[src] or {}

    if data == false then
        slingState[src][slot] = nil
        if next(slingState[src]) == nil then
            slingState[src] = nil
        end
    else
        slingState[src][slot] = data
    end

    TriggerClientEvent('scully_sling:syncOne', -1, src, slot, slingState[src] and slingState[src][slot] or nil)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if slingState[src] then
        slingState[src] = nil
        TriggerClientEvent('scully_sling:syncOne', -1, src, 1, nil)
        TriggerClientEvent('scully_sling:syncOne', -1, src, 2, nil)
    end
end)

-- send current states to players when they join
RegisterNetEvent('scully_sling:requestSync', function()
    local src = source
    TriggerClientEvent('scully_sling:syncAll', src, slingState)
end)
