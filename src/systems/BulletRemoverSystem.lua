local BulletRemoverSystem = class("BulletRemoverSystem", System)

function BulletRemoverSystem:initialize(gamestate)
    System.initialize(self)
    self.gamestate = gamestate
end

function BulletRemoverSystem:update(dt)
    local width,height,_ = love.window.getMode()
    local margin = 100
    for k, entity in pairs(self.targets) do
        local body = entity:get('Physical').body
        local x,y = body:getPosition()

        if x < -margin or x > width+margin
            or y < -margin or y > height+margin then
                entity:get('Physical').body:destroy()
                self.gamestate.engine:removeEntity(entity)
        end
    end
end

function BulletRemoverSystem:requires()
    return {"Bullets"} --implicitly contain Physical
end

return BulletRemoverSystem
