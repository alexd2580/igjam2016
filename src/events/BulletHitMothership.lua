BulletHitMothership = class("BulletHitMothership")

function BulletHitMothership:initialize(bullet, target, damage)
    self.bullet = bullet
    self.target = target
    self.damage = damage
end
