local BulletHitSystem = class("BulletHitSystem", System)

function BulletHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function BulletHitSystem:drone_hit(event)
    --evmgr = self.gamestate.eventmanager
    --evmgr:fireEvent(EntityDamaged(event.enemy, event.bullet:get('Bullet').damage))
    --evmgr:fireEvent(EntityDamaged(event.bullet, 1))
end

function BulletHitSystem:mothership_hit(event)
    --evmgr = self.gamestate.eventmanager
    --evmgr:fireEvent(EntityDamaged(event.enemy, event.bullet:get('Bullet').damage))
    --evmgr:fireEvent(EntityDamaged(event.bullet, 1))
end

return BulletHitSystem
