QBCore = exports['qb-core']:GetCoreObject()

-- Check if the player has the required item (oxycutter)
QBCore.Functions.CreateCallback('catalyticconverter:server:hasOxycutter', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local oxycutter = Player.Functions.GetItemByName(Config.RequiredItem)

    if oxycutter then
        cb(true)
    else
        cb(false)
    end
end)

-- Reward the player with a catalytic converter
RegisterNetEvent('catalyticconverter:server:reward', function(vehicleCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Try to give the player the item
    local success = Player.Functions.AddItem(Config.ReceivedItem, 1)

    if success then
        -- Notify the client to apply the cooldown only after successful reward
        TriggerClientEvent('catalyticconverter:client:applyCooldown', src)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ReceivedItem], "add")

        -- Chance to notify police (random chance)
        TriggerClientEvent('dispatch:notifyPolice', src, vehicleCoords)
    else
        -- Notify the client that the theft failed (if inventory is full, etc.)
        TriggerClientEvent('QBCore:Notify', src, "Failed to receive item. No space?", "error")
    end
end)
