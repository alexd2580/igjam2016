local AttackSystem = class("AttackSystem", System)

function AttackSystem:initialize(gamestate)
    self.gamestate = gamestate
end


function AttackSystem:update()
    for k, entity in pairs(self.targets) do
        --player_x, player_y = player:get('Physical').body:getPosition()
        --player_vector = Vector(player_x, player_y)
        enemy_mothership = entity:get('HasEnemy').enemy_mothership
        enemy_x, enemy_y = enemy_mothership:get('Physical').body:getPosition()
        enemy_vector = Vector(mother_x, mother_y)

        body = entity:get('Physical').body
        member_x, member_y = body:getPosition()
        member_vector = Vector(member_x, member_y)
        relative = enemy_vector - member_vector
        direction = relative:normalize()

        rad_angle = body:getAngle()
        view_dir = Vector.from_radians(rad_angle)

        shoot_angle = view_dir:dot(direction)

        if shoot_angle > 0.9 then
            gamestate:shoot_bullet(member_vector, view_dir, 10, enemy_mothership)
        end
    end
end

function AttackSystem:requires()
    return {"HasEnemy", "Physical"}
end

return AttackSystem
