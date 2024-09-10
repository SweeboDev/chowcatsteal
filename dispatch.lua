-- Function to handle police dispatch notification
RegisterNetEvent('dispatch:notifyPolice', function(coords)
    local chanceToAlertPolice = 50  -- 50% chance to notify the police
    if math.random(1, 100) <= chanceToAlertPolice then
        NotifyPolice(coords)
    end
end)

-- Notification function using cd_dispatch
function NotifyPolice(location)
    local data = exports['cd_dispatch']:GetPlayerInfo()

    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'}, 
        coords = data.coords,  -- Use the passed vehicle coords
        title = '999 - Catalytic Converter Theft',
        message = 'A '..data.sex..' was seen stealing a catalytic converter near '..data.street, 
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
            sprite = 431, 
            scale = 1.2, 
            colour = 3,
            flashes = false, 
            text = '911 - Theft in Progress',
            time = 5,
            radius = 0,
        }
    })
end
