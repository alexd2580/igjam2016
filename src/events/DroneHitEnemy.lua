DroneHitEnemy = class("DroneHitEnemy")

function DroneHitEnemy:initialize(drone, enemy, enemy_type)
    self.drone = drone
    self.enemy = enemy
    self.enemy_type = enemy_type
	shake_duration = 0.4
	shake_offset = 0
end
