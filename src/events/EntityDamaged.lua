EntityDamaged = class("EntityDamaged")

function EntityDamaged:initialize(entity, damage)
    self.entity = entity
    self.damage = damage
end
