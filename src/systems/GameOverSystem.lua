local GameOverSystem = class('GameOverSystem', System)

local GameOverState = require('states/GameOverState')

function GameOverSystem:update(dt)
    if player:get("Health").points <= 0 then
        stack:pop()
        stack:pop()
        stack:push(GameOverState(false))
    elseif enemy:get("Health").points <= 0 then
        stack:pop()
        stack:pop()
        stack:current():loadLevel(stack:current().level + 1)
        stack:push(GameOverState(true))
    end
end

return GameOverSystem
