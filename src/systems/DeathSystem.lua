local DeathSystem = class('DeathSystem', System)

function DeathSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity:get("Health").points <= 0 then
            stack:current().engine:removeEntity(entity)
            if entity:has("Physical") then
                entity:get("Physical").body:destroy()
            end
        end
    end
end

function DeathSystem:requires()
    return {'Health'}
end

return DeathSystem
