BulletHitMothership = class("BulletHitMothership")

function BulletHitMothership:initialize(bullet, target, damage)
    self.bullet = bullet
    self.target = target
    self.damage = damage
	shake_duration = 0.5
	shake_offset = 0
end
