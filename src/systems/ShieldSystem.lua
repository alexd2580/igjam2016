local ShieldSystem = class('ShieldSystem', System)

function ShieldSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local shield = entity:get('Shield')
        shield.rechargeTimer = shield.rechargeTimer + dt
        if shield.charge <= 0 then
            shield.rechargeTimer = 0
            shield.takedownTimer = shield.takedownTimer + dt
            if shield.takedownTimer >= shield.takedownCooldown then
                shield.charge = shield.charge + shield.rechargeStep
                shield.takedownTimer = 0
            end
        end
        if shield.rechargeTimer >= shield.rechargeCooldown then
            shield.charge = math.min(shield.capacity, shield.charge + shield.rechargeStep)
            shield.rechargeTimer = 0
        end
        if shield.hitTimer > 0 then
            shield.hitTimer = shield.hitTimer - dt
        end
    end
end

function ShieldSystem:draw()
    for _, entity in pairs(self.targets) do
        local shield = entity:get('Shield')
        local x, y = entity:get('Physical').body:getPosition()

        if shield.hitTimer > 0 then
            local img = resources.images.shield_hit
            love.graphics.setColor(255, 255, 255, 255 * shield.hitTimer * 2)
            love.graphics.draw(img, x, y, 0, 1, 1, img:getWidth()/2, img:getHeight()/2)
        end

        love.graphics.setColor(255, 255, 255, 200 * (shield.charge/shield.capacity))
        local img = resources.images.shield_aura
        love.graphics.draw(img, x, y, 0, 1, 1, img:getWidth()/2, img:getHeight()/2)
    end
end

function ShieldSystem:requires()
    return {'Shield'}
end

return ShieldSystem
