local HitDamage = Component.create('HitDamage')

function HitDamage:initialize(opts)
    self.frontal = opts.frontal
    self.rear = opts.rear
    self.mothership = opts.mothership
end

return HitDamage
