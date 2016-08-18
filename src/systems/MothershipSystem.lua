local MothershipSystem = class("MothershipSystem", System)

function MothershipSystem:update()
    for index, entity in pairs(self.targets) do
        --enemy_mothership = entity:get("HasEnemy").enemy_mothership
        --enemy_x, enemy_y = enemy_mothership:get("Physical").body:getPosition()
        --enemy_pos = Vector(enemy_x, enemy_y)

        local body = entity:get('Physical').body
        local x, y = body:getPosition()
        --local window_w, window_h,_ = love.window:getMode()
        local window_w, window_h = 512, 448
        local vel_x, vel_y = body:getLinearVelocity()
        local imp_x, imp_y = 0,0

        local hard_margin = 20
        local soft_margin = 60

        if x < hard_margin then x = hard_margin end
        if x > window_w - hard_margin then x = window_w - hard_margin end
        if y < hard_margin then y = hard_margin end
        if y > window_h - hard_margin then y = window_h - hard_margin end

        --if x < soft_margin then
--            if vel_x < 0 then imp_x = 150-2.5*x/100 end
--        end

        --elseif member_x > window_w - margin then
    --        vel_x = math.min(0, vel_y)
    --    end

        body:setPosition(x, y)
--        print(imp_x, vel_x)
--        body:applyLinearImpulse(-imp_x*vel_x, -imp_y*vel_y)


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
