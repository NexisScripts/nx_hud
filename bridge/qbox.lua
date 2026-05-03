if Framework.Type ~= 'qbox' then return end

-- Centralized function to sync data to UI
local function syncQboxData(val)
    if not val then return end

    -- Sync Needs (Hunger/Thirst)
    if val.metadata then
        local hunger = val.metadata['hunger']
        local thirst = val.metadata['thirst']
        if hunger ~= nil and thirst ~= nil then
            SendNUIMessage({ action = "updateNeeds", hunger = hunger, thirst = thirst })
        end
    end

    -- Sync Money and Job
    if val.money and val.job then
        local cash = val.money['cash'] or 0
        local bank = val.money['bank'] or 0
        
        local jobLabel = val.job.label
        if val.job.grade and val.job.grade.name then
            jobLabel = jobLabel .. " - " .. val.job.grade.name
        end

        UpdatePlayerInfo(cash, bank, jobLabel)
    end
end

-- Listen for framework data updates
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    syncQboxData(val)
end)

-- Initial data fetch (Requested by UI on load)
RegisterNetEvent('nx_hud:requestInitialData', function()
    local PlayerData = exports.qbx_core:GetPlayerData()
    if PlayerData then
        syncQboxData(PlayerData)
        DebugPrint("Initial Qbox data fetched successfully.")
    end
end)

-- Fallback for basic needs
RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    SendNUIMessage({ action = "updateNeeds", hunger = newHunger, thirst = newThirst })
end)