local ItemDrawSystem = class('ItemDrawSystem', System)

function ItemDrawSystem:draw()
    for _, entity in pairs(self.targets.rams) do
        local body = entity:get('Physical').body
        local x, y = body:getPosition()
        local img = resources.images.ram
        love.graphics.draw(img, x, y, body:getAngle() + math.pi/2, 1, 1, img:getWidth()/2, img:getHeight()/2)
    end
end

function ItemDrawSystem:requires()
    return {rams = {'HitDamage'}}
end

return ItemDrawSystem
