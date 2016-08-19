local GameOverSystem = class('GameOverSystem', System)

local GameOverState = require('states/GameOverState')

local Physical, Health, Animation = Component.load({'Physical', 'Health', 'Animation'})

function GameOverSystem:initialize()
    System.initialize(self)
    self.cooling_down = false
    self.time = 0
    self.next_level = nil
end

function GameOverSystem:game_over()
    self.cooling_down = true
    stack:current().engine:toggleSystem("PlayerControlSystem")
    stack:current().engine:toggleSystem("SwarmSystem")
    stack:current().engine:toggleSystem("AttackSystem")
    stack:current().engine:toggleSystem("BulletRemoverSystem")
    stack:current().engine:toggleSystem("MothershipSystem")
    stack:current().engine:toggleSystem("LaserSystem")
    stack:current().engine:toggleSystem("AISystem")
end

function GameOverSystem:spawn_end_explosion(entity)
    local explosion = lt.Entity()
    local x, y = entity:get('Physical').body:getPosition()
    local body = love.physics.newBody(stack:current().world, x, y, "dynamic")
    local shape = love.physics.newCircleShape(0)
    local fixture = love.physics.newFixture(body, shape, 0)
    fixture:setSensor(true)
    fixture:setUserData(explosion)
    explosion:add(Physical(body, fixture, shape))
    explosion:add(Health(1))
    local images = {
        resources.images.explosion_big1,
        resources.images.explosion_big2,
        resources.images.explosion_big3,
        resources.images.explosion_big4,
        resources.images.explosion_big5}
    explosion:add(Animation(images, 30, false))

    stack:current().engine:addEntity(explosion)
end

function GameOverSystem:update(dt)
    if not self.cooling_down then
        if player:get("Health").points <= 0 then
            self:game_over()
            self.next_level = stack:current().level
            self.won = false
            self:spawn_end_explosion(player)
        elseif enemy:get("Health").points <= 0 then
            self:game_over()
            self.next_level = stack:current().level + 1
            self.won = true
            self:spawn_end_explosion(enemy)
        end
    else
        if self.time > 2.8 then
            stack:pop()
            stack:pop()
            stack:current():loadLevel(self.next_level)
            stack:push(GameOverState(self.won))
        end
        self.time = self.time + dt
    end
end

return GameOverSystem
