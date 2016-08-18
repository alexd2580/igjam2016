local PulseSystem = class("PulseSystem", System)

function PulseSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local pulse = entity:get("Pulse")
        pulse.time_since_last_pulse = pulse.time_since_last_pulse + dt
        if pulse.time_since_last_pulse >= pulse.period then
            pulse.time_since_last_pulse = 0
        end
    end
end

function PulseSystem:requires()
    return {'Pulse'}
end

return PulseSystem
