local GameOverState = class('GameOverState', State)

local suit = require('lib/suit')

local texts = {
    won = {
        "You completely obliterated them.",
        "Your parents will be so proud of you!",
        "Well played.",
        "gg ez"
    },
    lost = {
        "Your mom could have played better.",
        "#rekt",
        "Try harder next time.",
        "Come on. It's not that hard."
    }
}

function GameOverState:initialize(won)
    self.won = won
    local text_id = math.random(1, #texts.won)
    self.text = self.won and texts.won[text_id] or texts.lost[text_id]
end

function GameOverState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(0, 100)
	if self.won then
		suit.Label("Victory", {align = "center"}, suit.layout:row(512, 50))
	else
		suit.Label("Game Over", {align = "center"}, suit.layout:row(512, 50))
	end

    suit.Label(self.text, {}, suit.layout:row(512, 50))

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

function GameOverState:keypressed(key)
    if key == "space" then
        stack:pop()
    end
end

function GameOverState:draw()
    push:apply('start')
    suit:draw()
    push:apply('end')
end

return GameOverState
