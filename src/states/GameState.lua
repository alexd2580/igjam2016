local GameState = class('GameState', State)

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")
SwarmSystem = require("systems/SwarmSystem")

local Drawable, Physical, SwarmMember = Component.load({'Drawable', 'Physical', 'SwarmMember'})

function GameState:load()
    self.engine = lt.Engine()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(beginContact, endContact)
    self.eventmanager = lt.EventManager()

    -- add systems to engine
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(PlayerControlSystem())
    self.engine:addSystem(SwarmSystem())

    player = lt.Entity()
    player:add(Drawable({0, 255, 0, 255}))
    local body = love.physics.newBody(self.world, 100, 100, "dynamic")
    body:setLinearDamping(0.999)
    local shape = love.physics.newCircleShape(10)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.9)
    fixture:setUserData(player)
    body:setMass(2)

    player:add(Physical(body, fixture, shape))

    self.engine:addEntity(player)
    for i = 1, 30, 1 do
        swarm_member = lt.Entity()

        local x, y = love.math.random(50, 150), love.math.random(50, 150)
        local body = love.physics.newBody(self.world, x, y, "dynamic")
        body:setLinearDamping(0.6)
        local shape = love.physics.newCircleShape(10)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setRestitution(0.0)
        fixture:setUserData(swarm_member)
        body:setMass(2)

        swarm_member:add(Physical(body, fixture, shape))
        swarm_member:add(SwarmMember())
        swarm_member:add(Drawable({0, 0, 255, 255}))
        self.engine:addEntity(swarm_member)
    end
end

function GameState:update(dt)
    self.engine:update(dt)
    self.world:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key)
end

return GameState
