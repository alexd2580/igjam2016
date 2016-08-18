local GameState = class('GameState', State)

-- Events
require("events/BulletHitDrone")
require("events/BulletHitMothership")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")
SwarmSystem = require("systems/SwarmSystem")
AttackSystem = require("systems/AttackSystem")
BulletRemoverSystem = require("systems/BulletRemoverSystem")
DeathSystem = require("systems/DeathSystem")
ParticlesSystem = require("systems/ParticlesSystem")
BulletHitSystem = require("systems/BulletHitSystem")
MothershipSystem = require("systems/MothershipSystem")
AnimatedDrawSystem = require("systems/AnimatedDrawSystem")
GameOverSystem = require("systems/GameOverSystem")
LaserSystem = require('systems/LaserSystem')

local Drawable, Physical, SwarmMember, HasEnemy, Weapon, Bullet, Health, Particles, Mothership, Animation, LayeredDrawable
    = Component.load({'Drawable', 'Physical', 'SwarmMember', 'HasEnemy', 'Weapon', 'Bullet', 'Health', 'Particles', 'Mothership', 'Animation', 'LayeredDrawable'})

function GameState:initialize(enabledItems)
    self.enabledItems = enabledItems
end

function GameState:create_mothership(mothership, x, y, enemy)
    local drawable = LayeredDrawable()
    drawable:setLayer(1, resources.images.mask_base)
    for layer, id in pairs(self.enabledItems) do
        drawable:setLayer(layer, items[id].image)
    end
    mothership:add(drawable)

    local body = love.physics.newBody(self.world, x, y, "dynamic")
    body:setLinearDamping(0.999)
    body:setMass(2)
    local shape = love.physics.newCircleShape(30)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.9)
    fixture:setUserData(mothership)

    mothership:add(Health(100))
    mothership:add(Mothership())
    mothership:add(HasEnemy(enemy))
    mothership:add(Physical(body, fixture, shape))
    return mothership
end

function GameState:spawn_swarm(mothership, enemy_mothership)
    for i = 1, 30, 1 do
        drone = lt.Entity()

        base_x, base_y = mothership:get('Physical').body:getPosition()

        local x, y = base_x + love.math.random(-50, 50), base_y + love.math.random(-50, 50)
        local body = love.physics.newBody(self.world, x, y, "dynamic")
        body:setAngle(0)
        body:setAngularDamping(0.8)
        body:setLinearDamping(0.6)
        local shape = love.physics.newCircleShape(20)
        local fixture = love.physics.newFixture(body, shape, 1)
        fixture:setRestitution(0.0)
        fixture:setUserData(drone)
        body:setMass(2)

        for layer, id in pairs(self.enabledItems) do
            drone:add(items[id].component())
        end

        drone:add(Physical(body, fixture, shape))
        drone:add(SwarmMember(mothership))
        drone:add(HasEnemy(enemy_mothership))
        drone:add(Drawable(resources.images.fighter))
        drone:add(Health(100))
        self.engine:addEntity(drone)
    end
end

local scheduled_explosions = {}

function GameState:schedule_explosion(target)
    local t_body = target:get('Physical').body
    local x, y = t_body:getPosition()
    local angle = t_body:getAngle()
    local vx, vy = t_body:getLinearVelocity()
    local vr = t_body:getAngularVelocity()

    scheduled_explosions[#scheduled_explosions+1] =
        { x = x, y = y, angle = angle, vx = vx, vy = vy, vr = vr }
end

function GameState:spawn_explosions()
    for i, exp_conf in pairs(scheduled_explosions) do
        local explosion = lt.Entity()
        local body = love.physics.newBody(self.world, exp_conf.x, exp_conf.y, "dynamic")
        body:setAngle(exp_conf.angle)
        body:setLinearVelocity(exp_conf.vx, exp_conf.vy)
        body:setAngularVelocity(exp_conf.vr)
        body:setAngularDamping(0.0)
        body:setLinearDamping(0.0)
        body:setMass(0)
        local shape = love.physics.newCircleShape(0)
        local fixture = love.physics.newFixture(body, shape, 0)
        fixture:setSensor(true)
        fixture:setRestitution(0.0)
        fixture:setUserData(explosion)

        explosion:add(Physical(body, fixture, shape))
        explosion:add(Health(1))
        local images = {resources.images.explosion_1, resources.images.explosion_2, resources.images.explosion_3, resources.images.explosion_4, resources.images.explosion_5}
        explosion:add(Animation(images, 5))

        self.engine:addEntity(explosion)
    end
    scheduled_explosions = {}
end

function GameState:shoot_bullet(start_pos, dir, speed, enemy_mothership, damage)
    bullet = lt.Entity()

    local body = love.physics.newBody(self.world, start_pos.x, start_pos.y, "dynamic")
    body:setLinearDamping(0.0)
    body:setMass(0)
    body:setLinearVelocity(dir.x*speed, dir.y*speed)
    body:setAngle(dir:getRadian())
    local shape = love.physics.newCircleShape(5)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.0)
    fixture:setUserData(bullet)

    local particlesystem = love.graphics.newParticleSystem(resources.images.block_particle, 32)
    particlesystem:setParticleLifetime(2, 50) -- Particles live at least 2s and at most 5s.
    particlesystem:setEmissionRate(50)
    particlesystem:setSizeVariation(1)
    particlesystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
    particlesystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
    -- bullet:add(Particles(particlesystem))

    bullet:add(Bullet(damage))
    bullet:add(Physical(body, fixture, shape))
    bullet:add(HasEnemy(enemy_mothership))
    bullet:add(Drawable(resources.images.fighter_missile))
    bullet:add(Health(1))

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

    enemy_mothership = bullet:get('HasEnemy').enemy_mothership

    local evmgr = stack:current().eventmanager
    if object == enemy_mothership then
        evmgr:fireEvent(BulletHitMothership(bullet, object))
    elseif object:has('SwarmMember') then
        -- object is a swarmmember
        object_mothership = object:get('SwarmMember').mothership
        if enemy_mothership == object_mothership then
            evmgr:fireEvent(BulletHitDrone(bullet, object))
        end
    end
end

function GameState:delete_entity(entity)
    self.engine:removeEntity(entity)
    if entity:has("Physical") then
        entity:get("Physical").body:destroy()
    end
end

function GameState:load()
    self.engine = lt.Engine()
    self.world = love.physics.newWorld(0, 0, false)
    self.world:setCallbacks(beginContact)
    self.eventmanager = lt.EventManager()

    self.bg_pos100 = 0
    self.bg_pos80 = 0
    self.bg_pos60 = 0

    local particlesSystem = ParticlesSystem()
    local laserSystem = LaserSystem()

    -- add systems to engine
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(PlayerControlSystem())
    self.engine:addSystem(SwarmSystem())
    self.engine:addSystem(AttackSystem(self))
    self.engine:addSystem(BulletRemoverSystem(self))
    self.engine:addSystem(particlesSystem, 'update')
    self.engine:addSystem(particlesSystem, 'draw')
    self.engine:addSystem(MothershipSystem())
    self.engine:addSystem(AnimatedDrawSystem())
    self.engine:addSystem(laserSystem, 'update')
    self.engine:addSystem(laserSystem, 'draw')

    -- keep these two at the end
    self.engine:addSystem(DeathSystem())
    self.engine:addSystem(GameOverSystem())

    -- add eventbased systems to eventhandler
    self.bullet_hit_system = BulletHitSystem(self)
    self.eventmanager:addListener("BulletHitDrone",
        self.bullet_hit_system, self.bullet_hit_system.drone_hit)
    self.eventmanager:addListener("BulletHitMothership",
        self.bullet_hit_system, self.bullet_hit_system.mothership_hit)

    player = lt.Entity()
    enemy = lt.Entity()

    player = self:create_mothership(player, 100, 100, enemy)
    enemy = self:create_mothership(enemy, 430, 380, player)

    self.engine:addEntity(player)
    self.engine:addEntity(enemy)

    self:spawn_swarm(player, enemy)
    self:spawn_swarm(enemy, player)
end

function GameState:update(dt)
    self.bg_pos100 = self.bg_pos100 - 1
    if self.bg_pos100 <= -resources.images.stars_bg:getWidth() then
        self.bg_pos100 = 0
    end
    self.bg_pos80 = self.bg_pos80 - 2
    if self.bg_pos80 <= -resources.images.stars_90:getWidth() then
        self.bg_pos80 = 0
    end
    self.bg_pos60 = self.bg_pos60 - 3
    if self.bg_pos60 <= -resources.images.stars_180:getWidth() then
        self.bg_pos60 = 0
    end
    self.engine:update(dt)
    self.world:update(dt)

    self:spawn_explosions()
end

function GameState:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(resources.images.stars_bg, self.bg_pos100, 0)
    love.graphics.draw(resources.images.stars_bg, self.bg_pos100 + resources.images.stars_bg:getWidth(), 0)
    love.graphics.setColor(255, 255, 255, 204)
    love.graphics.draw(resources.images.stars_90, self.bg_pos80, 0)
    love.graphics.draw(resources.images.stars_90, self.bg_pos80 + resources.images.stars_90:getWidth(), 0)
    love.graphics.setColor(255, 255, 255, 153)
    love.graphics.draw(resources.images.stars_180, self.bg_pos60, 0)
    love.graphics.draw(resources.images.stars_180, self.bg_pos60 + resources.images.stars_180:getWidth(), 0)
    love.graphics.setColor(255, 255, 255, 255)
    self.engine:draw()
end

function GameState:keypressed(key)
end

return GameState
