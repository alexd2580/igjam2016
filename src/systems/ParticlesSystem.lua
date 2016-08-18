local ParticlesSystem = class("ParticlesSystem", System)

function ParticlesSystem:draw()
    for index, entity in pairs(self.targets) do
        local particlesystem = entity:get('Particles').particlesystem
        love.graphics.draw(particlesystem)
    end
end

function ParticlesSystem:update(dt)
    for index, entity in pairs(self.targets) do
        local physical = entity:get('Physical')
        local entity_x, entity_y = physical.body:getPosition()
        local particles = entity:get('Particles')
        local particlesystem = entity:get('Particles').particlesystem
        particlesystem:setPosition(entity_x, entity_y)
        particlesystem:update(dt)
    end
end

function ParticlesSystem:requires()
    return {"Particles", "Physical"}
end

return ParticlesSystem
