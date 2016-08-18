local DeathSystem = class('DeathSystem', System)

function DeathSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity:get("Health").points <= 0 then
            stack:current():delete_entity(entity)
        end
    end
end

function DeathSystem:requires()
    return {'Health'}
end

return DeathSystem
