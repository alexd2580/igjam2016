local Weapon = Component.create("Weapon")

function Weapon:initialize(opts)
    self.cooldown = opts.cooldown or 1
    self.since_last_fired = math.random() * self.cooldown
    self.hitChance = opts.hitChance
    self.damage = opts.damage
    self.type = opts.type
    self.range = opts.range
    self.sprayAngle = opts.sprayAngle
end
