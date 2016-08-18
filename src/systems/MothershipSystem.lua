local MothershipSystem = class("MothershipSystem", System)

function MothershipSystem:update()
    for index, entity in pairs(self.targets) do
        --enemy_mothership = entity:get("HasEnemy").enemy_mothership
        --enemy_x, enemy_y = enemy_mothership:get("Physical").body:getPosition()
        --enemy_pos = Vector(enemy_x, enemy_y)

        --body = entity:get('Physical').body
        --member_x, member_y = body:getPosition()
        --member_pos = Vector(member_x, member_y)
        --relative = enemy_pos - member_pos
        --direction_rad = relative:getRadian()

        --body:setAngle(direction_rad)
    end
end

function MothershipSystem:requires()
    return {"Mothership", "Physical", "HasEnemy"}
end

return MothershipSystem
