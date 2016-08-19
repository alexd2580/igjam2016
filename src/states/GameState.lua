local GameState = class('GameState', State)

-- Events
require("events/BulletHitDrone")
require("events/BulletHitMothership")
require("events/DroneDead")
require("events/DroneHitEnemy")

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
PulseSystem = require("systems/PulseSystem")
LaserSystem = require('systems/LaserSystem')
DroneHitSystem = require('systems/DroneHitSystem')

local Drawable, Physical, SwarmMember, HasEnemy, Weapon, Bullet, Health, Particles, Mothership, Animation, LayeredDrawable, HitIndicator, Pulse
    = Component.load({'Drawable', 'Physical', 'SwarmMember', 'HasEnemy', 'Weapon', 'Bullet', 'Health', 'Particles', 'Mothership', 'Animation', 'LayeredDrawable', 'HitIndicator', 'Pulse'})

function GameState:initialize(level, enabledItems)
    self.level = level
    self.enabledItems = enabledItems
	shake_offset = 0
	self.shake_magnitude = 1
	shake_duration = 0
end

function GameState:create_mothership(mothership, x, y, enemy)
    local drawable = LayeredDrawable()
	if mothership == player then
		drawable:setLayer(1, resources.images.mask_base)
	else
		drawable:setLayer(1, resources.images.enemy100)
	end
    for layer, id in pairs(self.enabledItems) do
        drawable:setLayer(layer, items[id].image)
    end
    mothership:add(drawable)

    local body = love.physics.newBody(self.world, x, y, "dynamic")
    body:setLinearDamping(0.999)
    local shape = love.physics.newCircleShape(14)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.9)
    fixture:setUserData(mothership)
    body:setAngle(-math.pi / 2)
    body:setMass(6)

    mothership:add(Health(1000))
    mothership:add(Mothership())
    mothership:add(HasEnemy(enemy))
    mothership:add(Physical(body, fixture, shape))
    mothership:add(HitIndicator())
    return mothership
end

function GameState:spawn_swarm(mothership, enemy_mothership)
    local swarm_size = 60
    for i = 1, swarm_size, 1 do
        drone = lt.Entity()

        base_x, base_y = mothership:get('Physical').body:getPosition()

        local x, y = base_x + love.math.random(-50, 50), base_y + love.math.random(-50, 50)
        local body = love.physics.newBody(self.world, x, y, "dynamic")
        body:setAngle(0)
        body:setAngularDamping(0.8)
        body:setLinearDamping(0.6)
        local shape = love.physics.newCircleShape(4)
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
		if mothership == player then
			drone:add(Drawable(resources.images.fighter))
		else
			drone:add(Drawable(resources.images.fighterEnemy))
		end
        drone:add(Health(100))
        drone:add(HitIndicator())
        self.engine:addEntity(drone)
    end
end

function GameState:spawn_drone_explosion(event)
    local explosion = lt.Entity()
    local body = love.physics.newBody(self.world, event.x, event.y, "dynamic")
    body:setAngle(event.angle)
    body:setLinearVelocity(event.vx, event.vy)
    body:setAngularVelocity(event.vr)
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
    explosion:add(Animation(images, 5, false))

    self.engine:addEntity(explosion)
end

function GameState:shoot_bullet(start_pos, dir, speed, enemy_mothership, damage)
    bullet = lt.Entity()

    local body = love.physics.newBody(self.world, start_pos.x, start_pos.y, "dynamic")
    body:setLinearDamping(0.0)
    body:setMass(0)
    body:setLinearVelocity(dir.x*speed, dir.y*speed)
    body:setAngle(dir:getRadian())
    local shape = love.physics.newCircleShape(3)
    local fixture = love.physics.newFixture(body, shape, 1)
    fixture:setSensor(true)
    fixture:setRestitution(0.0)
    fixture:setUserData(bullet)

    local particlesystem = love.graphics.newParticleSystem(resources.images.block_particle, 32)
    particlesystem:setParticleLifetime(0.1)
    particlesystem:setEmissionRate(64)
    particlesystem:setSizes(0.5, 0.1)
    particlesystem:setColors(255, 0, 10, 255, 255, 10, 10, 100)
    bullet:add(Particles(particlesystem))

    bullet:add(Bullet(damage))
    bullet:add(Physical(body, fixture, shape))
    bullet:add(HasEnemy(enemy_mothership))
    bullet:add(Drawable(resources.images.fighter_missile))
    bullet:add(Health(1))
    bullet:add(Pulse(0.2))

    self.engine:addEntity(bullet)

    -- love.audio.play(resource.music.laserShot)
end

function is_a_bullet_hit(a, b)
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

function is_a_drone_hit(a, b)
    if not a:has('SwarmMember') then
        return false
    end
    if b:has('SwarmMember') then
        return true
    end
    if b:has('Mothership') then
        return true
    end
    return false
end

function check_enemity(a, b)
    enemy_mothership = a:get('HasEnemy').enemy_mothership
    if b == enemy_mothership then
        return "mothership"
    elseif b:has('SwarmMember') then
        b_mothership = b:get('SwarmMember').mothership
        if enemy_mothership == b_mothership then
            return "drone"
        end
    end
    return false
end

function bullet_hit_object(bullet, object)
    local is_enemy = check_enemity(bullet, object)
    if not is_enemy then return end
    local evmgr = stack:current().eventmanager
    if is_enemy == "mothership" then
        evmgr:fireEvent(BulletHitMothership(bullet, object))
    end
    if is_enemy == "drone" then
        evmgr:fireEvent(BulletHitDrone(bullet, object))
    end
end

function drone_hit_object(drone, object)
    local is_enemy = check_enemity(drone, object)
    if is_enemy then
        local evmgr = stack:current().eventmanager
        evmgr:fireEvent(DroneHitEnemy(drone, object, is_enemy))
    end
end

function beginContact(a, b, coll)
    if stack:current().eventmanager == nil then
        print('Ignoring collision')
        return false
    end

    a = a:getUserData()
    b = b:getUserData()

    local bullet, object = nil, nil
    if is_a_bullet_hit(a, b) then
        bullet_hit_object(a, b)
    elseif is_a_bullet_hit(b, a) then
        bullet_hit_object(b, a)
    elseif is_a_drone_hit(a, b) then
        drone_hit_object(a, b)
    elseif is_a_drone_hit(b, a) then
        drone_hit_object(b, a)
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
    self.engine:addSystem(PulseSystem())

    -- add eventbased systems to eventhandler
    self.bullet_hit_system = BulletHitSystem(self)
    self.eventmanager:addListener("BulletHitDrone",
        self.bullet_hit_system, self.bullet_hit_system.drone_hit)
    self.eventmanager:addListener("BulletHitMothership",
        self.bullet_hit_system, self.bullet_hit_system.mothership_hit)

    self.drone_hit_system = DroneHitSystem(self)
    self.eventmanager:addListener("DroneHitEnemy",
        self.drone_hit_system, self.drone_hit_system.drone_hit_enemy)

    -- add callback to spawn explosion
    self.eventmanager:addListener("DroneDead", self, self.spawn_drone_explosion)

    player = lt.Entity()
    enemy = lt.Entity()

    player = self:create_mothership(player, 100, 100, enemy)
    enemy = self:create_mothership(enemy, 430, 380, player)

    self.engine:addEntity(player)
    self.engine:addEntity(enemy)

    self:spawn_swarm(player, enemy)
    self:spawn_swarm(enemy, player)
end

local event_queue = {}

function GameState:enqueue_event(event)
    event_queue[#event_queue+1] = event
end

function GameState:handle_events()
    for _,event in pairs(event_queue) do
        self.eventmanager:fireEvent(event)
    end
    event_queue = {}
end

function GameState:update(dt)
    self.bg_pos100 = self.bg_pos100 - 3
    if self.bg_pos100 <= -resources.images.stars_bg:getWidth() then
        self.bg_pos100 = 0
    end
    self.bg_pos80 = self.bg_pos80 - 2
    if self.bg_pos80 <= -resources.images.stars_90:getWidth() then
        self.bg_pos80 = 0
    end
    self.bg_pos60 = self.bg_pos60 - 1
    if self.bg_pos60 <= -resources.images.stars_180:getWidth() then
        self.bg_pos60 = 0
    end
    self.engine:update(dt)
    self.world:update(dt)
    self:handle_events()
    if shake_offset < shake_duration then
        shake_offset = shake_offset + dt
    end
end

function GameState:draw()
	if shake_offset < shake_duration then
        local dx = love.math.random(-self.shake_magnitude, self.shake_magnitude)
        local dy = love.math.random(-self.shake_magnitude, self.shake_magnitude)
        love.graphics.translate(dx, dy)
    end
    love.graphics.setColor(255, 255, 255, 153)
    love.graphics.draw(resources.images.stars_180, self.bg_pos60, 0)
    love.graphics.draw(resources.images.stars_180, self.bg_pos60 + resources.images.stars_180:getWidth(), 0)
    love.graphics.setColor(255, 255, 255, 204)
    love.graphics.draw(resources.images.stars_90, self.bg_pos80, 0)
    love.graphics.draw(resources.images.stars_90, self.bg_pos80 + resources.images.stars_90:getWidth(), 0)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(resources.images.stars_bg, self.bg_pos100, 0)
    love.graphics.draw(resources.images.stars_bg, self.bg_pos100 + resources.images.stars_bg:getWidth(), 0)
    self.engine:draw()
end

function GameState:keypressed(key)
end

return GameState
