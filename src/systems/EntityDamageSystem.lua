local EntityDamageSystem = class("EntityDamageSystem", System)

function EntityDamageSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function EntityDamageSystem:entity_damaged(event)
    local entity = event.entity
    local health = entity:get('Health')
    health.health = health.health - event.damage

    if health.health <= 0 then
        entity:get('Physical').body:destroy()
        self.gamestate.engine.removeEntity(entity)
    end
end

return EntityDamageSystem
