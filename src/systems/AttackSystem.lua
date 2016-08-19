local AttackSystem = class("AttackSystem", System)

local LaserBeam = Component.load({'LaserBeam'})

function AttackSystem:initialize(gamestate)
    System.initialize(self)
    self.gamestate = gamestate
end

function AttackSystem:update(dt)
    for k, entity in pairs(self.targets) do
        enemy_mothership = entity:get('HasEnemy').enemy_mothership
        enemy_x, enemy_y = enemy_mothership:get('Physical').body:getPosition()
        enemy_vector = Vector(enemy_x, enemy_y)

        local weapon = entity:get('Weapon')
        local body = entity:get('Physical').body

        member_x, member_y = body:getPosition()
        member_vector = Vector(member_x, member_y)
        relative = enemy_vector - member_vector
        direction = relative:normalize()
        dir_rad = direction:getRadian()

        local distance = member_vector:distanceTo(enemy_vector)

        local final_rad = dir_rad
        local rand_rad = 0
        if math.random() > weapon.hitChance then
            -- range in degrees
            local offRange = weapon.sprayAngle
            local rand_off = offRange * (love.math.random() - .5)
            rand_rad = math.rad(rand_off)
            final_rad = dir_rad + rand_rad
        end

        rad_angle = body:getAngle()
        view_dir = Vector.from_radians(rad_angle)

        shoot_angle = view_dir:dot(direction)

        weapon.since_last_fired = weapon.since_last_fired + dt

        if shoot_angle > 0.95 and weapon.since_last_fired > weapon.cooldown and distance <= weapon.range then
            weapon.since_last_fired = 0
            if weapon.type == 'laser' then
                local beam = Entity()
                local target = enemy_vector:subtract(member_vector):rotate(rand_rad):add(member_vector)
                beam:add(LaserBeam(member_vector, target))
                stack:current().engine:addEntity(beam)
                stack:current().eventmanager:fireEvent(BulletHitMothership(nil, enemy_mothership, weapon.damage))
                resources.sounds.laserShot:setVolume(0.05)
                resources.sounds.laserShot:clone():play()
            elseif weapon.type == 'missile' then
                self.gamestate:shoot_bullet(
                    member_vector, Vector.from_radians(final_rad), 200, enemy_mothership, weapon.damage)
                resources.sounds.rocketLaunch:setVolume(0.1)
                resources.sounds.rocketLaunch:clone():play()
            end
        end

    end
end

function AttackSystem:requires()
    return {"HasEnemy", "Physical", "Weapon"}
end

return AttackSystem
