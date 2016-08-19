DroneDead = class("DroneDead")

function DroneDead:initialize(drone)
    local t_body = drone:get('Physical').body
    self.x, self.y = t_body:getPosition()
    self.angle = t_body:getAngle()
    self.vx, self.vy = t_body:getLinearVelocity()
    self.vr = t_body:getAngularVelocity()
	shake_duration = 0.6
	shake_offset = 0
end
