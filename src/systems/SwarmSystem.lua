local SwarmSystem = class("SwarmSystem", System)

function SwarmSystem:update()
    for k, entity in pairs(self.targets) do
        player_x, player_y = player:get('Physical').body:getPosition()
        player_vector = Vector(player_x, player_y)
        member_x, member_y = entity:get('SwarmMember').body:getPosition()
        member_vector = Vector(member_x, member_y)
    end
end

function SwarmSystem:requires()
    return {"SwarmMember", "Physical"}
end

return SwarmSystem
