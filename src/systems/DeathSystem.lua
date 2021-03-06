local DeathSystem = class('DeathSystem', System)

function DeathSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity:get("Health").points <= 0 then
            if not entity:has('Mothership') then
                stack:current():delete_entity(entity)
            end
            resources.sounds.kaboom_1:setVolume(0.3)
		    resources.sounds.kaboom_1:clone():play()

        end
    end
end

function DeathSystem:requires()
    return {'Health'}
end

return DeathSystem
