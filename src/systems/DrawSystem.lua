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
            if entity:has('Pulse') then
                local pulse = entity:get('Pulse')
                local blink = math.sin(pulse.time_since_last_pulse) * 10000
                love.graphics.setColor(blink, blink, blink, 255)
            end
            if entity:has('Mothership') and entity:has('Health') then
                local drawable = entity:get('LayeredDrawable')
                local health = entity:get('Health')
				if health.points < 100 and health.points >= 80 then
					drawable:setLayer(2, resources.images.enemy80)
				elseif health.points < 80 and health.points >= 60 then
					drawable:setLayer(2, resources.images.enemy60)
				elseif health.points < 60 and health.points >= 40 then
					drawable:setLayer(2, resources.images.enemy40)
				elseif health.points < 40 and health.points >= 20 then
					drawable:setLayer(2, resources.images.enemy20)
				elseif health.points < 20 and health.points >= 0 then
					drawable:setLayer(2, resources.images.enemy00)
				end
			end
            if entity:has('Physical') then
                local physical = entity:get('Physical')
                angle = physical.body:getAngle()
                entity_x, entity_y = physical.body:getPosition()
            elseif entity:has('Transformable') then
                angle = -math.pi/2
                entity_x, entity_y = entity:get('Transformable').position:unpack()
                sx, sy = entity:get('Transformable').scale:unpack()
            end

            local flash_white = false
            if entity:has('HitIndicator') then
                hi =  entity:get('HitIndicator')
                if hi.hit then
                    flash_white = true
                    hi.hit = false
                end
            else
                flash_white = false
            end

            if flash_white then
                love.graphics.setColor(5000,5000,5000,255)
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

            love.graphics.setColor(255,255,255,255)

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
