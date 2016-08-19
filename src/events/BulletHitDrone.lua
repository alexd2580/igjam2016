BulletHitDrone = class("BulletHitDrone")

function BulletHitDrone:initialize(bullet, target)
    self.bullet = bullet
    self.target = target
	shake_duration = 0.2
	shake_offset = 0
end
