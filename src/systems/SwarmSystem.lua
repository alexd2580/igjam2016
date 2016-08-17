local SwarmSystem = class("SwarmSystem", System)

function SwarmSystem:update()
    for k, entity in pairs(self.targets) do
        player_x, player_y = player:get('Physical').body:getPosition()
        player_vector = Vector(player_x, player_y)
        member_x, member_y = entity:get('Physical').body:getPosition()
        member_vector = Vector(member_x, member_y)
        relative = player_vector:subtract(member_vector)
        direction = relative:normalize()

        entity_body = entity:get('Physical').body
        local force_factor = 2000
        if relative:length() < 100 then
            entity_body:applyForce(direction.x * -force_factor, direction.y * -force_factor)
        else
            entity_body:applyForce(direction.x * force_factor, direction.y * force_factor)
        end
    end
end

function SwarmSystem:requires()
    return {"SwarmMember", "Physical"}
end

return SwarmSystem
