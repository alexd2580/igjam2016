BulletHitMothership = class("BulletHitMothership")

function BulletHitMothership:initialize(bullet, target)
    self.bullet = bullet
    self.target = target
	shake_duration = 0.5
	shake_offset = 0
end
