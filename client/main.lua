-- Synced sling for ox_inventory.
-- Everyone sees the slung weapon prop. Components are applied to the weapon object when possible.

local ESX
local PlayerData = {}

local mySling = {
    [1] = { active = false, weaponHash = nil, slot = nil, components = nil },
    [2] = { active = false, weaponHash = nil, slot = nil, components = nil },
}

local remoteSlings = {} -- [serverId] = { [slot] = { obj = entity, weaponHash = hash } }

-- Local (your own) visible sling object so you also see it.
local localObjs = { [1] = nil, [2] = nil }

local function notify(description, ntype)
    ntype = ntype or 'inform'
    if GetResourceState('ox_lib') == 'started' then
        TriggerEvent('ox_lib:notify', { type = ntype, description = description })
    elseif ESX and ESX.ShowNotification then
        ESX.ShowNotification(description)
    else
        -- fallback
        print(('[sling] %s'):format(description))
    end
end

-- If a weapon is slung, block drawing it and tell the player to unsling first.
CreateThread(function()
    while true do
        Wait(200)
        local ped = PlayerPedId()
        if not DoesEntityExist(ped) then goto continue end

        local selected = GetSelectedPedWeapon(ped)
        if selected and selected ~= `WEAPON_UNARMED` then
            for i = 1, 2 do
                local s = mySling[i]
                if s.active and s.weaponHash and selected == s.weaponHash then
                    -- Immediately force holster/disarm to prevent using it.
                    if Config and Config.UseOxInventory then
                        TriggerEvent('ox_inventory:disarm', true)
                    else
                        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                    end
                    notify('You currently have this weapon slung. Unsling it first.', 'error')
                    Wait(900) -- reduce spam
                    break
                end
            end
        end

        ::continue::
    end
end)


local function ensureESX()
    if ESX then return end
    local ok, obj = pcall(function() return exports.es_extended:getSharedObject() end)
    if ok and obj then
        ESX = obj
        PlayerData = ESX.GetPlayerData() or {}
        return
    end
    -- legacy fallback
    TriggerEvent('esx:getSharedObject', function(o) ESX = o end)
    if ESX then PlayerData = ESX.GetPlayerData() or {} end
end

local function refreshJob()
    if not Config.RestrictToJobs then return true end
    ensureESX()
    if not ESX then return false end

    PlayerData = ESX.GetPlayerData() or PlayerData or {}
    local job = PlayerData.job and PlayerData.job.name
    if not job then return false end

    for _, allowed in ipairs(Config.AllowedJobs or {}) do
        if allowed == job then
            return true
        end
    end
    return false
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

local function joaatSafe(v)
    if type(v) == 'number' then return v end
    if type(v) ~= 'string' then return nil end
    -- allow both WEAPON_X and COMPONENT_X style strings
    return joaat(v)
end

local function normalizeComponents(comp)
    if not comp then return {} end

    local out = {}

    -- comp can be array of hashes, array of strings, or map
    if type(comp) == 'table' then
        -- array
        local isArray = (#comp > 0)
        if isArray then
            for _, c in ipairs(comp) do
                if type(c) == 'number' then
                    out[#out+1] = c
                elseif type(c) == 'string' then
                    -- item name? map it
                    local mapped = Config.ComponentItemToHashes and Config.ComponentItemToHashes[c]
                    if mapped and type(mapped) == 'table' then
                        for _, mh in ipairs(mapped) do
                            local h = joaatSafe(mh)
                            if h then out[#out+1] = h end
                        end
                    else
                        local h = joaatSafe(c)
                        if h then out[#out+1] = h end
                    end
                end
            end
            return out
        end

        -- map/dict: values or keys might be hashes
        for k, v in pairs(comp) do
            if type(v) == 'number' then
                out[#out+1] = v
            elseif type(v) == 'string' then
                local h = joaatSafe(v)
                if h then out[#out+1] = h end
            end
            if type(k) == 'number' then
                out[#out+1] = k
            elseif type(k) == 'string' then
                local hk = joaatSafe(k)
                if hk then out[#out+1] = hk end
            end
        end
    end

    return out
end

local function getCurrentOxWeapon()
    if not Config.UseOxInventory then return nil end
    local ok, w = pcall(function()
        return exports.ox_inventory:getCurrentWeapon()
    end)
    if not ok or not w then return nil end

    -- expected fields: name, slot, metadata
    local weaponName = w.name
    local weaponHash = joaatSafe(weaponName)

    local meta = w.metadata or {}
    local comps = meta.components or meta.attachments or w.components

    return {
        name = weaponName,
        hash = weaponHash,
        slot = w.slot,
        metadata = meta,
        components = normalizeComponents(comps)
    }
end

local function isAllowedWeapon(hash)
    if not hash then return false end
    if Config.AllowAllOxWeapons then return true end

    for _, wh in ipairs(Config.AllowedWeapons or {}) do
        local h = joaatSafe(wh)
        if h and h == hash then return true end
    end
    return false
end

local function requestWeaponAsset(hash)
    if not hash then return end
    if HasWeaponAssetLoaded(hash) then return end
    RequestWeaponAsset(hash)
    while not HasWeaponAssetLoaded(hash) do
        Wait(0)
    end
end

local function applyComponentsToWeaponObject(weaponObj, componentHashes)
    if not weaponObj or not DoesEntityExist(weaponObj) then return end
    if type(componentHashes) ~= 'table' then return end

    for _, comp in ipairs(componentHashes) do
        if type(comp) == 'number' then
            -- this native silently fails if incompatible
            pcall(function()
                GiveWeaponComponentToWeaponObject(weaponObj, comp)
            end)
        end
    end
end

local function deleteLocalObj(slot)
    local obj = localObjs[slot]
    if obj and DoesEntityExist(obj) then
        DeleteEntity(obj)
    end
    localObjs[slot] = nil
end

local function createLocalObj(slot, weaponHash, components)
    local ped = PlayerPedId()
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    deleteLocalObj(slot)
    requestWeaponAsset(weaponHash)

    local obj = CreateWeaponObject(weaponHash, 1, 0.0, 0.0, 0.0, true, 1.0, 0)
    applyComponentsToWeaponObject(obj, components)

    local pos = Config.Positions[slot] or Config.Positions[2]
    AttachEntityToEntity(
        obj,
        ped,
        GetPedBoneIndex(ped, pos.bone),
        pos.x, pos.y, pos.z,
        pos.rx, pos.ry, pos.rz,
        true, true, false, false, 2, true
    )

    localObjs[slot] = obj
end

local function deleteRemoteObj(serverId, slot)
    if not remoteSlings[serverId] or not remoteSlings[serverId][slot] then return end
    local obj = remoteSlings[serverId][slot].obj
    if obj and DoesEntityExist(obj) then
        DeleteEntity(obj)
    end
    remoteSlings[serverId][slot] = nil
    if next(remoteSlings[serverId]) == nil then
        remoteSlings[serverId] = nil
    end
end

local function createRemoteObj(serverId, slot, weaponHash, components)
    local ply = GetPlayerFromServerId(serverId)
    if ply == -1 then return end
    local ped = GetPlayerPed(ply)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end

    deleteRemoteObj(serverId, slot)

    requestWeaponAsset(weaponHash)

    -- CreateWeaponObject returns a weapon object (can accept components)
    local obj = CreateWeaponObject(weaponHash, 1, 0.0, 0.0, 0.0, true, 1.0, 0)

    -- Apply components before attaching (either works, but this is consistent)
    applyComponentsToWeaponObject(obj, components)

    local pos = Config.Positions[slot]
    if not pos then
        pos = Config.Positions[2]
    end

    AttachEntityToEntity(
        obj,
        ped,
        GetPedBoneIndex(ped, pos.bone),
        pos.x, pos.y, pos.z,
        pos.rx, pos.ry, pos.rz,
        true, true, false, false, 2, true
    )

    remoteSlings[serverId] = remoteSlings[serverId] or {}
    remoteSlings[serverId][slot] = { obj = obj, weaponHash = weaponHash }
end

-- Keep remote slings attached (handles ped respawn/streaming)
CreateThread(function()
    while true do
        Wait(1500)
        for serverId, slots in pairs(remoteSlings) do
            local ply = GetPlayerFromServerId(serverId)
            if ply == -1 then
                -- player not in scope
                for slot, _ in pairs(slots) do
                    deleteRemoteObj(serverId, slot)
                end
            else
                local ped = GetPlayerPed(ply)
                if ped ~= 0 and DoesEntityExist(ped) then
                    for slot, data in pairs(slots) do
                        if data.obj and DoesEntityExist(data.obj) then
                            if not IsEntityAttachedToEntity(data.obj, ped) then
                                local pos = Config.Positions[slot]
                                if pos then
                                    AttachEntityToEntity(
                                        data.obj,
                                        ped,
                                        GetPedBoneIndex(ped, pos.bone),
                                        pos.x, pos.y, pos.z,
                                        pos.rx, pos.ry, pos.rz,
                                        true, true, false, false, 2, true
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Sync from server: one player/slot changed
RegisterNetEvent('scully_sling:syncOne', function(serverId, slot, data)
    if serverId == GetPlayerServerId(PlayerId()) then
        -- Don't create a REMOTE prop for yourself; we render locally via createLocalObj.
        return
    end

    if not data then
        deleteRemoteObj(serverId, slot)
        return
    end

    createRemoteObj(serverId, slot, data.weaponHash, data.components)
end)

-- Sync full state
RegisterNetEvent('scully_sling:syncAll', function(state)
    -- wipe existing
    for serverId, slots in pairs(remoteSlings) do
        for slot, _ in pairs(slots) do
            deleteRemoteObj(serverId, slot)
        end
    end

    for serverId, slots in pairs(state or {}) do
        if tonumber(serverId) ~= GetPlayerServerId(PlayerId()) then
            for slot, data in pairs(slots) do
                if data and data.weaponHash then
                    createRemoteObj(tonumber(serverId), tonumber(slot), data.weaponHash, data.components)
                end
            end
        end
    end
end)

-- Ask server for state on start
CreateThread(function()
    Wait(1500)
    TriggerServerEvent('scully_sling:requestSync')
end)

local function sling(slot)
    if Config.RestrictToJobs and not refreshJob() then
        TriggerEvent('ox_lib:notify', { type = 'error', description = 'You are not allowed to sling weapons.' })
        return
    end

    local ped = PlayerPedId()

    if mySling[slot].active then
        -- UNSLING: re-equip previous slot weapon
        local oldSlot = mySling[slot].slot
        if oldSlot then
            pcall(function()
                exports.ox_inventory:useSlot(oldSlot)
            end)
            Wait(150)

            -- re-apply components to ped if needed (usually ox handles it)
            local comps = mySling[slot].components
            local wh = mySling[slot].weaponHash
            if wh and comps and type(comps) == 'table' then
                for _, c in ipairs(comps) do
                    if type(c) == 'number' then
                        pcall(function()
                            GiveWeaponComponentToPed(ped, wh, c)
                        end)
                    end
                end
            end
        end

        mySling[slot] = { active = false, weaponHash = nil, slot = nil, components = nil }
        deleteLocalObj(slot)
        TriggerServerEvent('scully_sling:setState', slot, false)
        return
    end

    -- SLING: capture current weapon from ox
    local current = getCurrentOxWeapon()
    if not current or not current.hash or not current.slot then
        notify('No weapon equipped.', 'error')
        return
    end

    if not isAllowedWeapon(current.hash) then
        notify('That weapon cannot be slung.', 'error')
        return
    end

    -- disarm without removing from inventory
    TriggerEvent('ox_inventory:disarm', true)

    mySling[slot] = {
        active = true,
        weaponHash = current.hash,
        slot = current.slot,
        components = current.components or {},
    }

    -- Create your own visible prop immediately
    createLocalObj(slot, current.hash, current.components or {})

    -- Tell server so everyone creates the prop for you
    TriggerServerEvent('scully_sling:setState', slot, {
        weaponHash = current.hash,
        components = current.components or {},
    })

    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
end

RegisterCommand(Config.Command, function(_, args)
    local slot = tonumber(args[1])
    if slot ~= 1 and slot ~= 2 then
        slot = 1
    end
    sling(slot)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for i = 1, 2 do
        deleteLocalObj(i)
    end
    for serverId, slots in pairs(remoteSlings) do
        for slot, _ in pairs(slots) do
            deleteRemoteObj(serverId, slot)
        end
    end
end)
