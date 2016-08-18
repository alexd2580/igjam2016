local BulletHitSystem = class("BulletHitSystem", System)

function BulletHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function BulletHitSystem:drone_hit(event)
end

function BulletHitSystem:mothership_hit(event)
end

return BulletHitSystem
