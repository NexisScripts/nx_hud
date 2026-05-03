local isLoaded = false
local lastHealth, lastArmor, lastStamina = -1, -1, -1

local function InitHUD()
    if not isLoaded then
        isLoaded = true
        SendNUIMessage({ action = "showUI" })
        TriggerEvent('nx_hud:requestInitialData')
        
        -- Force minimap display if configured
        if not Config.HideRadarOnFoot then
            DisplayRadar(true)
        end
        
        DebugPrint("HUD Initialized and displayed!")
    end
end

-- 1. Wait for NUI Ready signal to prevent race conditions
RegisterNUICallback('nuiReady', function(data, cb)
    DebugPrint("NUI is fully loaded and ready!")
    InitHUD()
    cb('ok')
end)

-- 2. FAILSAFE: Force init if NUI fails to respond after 2 seconds
CreateThread(function()
    Wait(2000)
    if not isLoaded then
        DebugPrint("Fallback: Forcing InitHUD (NUI timeout).")
        InitHUD()
    end
end)

AddEventHandler('playerSpawned', function()
    if isLoaded then SendNUIMessage({ action = "showUI" }) end
    TriggerEvent('nx_hud:requestInitialData')
end)

-- === THREAD: PLAYER STATUS ===
CreateThread(function()
    while true do 
        Wait(Config.StatusUpdateInterval)
        if isLoaded then
            local ped = PlayerPedId()
            local health = GetEntityHealth(ped) - 100
            if health < 0 then health = 0 end
            
            local armor = GetPedArmour(ped)
            local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
            
            if health ~= lastHealth or armor ~= lastArmor or stamina ~= lastStamina then
                SendNUIMessage({
                    action = "updateStatus",
                    health = health, armor = armor, stamina = stamina
                })
                lastHealth = health; lastArmor = armor; lastStamina = stamina
            end
        end
    end
end)

-- === THREAD: VEHICLE HUD & MINIMAP LOGIC ===
CreateThread(function()
    local wasInVehicle = false
    while true do 
        Wait(Config.VehicleUpdateInterval)
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)

        -- RELIABLE MINIMAP LOGIC
        if Config.HideRadarOnFoot then
            DisplayRadar(isInVehicle)
        else
            DisplayRadar(true) -- Always on if configured
        end

        if isInVehicle then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            local rpm = GetVehicleCurrentRpm(vehicle) * 100
            local fuel = GetVehicleFuelLevel(vehicle)
            local isEngineOn = GetIsVehicleEngineRunning(vehicle)
            
            -- Convert raw engine health (0-1000) to percentage
            local engineRaw = GetVehicleEngineHealth(vehicle)
            local engineHealth = math.ceil(engineRaw / 10)
            if engineHealth < 0 then engineHealth = 0 end
            if engineHealth > 100 then engineHealth = 100 end

            -- SMART SEATBELT DETECTION (State Bags fallback)
            local isBeltOn = false
            if LocalPlayer.state.seatbelt ~= nil then
                isBeltOn = LocalPlayer.state.seatbelt
            elseif LocalPlayer.state.isBuckled ~= nil then
                isBeltOn = LocalPlayer.state.isBuckled
            else
                isBeltOn = nxHUD_SeatbeltOn
            end

            if not wasInVehicle then
                SendNUIMessage({ action = "showCarHUD" })
                wasInVehicle = true
            end

            SendNUIMessage({
                action = "updateVehicle",
                speed = math.ceil(speed),
                rpm = rpm,
                fuel = math.ceil(fuel),
                engineHealth = engineHealth,
                engine = isEngineOn,
                gear = GetVehicleCurrentGear(vehicle),
                belt = isBeltOn
            })
        else
            if wasInVehicle then
                SendNUIMessage({ action = "hideCarHUD" })
                wasInVehicle = false
            end
        end
    end
end)

-- === THREAD: HIDE DEFAULT HUD ===
CreateThread(function()
    while true do
        Wait(0)
        if Config.HideDefaultHUD then
            HideHudComponentThisFrame(1)  -- Stars
            HideHudComponentThisFrame(2)  -- Weapon Icon
            HideHudComponentThisFrame(3)  -- Cash
            HideHudComponentThisFrame(4)  -- MP Cash
            HideHudComponentThisFrame(6)  -- Vehicle Name
            HideHudComponentThisFrame(7)  -- Area Name
            HideHudComponentThisFrame(8)  -- Vehicle Class
            HideHudComponentThisFrame(9)  -- Street Name
            HideHudComponentThisFrame(13) -- Cash Change
            HideHudComponentThisFrame(17) -- Save Game
            HideHudComponentThisFrame(20) -- Weapon Stats
        end
    end
end)

-- === THREAD: SCALEFORM HACK FIX (Hide Health/Armor safely) ===
CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    
    while not HasScaleformMovieLoaded(minimap) do 
        Wait(0) 
    end
    
    -- TRICK: Toggle BigMap to force engine texture reload
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    
    while true do
        Wait(0) -- Must be 0ms for scaleform methods
        if Config.HideDefaultHUD then
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
        end
    end
end)