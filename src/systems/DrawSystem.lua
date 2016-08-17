local DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    for index, entity in pairs(self.targets) do
        drawable = entity:get("Drawable")
        love.graphics.setColor(unpack(drawable.color))
        entity_x, entity_y = entity:get('Physical').body:getPosition()
        radius = entity:get('Physical').shape:getRadius()
        love.graphics.circle("fill", entity_x, entity_y, radius, 100)
    end
end

function DrawSystem:requires()
    return {"Drawable", "Physical"}
end

return DrawSystem
