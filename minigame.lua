-- Function to start the mini-game for stealing the catalytic converter
function StartMiniGame()
    -- ox_lib skill check mini-game
    return lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'w', 'a', 's', 'd'})
end
