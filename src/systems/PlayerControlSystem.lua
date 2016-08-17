
local PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem:update()
    drawable = player:get("Drawable")

    if love.keyboard.isDown("a") then
        drawable.ox = drawable.ox - 10
    end
    if love.keyboard.isDown("d") then
        drawable.ox = drawable.ox + 10
    end
    if love.keyboard.isDown("w") then
        drawable.oy = drawable.oy - 10
    end
    if love.keyboard.isDown("s") then
        drawable.oy = drawable.oy + 10
    end
end

function PlayerControlSystem:requires()
    return {}
end

return PlayerControlSystem
