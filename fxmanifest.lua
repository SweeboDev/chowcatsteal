fx_version 'cerulean'
game 'gta5'

author 'Chow Catalyic Converter Theft'
description 'Catalytic Converter Theft Script for QBCore using ox_lib and qb-target'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client.lua',
    'minigame.lua',
    'dispatch.lua',
    '@ox_lib/init.lua',  -- Assuming dispatch logic is in a separate file as discussed earlier
}

server_scripts {'server.lua','@oxmysql/lib/MySQL.lua', }

dependencies {
    
}
lua54 'yes'
