lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})
Vector = require('lib/vector')

require("components/Drawable")

-- systems
DrawSystem = require("systems/DrawSystem")

local Drawable = Component.load({'Drawable'})

function love.load()
    engine = lt.Engine()
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact, endContact)
    eventmanager = lt.EventManager()
    engine:addSystem(DrawSystem())

    entity = lt.Entity()
    entity:add(Drawable(100, 100, 20))
    engine:addEntity(entity)
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
