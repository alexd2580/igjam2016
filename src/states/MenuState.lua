local MenuState = class('MenuState', State)

local suit = require('lib/suit')

local GameState = require('states/GameState')
local CreditsState = require('states/CreditsState')

function MenuState:update(dt)
    suit.layout:reset(constants.screenWidth - 240, constants.screenHeight - 120, 10, 10)

    if suit.Button("Start Game", suit.layout:row(200, 40)).hit then
        stack:push(GameState())
    end

    if suit.Button("Credits", suit.layout:row(200, 40)).hit then
        stack:push(CreditsState())
    end
end

function MenuState:draw()
    suit:draw()
end

return MenuState
