local AISystem = class("AISystem", System)

function AISystem:update(dt)
    for _, entity in pairs(self.targets) do
        local ai = entity:get('MothershipAI')
        local state = ai.state
        local func = ai.func
        local body = entity:get('Physical').body
        local x,y = body:getPosition()
        local vx, vy = body:getLinearVelocity()

        local enemy = entity:get('HasEnemy').enemy_mothership:get('Physical').body
        local ex,ey = enemy:getPosition()
        local evx, evy = enemy:getLinearVelocity()

        ai.state, force = func(state, Vector(x, y), Vector(vx, vy), Vector(ex, ey), Vector(evx, evy))
        body:applyForce(1000 * force.x, 1000 * force.y)
    end
end

function AISystem:requires()
    return {'MothershipAI'}
end

return AISystem
