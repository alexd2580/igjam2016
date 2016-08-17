lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})
Vector = require('lib/vector')

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")
SwarmSystem = require("systems/SwarmSystem")

local Drawable = Component.load({'Drawable'})

player = nil

function love.load()
    engine = lt.Engine()
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact, endContact)
    eventmanager = lt.EventManager()

    -- add systems to engine
    engine:addSystem(DrawSystem())
    engine:addSystem(PlayerControlSystem())

    player = lt.Entity()
    player:add(Drawable(100, 100, 20))

    engine:addEntity(player)
end

function love.update(dt)
    engine:update(dt)
    world:update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    engine:draw()
end

-- function love.keypressed(key, isrepeat)
--     eventmanager:fireEvent(KeyPressed(key, isrepeat))
-- end
--
-- function love.mousepressed(x, y, button)
--     eventmanager:fireEvent(MousePressed(x, y, button))
-- end

function beginContact(a, b, coll)
end

function endContact(a, b, coll)
end
