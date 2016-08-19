local BulletHitSystem = class("BulletHitSystem", System)

function BulletHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

local function dealDamage(entity, damage)
    if (not entity:has('Shield')) or entity:get('Shield').charge <= 0 then
        entity:get('Health').points =
            entity:get('Health').points - event.damage
    end
end

function BulletHitSystem:drone_hit(event)
    local tgt = event.target
    event.bullet:get('Health').points = 0
    dealDamage(tgt, event.bullet:get('Bullet').damage)

    if tgt:get('Health').points <= 0 then
        self.gamestate:enqueue_event(DroneDead(tgt))
    end

    if tgt:has('HitIndicator') then
        tgt:get('HitIndicator').hit = true
    end
end

function BulletHitSystem:mothership_hit(event)
    local tgt = event.target
    if event.bullet then event.bullet:get('Health').points = 0 end
    dealDamage(tgt, event.damage)

    if tgt:get('Health').points <= 0 then
        --self.gamestate:schedule_explosion(tgt)
    end

    if tgt:has('HitIndicator') then
        tgt:get('HitIndicator').hit = true
    end
end

return BulletHitSystem
