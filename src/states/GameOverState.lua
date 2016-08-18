local GameOverState = class('GameOverState', State)

local suit = require('lib/suit')

function GameOverState:initialize(won)
    self.won = won
end

function GameOverState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(0, 100)
    suit.Label("Game Over", {align = "center"}, suit.layout:row(512, 50))
    local text = self.won and "You crushed the enemy!" or "Try harder next time."
    suit.Label(text, {}, suit.layout:row(512, 50))

    if self.won then
        if suit.Button("Next level", suit.layout:row(512, 40)).hit then
            stack:pop()
        end
    else
        if suit.Button("Back to Hangar", suit.layout:row(512, 40)).hit then
            stack:pop()
        end
    end
end

function GameOverState:draw()
    push:apply('start')
    suit:draw()
    push:apply('end')
end

return GameOverState
