local DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    love.graphics.setColor(0, 255, 0, 50)
    for index, entity in pairs(self.targets) do
        drawable = entity:get("Drawable")
        love.graphics.circle("fill", drawable.ox, drawable.oy, drawable.r, 100)
    end
end

function DrawSystem:requires()
    return {"Drawable"}
end

return DrawSystem
