nxHUD_SeatbeltOn = false -- Fallback variable for standalone seatbelt

-- DEV COMMAND: Force UI to show
RegisterCommand('devhud', function()
    SendNUIMessage({ action = "showUI" })
    DebugPrint("Dev command: Sent showUI event.")
end)

-- DEV COMMAND: Force Car HUD to show
RegisterCommand('devcar', function()
    SendNUIMessage({ action = "showCarHUD" })
    DebugPrint("Dev command: Sent showCarHUD event.")
end)

-- DEV COMMAND: Test Info Panel data
RegisterCommand('devinfo', function()
    UpdatePlayerInfo(150000, 2500000, "Developer - Boss")
    DebugPrint("Dev command: Sent mock Info data.")
end)

-- Standalone Seatbelt Command (Used if State Bags are unavailable)
RegisterCommand('seatbelt', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        nxHUD_SeatbeltOn = not nxHUD_SeatbeltOn
    end
end)
RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', 'B')

-- Global function called by Bridge files to send data to NUI
function UpdatePlayerInfo(cash, bank, jobName)
    local playerId = GetPlayerServerId(PlayerId())
    
    SendNUIMessage({
        action = "updateInfo",
        id = playerId,
        cash = cash or 0,
        bank = bank or 0,
        job = jobName or "Unemployed"
    })
    DebugPrint("Player Info updated: ID " .. playerId .. " | " .. jobName)
end