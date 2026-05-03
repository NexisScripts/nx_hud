if Framework.Type ~= 'qb' then return end

local function syncQBData(val)
    if not val then return end

    if val.metadata then
        local hunger = val.metadata['hunger']
        local thirst = val.metadata['thirst']
        if hunger ~= nil and thirst ~= nil then
            SendNUIMessage({ action = "updateNeeds", hunger = hunger, thirst = thirst })
        end
    end

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

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    syncQBData(val)
end)

RegisterNetEvent('nx_hud:requestInitialData', function()
    local QBCore = exports['qb-core']:GetCoreObject()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData then syncQBData(PlayerData) end
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    SendNUIMessage({ action = "updateNeeds", hunger = newHunger, thirst = newThirst })
end)