class = require('lib/middleclass')
Vector = require('lib/vector')
shine = require('lib/shine')
lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})

-- components
require("components/Drawable")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")

local Drawable = Component.load({'Drawable'})
player = nil

function love.load()
    engine = lt.Engine()
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact, endContact)
    eventmanager = lt.EventManager()

    player = lt.Entity()
    player:add(Drawable(100, 100, 20))

    -- add systems to engine
    engine:addSystem(DrawSystem())
    engine:addSystem(PlayerControlSystem())

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
