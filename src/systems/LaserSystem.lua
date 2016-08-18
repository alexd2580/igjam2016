local LaserSystem = class('LaserSystem', System)

function LaserSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local beam = entity:get('LaserBeam')
        beam.opacity = beam.opacity - (dt*5)
        if beam.opacity <= 0 then
            stack:current().engine:removeEntity(entity)
        end
    end
end

function LaserSystem:draw()
    love.graphics.setBlendMode('add')
    for _, entity in pairs(self.targets) do
        local beam = entity:get('LaserBeam')
        love.graphics.setColor(78, 99, 207, beam.opacity * 255)
        local ox, oy = beam.origin:unpack()
        local tx, ty = beam.target:unpack()
        love.graphics.line(ox, oy, tx, ty)
    end
    love.graphics.setBlendMode('alpha')
end

function LaserSystem:requires()
    return {'LaserBeam'}
end

return LaserSystem
