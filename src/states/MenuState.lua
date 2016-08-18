local MenuState = class('MenuState', State)

local suit = require('lib/suit')

local CustomizeState = require('states/CustomizeState')
local CreditsState = require('states/CreditsState')

function MenuState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(push:getWidth() - 210, push:getHeight() - 100, 10, 10)

    if suit.Button("Start Game", suit.layout:row(200, 40)).hit then
        stack:push(CustomizeState())
    end

    if suit.Button("Credits", suit.layout:row(200, 40)).hit then
        stack:push(CreditsState())
    end
end

function MenuState:draw()
    push:apply("start")
    suit:draw()
    push:apply("end")
end

function MenuState:keypressed(key)
    if key == "space" then
        stack:push(CustomizeState())
    end
end

return MenuState
