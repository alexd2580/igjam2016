local DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    for index, entity in pairs(self.targets) do
        local drawable = entity:get("Drawable")
        local image = drawable.image
        local physical = entity:get('Physical')
        local entity_x, entity_y = physical.body:getPosition()
        local angle = physical.body:getAngle()
        love.graphics.draw(image,
                           entity_x,
                           entity_y,
                           angle + math.pi / 2, 1, 1,
                           image:getWidth() / 2,
                           image:getHeight() / 2)

        if debug then
            love.graphics.circle("fill", entity_x, entity_y, physical.shape:getRadius(), 100)
        end

        if entity.psystem then
            love.graphics.draw(entity.psystem, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
        end

        --dir = Vector.from_radians(angle)
        --love.graphics.setColor(255,255,255,255)
        --love.graphics.circle("fill", entity_x+20*dir.x, entity_y+20*dir.y, 5, 100)
    end
end

function DrawSystem:requires()
    return {"Drawable", "Physical"}
end

return DrawSystem
