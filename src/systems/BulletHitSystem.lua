local BulletHitSystem = class("BulletHitSystem", System)

function BulletHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function BulletHitSystem:drone_hit(event)
    event.bullet:get('Health').points = 0
    event.target:get('Health').points =
        event.target:get('Health').points - event.bullet:get('Bullet').damage
end

function BulletHitSystem:mothership_hit(event)
    event.bullet:get('Health').points = 0
    event.target:get('Health').points =
        event.target:get('Health').points - event.bullet:get('Bullet').damage
end

return BulletHitSystem
