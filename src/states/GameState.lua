local GameState = class('GameState', State)

local CustomizeState = require('states/CustomizeState')

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")
SwarmSystem = require("systems/SwarmSystem")

local Drawable, Physical, SwarmMember = Component.load({'Drawable', 'Physical', 'SwarmMember'})

function GameState:create_mothership(x, y)
    local mothership = lt.Entity()
    mothership:add(Drawable({0, 255, 0, 255}))
    local body = love.physics.newBody(self.world, x, y, "dynamic")
    body:setLinearDamping(0.999)
    local shape = love.physics.newCircleShape(10)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.9)
    fixture:setUserData(player)
    body:setMass(2)

    mothership:add(Physical(body, fixture, shape))
    return mothership
end

function GameState:spawn_swarm(mothership)
    for i = 1, 30, 1 do
        swarm_member = lt.Entity()

        base_x, base_y = mothership:get('Physical').body:getPosition()

        local x, y = base_x + love.math.random(-50, 50), base_y + love.math.random(-50, 50)
        local body = love.physics.newBody(self.world, x, y, "dynamic")
        body:setLinearDamping(0.6)
        local shape = love.physics.newCircleShape(10)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setRestitution(0.0)
        fixture:setUserData(swarm_member)
        body:setMass(2)

        swarm_member:add(Physical(body, fixture, shape))
        swarm_member:add(SwarmMember(mothership))
        swarm_member:add(Drawable({0, 0, 255, 255}))
        self.engine:addEntity(swarm_member)
    end

end

function GameState:load()
    self.engine = lt.Engine()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(beginContact, endContact)
    self.eventmanager = lt.EventManager()

    -- add systems to engine
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(PlayerControlSystem())
    self.engine:addSystem(SwarmSystem())

    player = self:create_mothership(100, 100)
    enemy = self:create_mothership(700, 700)

    self.engine:addEntity(player)
    self.engine:addEntity(enemy)

    self:spawn_swarm(player)
    self:spawn_swarm(enemy)
end

function GameState:update(dt)
    self.engine:update(dt)
    self.world:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key)
    if key == "c" then
        stack:push(CustomizeState())
    end
end

return GameState
