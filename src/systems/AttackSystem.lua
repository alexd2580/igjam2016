local AttackSystem = class("AttackSystem", System)

function AttackSystem:initialize(gamestate)
    System.initialize(self)
    self.gamestate = gamestate
end


function AttackSystem:update(dt)
    for k, entity in pairs(self.targets) do
        --player_x, player_y = player:get('Physical').body:getPosition()
        --player_vector = Vector(player_x, player_y)
        enemy_mothership = entity:get('HasEnemy').enemy_mothership
        enemy_x, enemy_y = enemy_mothership:get('Physical').body:getPosition()
        enemy_vector = Vector(enemy_x, enemy_y)

        body = entity:get('Physical').body
        member_x, member_y = body:getPosition()
        member_vector = Vector(member_x, member_y)
        relative = enemy_vector - member_vector
        direction = relative:normalize()

        rad_angle = body:getAngle()
        view_dir = Vector.from_radians(rad_angle)

        shoot_angle = view_dir:dot(direction)

        weapon = entity:get('HasWeapon')
        weapon.since_last_fired = weapon.since_last_fired + dt

        if shoot_angle > 0.95 and weapon.since_last_fired > weapon.cooldown then

            weapon.since_last_fired = 0
            self.gamestate:shoot_bullet(member_vector, view_dir, 100, enemy_mothership)
        end

    end
end

function AttackSystem:requires()
    return {"HasEnemy", "Physical", "HasWeapon"}
end

return AttackSystem
