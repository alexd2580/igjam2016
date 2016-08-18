local DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    for index, entity in pairs(self.targets) do
        drawable = entity:get("Drawable")

        local physical = entity:get('Physical')
        entity_x, entity_y = physical.body:getPosition()
        angle = physical.body:getAngle()
        love.graphics.draw(drawable.image, entity_x, entity_y, angle)

        --dir = Vector.from_radians(angle)
        --love.graphics.setColor(255,255,255,255)
        --love.graphics.circle("fill", entity_x+20*dir.x, entity_y+20*dir.y, 5, 100)
    end
end

function DrawSystem:requires()
    return {"Drawable", "Physical"}
end

return DrawSystem
