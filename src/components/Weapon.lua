local Weapon = Component.create("Weapon")

function Weapon:initialize()
    self.cooldown = 1
    self.since_last_fired = 0.0
    self.damage = 30
end
