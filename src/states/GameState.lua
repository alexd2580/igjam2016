local GameState = class('GameState', State)

local CustomizeState = require('states/CustomizeState')

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")
require("components/HasEnemy")
require("components/HasWeapon")
require("components/Bullet")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")
SwarmSystem = require("systems/SwarmSystem")
AttackSystem = require("systems/AttackSystem")

local Drawable, Physical, SwarmMember, HasEnemy, HasWeapon, Bullet
    = Component.load({'Drawable', 'Physical', 'SwarmMember', 'HasEnemy', 'HasWeapon', 'Bullet'})

function GameState:create_mothership(x, y)
    local mothership = lt.Entity()
    mothership:add(Drawable({0, 255, 0, 255}))
    local body = love.physics.newBody(self.world, x, y, "dynamic")
    body:setLinearDamping(0.999)
    local shape = love.physics.newCircleShape(10)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.9)
    fixture:setUserData(mothership)
    body:setMass(2)

    mothership:add(Physical(body, fixture, shape))
    return mothership
end

function GameState:spawn_swarm(mothership, enemy_mothership)
    for i = 1, 30, 1 do
        swarm_member = lt.Entity()

        base_x, base_y = mothership:get('Physical').body:getPosition()

        local x, y = base_x + love.math.random(-50, 50), base_y + love.math.random(-50, 50)
        local body = love.physics.newBody(self.world, x, y, "dynamic")
        body:setAngle(0)
        body:setAngularDamping(0.8)
        body:setLinearDamping(0.6)
        local shape = love.physics.newCircleShape(10)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setRestitution(0.0)
        fixture:setUserData(swarm_member)
        body:setMass(2)

        swarm_member:add(Physical(body, fixture, shape))
        swarm_member:add(SwarmMember(mothership))
        swarm_member:add(HasEnemy(enemy_mothership))
        swarm_member:add(HasWeapon())
        swarm_member:add(Drawable({0, 0, 255, 255}))
        self.engine:addEntity(swarm_member)
    end
end

function GameState:shoot_bullet(start_pos, dir, speed, enemy_mothership)
    bullet = lt.Entity()

    local body = love.physics.newBody(self.world, start_pos.x, start_pos.y, "dynamic")
    body:setLinearDamping(0.0)
    local shape = love.physics.newCircleShape(1)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.0)
    fixture:setUserData(bullet)
    body:setMass(0)
    body:applyLinearImpulse(dir.x*speed, dir.y*speed)

    bullet:add(Bullet())
    bullet:add(Physical(body, fixture, shape))
    bullet:add(HasEnemy(enemy_mothership))
    bullet:add(Drawable({0, 255, 0, 255}))

    self.engine:addEntity(bullet)
end

function bullet_hit_thing(a, b)
    if not a:has('Bullet') then
        return false -- a must be a bullet
    end
    if b:has('Bullet') then
        return false -- b may not be a bullet
    end
    if not b:has('Physical') then
        return false -- b must be physical
    end
    return true -- a has hit something physical
end

local remove_entities_set = {}

function beginContact(a, b, coll)

    a = a:getUserData()
    b = b:getUserData()

    local bullet, object = nil, nil
    if bullet_hit_thing(a, b) then
        bullet, object = a, b
    elseif bullet_hit_thing(b, a) then
        bullet, object = b, a
    else
        return
    end

    if not remove_entities_set[bullet.id] == nil then
        return
    end

    enemy_mothership = bullet:get('HasEnemy').enemy_mothership

    if object == enemy_mothership then
        mothership_hit(enemy_mothership, bullet)
    elseif object:has('SwarmMember') then
        -- object is a swarmmember
        object_mothership = object:get('SwarmMember').mothership
        if enemy_mothership == object_mothership then
            drone_hit(object, bullet)
        end
    end
end

function mothership_hit(mothership, bullet)
    print('MotherShip hit!')
    remove_entities_set[bullet.id] = bullet
end

function drone_hit(drone, bullet)
    print('Enemy swarmmember hit')
    remove_entities_set[bullet.id] = bullet
end

function endContact(a, b, coll)

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
    self.engine:addSystem(AttackSystem(self))

    player = self:create_mothership(100, 100)
    enemy = self:create_mothership(650, 650)

    self.engine:addEntity(player)
    self.engine:addEntity(enemy)

    self:spawn_swarm(player, enemy)
    self:spawn_swarm(enemy, player)
end

function GameState:update(dt)
    self.engine:update(dt)
    self.world:update(dt)
    for _,entity in pairs(remove_entities_set) do
        entity:get('Physical').body:destroy()
        self.engine:removeEntity(entity)
    end
    remove_entities_set = {}
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
