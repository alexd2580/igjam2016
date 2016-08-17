class = require('lib/middleclass')
Vector = require('lib/vector')
shine = require('lib/shine')
lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})

-- Graphic components
require("components/Drawable")

--Graphic systems
DrawSystem = require("systems/DrawSystem")

function love.load()
    engine = lt.Engine()
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact, endContact)
    eventmanager = lt.EventManager()
end

function love.update(dt)
    engine:update(dt)
    world:update(dt)
    if love.keyboard.isDown("a") then
        print('a')
    end
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
