local BulletHitSystem = class("BulletHitSystem", System)

function BulletHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function BulletHitSystem:drone_hit(event)
    event.bullet:get('Health').points = 0
    event.target:get('Health').points =
        event.target:get('Health').points - event.bullet:get('Bullet').damage

    if event.target:get('Health').points <= 0 then
        self.gamestate:enqueue_event(DroneDead(event.target))
    end
end

function BulletHitSystem:mothership_hit(event)
    event.bullet:get('Health').points = 0
    event.target:get('Health').points =
        event.target:get('Health').points - event.bullet:get('Bullet').damage

    if event.target:get('Health').points <= 0 then
        --self.gamestate:schedule_explosion(event.target)
    end
end

return BulletHitSystem
