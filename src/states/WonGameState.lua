local WonGameState = class('WonGameState', State)

local suit = require('lib/suit')

function WonGameState:draw()
    push:apply('start')
    love.graphics.print('you win, hooray!', 30, 30, 0, 5)
    push:apply('end')
end

return WonGameState
