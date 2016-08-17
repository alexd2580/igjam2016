local CreditsState = class('CreditsState', State)

local suit = require('lib/suit')

function CreditsState:update(dt)
    suit.layout:reset(100, 100)
    suit.Label("\"Glowing Geometry\"\nFabian Gremper (supergamemusic.com)\nLicensed under Creative Commons: By Attribution 4.0", {align = "left"}, suit.layout:row(400, 100))

    suit.layout:reset(constants.screenWidth - 240, constants.screenHeight - 80, 10, 10)
    if suit.Button("Back", suit.layout:row(200, 40)).hit then
        stack:pop()
    end
end

function CreditsState:draw()
    suit:draw()
end

return CreditsState
