local Pulse = Component.create("Pulse")

function Pulse:initialize(period)
    self.period = period
    self.time_since_last_pulse = 0
end
