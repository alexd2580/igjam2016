
local PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem:update()
    physical = player:get('Physical')

    local force_factor = 1000
    if love.keyboard.isDown("a") then
        physical.body:applyForce(-1 * force_factor, 0)
    end
    if love.keyboard.isDown("d") then
        physical.body:applyForce(1 * force_factor, 0)
    end
    if love.keyboard.isDown("w") then
        physical.body:applyForce(0, -1 * force_factor)
    end
    if love.keyboard.isDown("s") then
        physical.body:applyForce(0, 1 * force_factor)
    end
end

function PlayerControlSystem:requires()
    return {}
end

return PlayerControlSystem
