local BulletHitSystem = class("BulletHitSystem", System)

function BulletHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function BulletHitSystem:drone_hit(event)
    local tgt = event.target
    event.bullet:get('Health').points = 0
    tgt:get('Health').points =
        tgt:get('Health').points - event.bullet:get('Bullet').damage

    if tgt:get('Health').points <= 0 then
        self.gamestate:enqueue_event(DroneDead(tgt))
    end

    if tgt:has('HitIndicator') then
        tgt:get('HitIndicator').hit = true
    end
end

function BulletHitSystem:mothership_hit(event)
    local tgt = event.target
    event.bullet:get('Health').points = 0
    tgt:get('Health').points =
        tgt:get('Health').points - event.bullet:get('Bullet').damage

    if tgt:get('Health').points <= 0 then
        --self.gamestate:schedule_explosion(tgt)
    end

    if tgt:has('HitIndicator') then
        tgt:get('HitIndicator').hit = true
    end
end

return BulletHitSystem
