local DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    for index, entity in pairs(stack:current().engine.entities) do
        local images, maxIndex
        if (entity:has('Drawable') or entity:has('LayeredDrawable')) and
            (entity:has('Physical') or entity:has('Transformable')) then
            if entity:has('Drawable') then
                images = {entity:get('Drawable').image}
                maxIndex = 1
            elseif entity:has("LayeredDrawable") then
                images = entity:get("LayeredDrawable").layers
                maxIndex = entity:get("LayeredDrawable").maxIndex
            end

            local entity_x, entity_y, angle, sx, sy
            if entity:has('Physical') then
                local physical = entity:get('Physical')
                angle = physical.body:getAngle()
                entity_x, entity_y = physical.body:getPosition()
            elseif entity:has('Transformable') then
                angle = -math.pi/2
                entity_x, entity_y = entity:get('Transformable').position:unpack()
                sx, sy = entity:get('Transformable').scale:unpack()
            end

            for i = 1, maxIndex, 1 do
                if images[i] then
                    love.graphics.draw(images[i],
                                       entity_x,
                                       entity_y,
                                       angle + math.pi / 2,
                                       sx or 1, sy or 1,
                                       images[i]:getWidth() / 2,
                                       images[i]:getHeight() / 2)
               end
            end

            if debug then
                if entity:has('Physical') then
                    local physical = entity:get('Physical')
                    love.graphics.circle("fill", entity_x, entity_y, physical.shape:getRadius(), 100)
                end
            end

            if entity.psystem then
                love.graphics.draw(entity.psystem, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
            end

            --dir = Vector.from_radians(angle)
            --love.graphics.setColor(255,255,255,255)
            --love.graphics.circle("fill", entity_x+20*dir.x, entity_y+20*dir.y, 5, 100)
        end
    end
end

function DrawSystem:requires()
    return {}
end

return DrawSystem
