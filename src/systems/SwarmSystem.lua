local SwarmSystem = class("SwarmSystem", System)

function SwarmSystem:update()
    for k, entity in pairs(self.targets) do
        --player_x, player_y = player:get('Physical').body:getPosition()
        --player_vector = Vector(player_x, player_y)
        local mother_x, mother_y = entity:get('SwarmMember').mothership:get('Physical').body:getPosition()
        local mother_vector = Vector(mother_x, mother_y)

        local body = entity:get('Physical').body
        local member_x, member_y = body:getPosition()
        local member_vector = Vector(member_x, member_y)
        local relative = mother_vector - member_vector
        local direction = relative:normalize()

        local force_factor = 2000
        if relative:length() < 50 then
            body:applyForce(direction.x * -force_factor, direction.y * -force_factor)
        elseif relative:length() > 150 then
            body:applyForce(direction.x * force_factor, direction.y * force_factor)
        end

        local rotation_force_factor = 200
        local direction_rotated = direction:rotate(math.rad(90))
        body:applyForce(direction_rotated.x * rotation_force_factor,
                        direction_rotated.y * rotation_force_factor,
                        member_x, member_y)
    end
end

function SwarmSystem:requires()
    return {"SwarmMember", "Physical"}
end

return SwarmSystem
