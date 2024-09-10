QBCore = exports['qb-core']:GetCoreObject()
local stealingCooldown = {}  -- Cooldown table for players
local cooldownTime = 300  -- 5 minutes cooldown (300 seconds)
local failCount = 0  -- Tracks the number of failed attempts per player

-- Function to handle the catalytic converter theft
function StealCatalyticConverter(vehicle)
    local playerPed = PlayerPedId()
    local vehicleCoords = GetEntityCoords(vehicle)

    -- Check if the player has the required item (oxycutter)
    QBCore.Functions.TriggerCallback('catalyticconverter:server:hasOxycutter', function(hasOxycutter)
        if not hasOxycutter then
            QBCore.Functions.Notify("You need a " .. Config.RequiredItem .. " to steal the catalytic converter.", "error")
            return
        end

        -- Rotate the player 180 degrees before starting the animation
        local playerHeading = GetEntityHeading(playerPed)
        SetEntityHeading(playerPed, playerHeading + 180.0)

        -- Small delay to ensure the rotation completes before playing the animation
        Citizen.Wait(500)

        -- Play the mechanic3 emote
        RequestAnimDict("amb@world_human_vehicle_mechanic@male@base")
        while not HasAnimDictLoaded("amb@world_human_vehicle_mechanic@male@base") do
            Citizen.Wait(100)
        end

        TaskPlayAnim(playerPed, "amb@world_human_vehicle_mechanic@male@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)

        -- Start the mini-game from minigame.lua after a short delay
        Citizen.Wait(1000)  -- Small delay before mini-game starts
        local success = StartMiniGame()

        if success then
            -- Successful mini-game, now proceed to check item reward
            failCount = 0  -- Reset fail count on success
            TriggerServerEvent('catalyticconverter:server:reward', vehicleCoords)  -- Ask server to handle rewards
        else
            -- Failed mini-game
            failCount = failCount + 1
            QBCore.Functions.Notify("You failed to steal the catalytic converter.", "error")

            -- Call the police if the player fails multiple times
            if failCount >= Config.CallPoliceAfterFails then
                TriggerEvent('dispatch:notifyPolice', vehicleCoords)  -- Automatically notify the police
                failCount = 0  -- Reset fail count
            end
        end

        -- End animation
        ClearPedTasks(playerPed)
    end)
end

-- Add target zones to all vehicles
exports['qb-target']:AddTargetModel(GetAllVehicleModels(), {
    options = {
        {
            type = "client",
            event = "catalyticconverter:client:startStealing",
            icon = "fas fa-tools",
            label = "Steal Catalytic Converter",
            canInteract = function(entity)
                -- Allow interaction if the player is close to the vehicle
                return true
            end
        }
    },
    distance = 1.5  -- Set a short distance for interaction (players must be next to the car)
})

-- Start stealing process
RegisterNetEvent('catalyticconverter:client:startStealing', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) or GetVehiclePedIsTryingToEnter(PlayerPedId())

    -- Cooldown check
    if stealingCooldown[PlayerPedId()] and (GetGameTimer() - stealingCooldown[PlayerPedId()]) < cooldownTime * 1000 then
        QBCore.Functions.Notify("You need to wait before stealing again!", "error")
        return
    end

    -- Initiate theft process
    StealCatalyticConverter(vehicle)
end)

-- Apply the cooldown after the server confirms the player received the item
RegisterNetEvent('catalyticconverter:client:applyCooldown', function()
    stealingCooldown[PlayerPedId()] = GetGameTimer()  -- Set cooldown timer after successful theft
end)
