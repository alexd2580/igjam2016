local GameOverSystem = class('GameOverSystem', System)

local GameOverState = require('states/GameOverState')

function GameOverSystem:update(dt)
    if player:get("Health").points <= 0 then
        stack:pop()
        stack:push(GameOverState(false))
    end
end

return GameOverSystem
