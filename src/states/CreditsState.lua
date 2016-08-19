local CreditsState = class('CreditsState', State)

local suit = require('lib/suit')

function CreditsState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(100, 100)
    local authors = "> Alisa Dammer\n> Sascha Dmitriev\n> Sven-Hendrik Haase\n> Rafael Epplée\n"
    suit.Label("Authors: \n" .. authors .. "\nBackground Music:\n\"Glowing Geometry\"\nFabian Gremper (supergamemusic.com)\nLicensed under Creative Commons: By Attribution 4.0", {align = "left"}, suit.layout:row(400, 100))

    suit.layout:reset(push:getWidth() - 210, push:getHeight() - 50, 10, 10)
    if suit.Button("Back", suit.layout:row(200, 40)).hit then
        stack:pop()
    end
end

function CreditsState:draw()
    push:apply('start')
    suit:draw()
    push:apply('end')
end

return CreditsState
