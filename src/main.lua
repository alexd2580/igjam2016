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

local Drawable, Physical, SwarmMember = Component.load({'Drawable', 'Physical', 'SwarmMember'})

player = nil

function love.load()
    love.window.setMode(1000, 600, {fullscreen=false, vsync=true, resizable=false})

    engine = lt.Engine()
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact, endContact)
    eventmanager = lt.EventManager()

    -- add systems to engine
    engine:addSystem(DrawSystem())
    engine:addSystem(PlayerControlSystem())
    engine:addSystem(SwarmSystem())

    player = lt.Entity()
    player:add(Drawable({0, 255, 0, 255}))
    local body = love.physics.newBody(world, 100, 100, "dynamic")
    body:setLinearDamping(0.999)
    local shape = love.physics.newCircleShape(10)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.9)
    fixture:setUserData(player)
    body:setMass(2)

    player:add(Physical(body, fixture, shape))

    engine:addEntity(player)
    for i = 1, 30, 1 do
        swarm_member = lt.Entity()

        local x, y = love.math.random(50, 150), love.math.random(50, 150)
        local body = love.physics.newBody(world, x, y, "dynamic")
        body:setLinearDamping(0.6)
        local shape = love.physics.newCircleShape(10)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setRestitution(0.0)
        fixture:setUserData(swarm_member)
        body:setMass(2)

        swarm_member:add(Physical(body, fixture, shape))
        swarm_member:add(SwarmMember())
        swarm_member:add(Drawable({0, 0, 255, 255}))
        engine:addEntity(swarm_member)
    end
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
