local SwarmSystem = class("SwarmSystem", System)

function SwarmSystem:update()
    for k, entity in pairs(self.targets) do
        --player_x, player_y = player:get('Physical').body:getPosition()
        --player_vector = Vector(player_x, player_y)
        mother_x, mother_y = entity:get('SwarmMember').mothership:get('Physical').body:getPosition()
        mother_vector = Vector(mother_x, mother_y)

        body = entity:get('Physical').body
        member_x, member_y = body:getPosition()
        member_vector = Vector(member_x, member_y)
        relative = mother_vector - member_vector
        direction = relative:normalize()

        local force_factor = 2000
        if relative:length() < 100 then
            body:applyForce(direction.x * -force_factor, direction.y * -force_factor)
        else
            body:applyForce(direction.x * force_factor, direction.y * force_factor)
        end
    end
end

function SwarmSystem:requires()
    return {"SwarmMember", "Physical"}
end

return SwarmSystem
