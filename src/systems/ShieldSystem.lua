local ShieldSystem = class('ShieldSystem', System)

function ShieldSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local shield = entity:get('Shield')
        shield.charge = math.min(shield.capacity, shield.charge + dt*shield.rechargeSpeed)
    end
end

function ShieldSystem:draw()

end

function ShieldSystem:requires()
    return {'Shield'}
end

return ShieldSystem
