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
    end
end

function ShieldSystem:draw()

end

function ShieldSystem:requires()
    return {'Shield'}
end

return ShieldSystem
