local PulseSystem = class("PulseSystem", System)

function PulseSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local pulse = entity:get("Pulse")
        pulse.period = pulse.period + dt
        if pulse.period >= pulse.time_since_last_pulse then
            pulse.period = 0
        end
    end
end

function PulseSystem:requires()
    return {'Pulse'}
end

return PulseSystem
