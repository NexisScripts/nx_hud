if Framework.Type ~= 'esx' then return end

-- Sync ESX Status (Hunger/Thirst)
RegisterNetEvent('esx_status:onTick', function(status)
    local hunger, thirst = 100, 100
    for i=1, #status do
        if status[i].name == 'hunger' then hunger = status[i].percent end
        if status[i].name == 'thirst' then thirst = status[i].percent end
    end
    SendNUIMessage({ action = "updateNeeds", hunger = hunger, thirst = thirst })
end)

-- ESX Initial Player Load
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    local cash, bank = 0, 0
    for i=1, #xPlayer.accounts do
        if xPlayer.accounts[i].name == 'money' then cash = xPlayer.accounts[i].money end
        if xPlayer.accounts[i].name == 'bank' then bank = xPlayer.accounts[i].money end
    end
    UpdatePlayerInfo(cash, bank, xPlayer.job.label .. " - " .. xPlayer.job.grade_label)
end)

-- ESX Job Change Event
RegisterNetEvent('esx:setJob', function(job)
    local playerData = ESX.GetPlayerData() 
    local cash, bank = 0, 0
    if playerData and playerData.accounts then
        for i=1, #playerData.accounts do
            if playerData.accounts[i].name == 'money' then cash = playerData.accounts[i].money end
            if playerData.accounts[i].name == 'bank' then bank = playerData.accounts[i].money end
        end
    end
    UpdatePlayerInfo(cash, bank, job.label .. " - " .. job.grade_label)
end)

-- ESX Account Money Change Event
RegisterNetEvent('esx:setAccountMoney', function(account)
    local playerData = ESX.GetPlayerData()
    local cash, bank = 0, 0
    if playerData and playerData.accounts then
        for i=1, #playerData.accounts do
            if playerData.accounts[i].name == 'money' then cash = playerData.accounts[i].money end
            if playerData.accounts[i].name == 'bank' then bank = playerData.accounts[i].money end
        end
    end
    UpdatePlayerInfo(cash, bank, playerData.job.label .. " - " .. playerData.job.grade_label)
end)