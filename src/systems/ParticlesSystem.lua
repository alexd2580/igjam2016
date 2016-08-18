local ParticlesSystem = class("ParticlesSystem", System)

function ParticlesSystem:draw()
    for index, entity in pairs(self.targets) do
        local physical = entity:get('Physical')
        local particlesystem = entity:get('Particles').particlesystem
        local entity_x, entity_y = physical.body:getPosition()
        local angle = physical.body:getAngle()
        love.graphics.draw(particlesystem, entity_x, entity_y)
    end
end

function ParticlesSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local physical = entity:get('Physical')
        local particlesystem = entity:get('Particles').particlesystem
        particlesystem:update(dt)
    end
end

function ParticlesSystem:requires()
    return {"Particles", "Physical"}
end

return ParticlesSystem
