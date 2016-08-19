local DroneHitSystem = class("DroneHitSystem", System)

function DroneHitSystem:initialize(gamestate)
    self.gamestate = gamestate
end

function DroneHitSystem:drone_hit_enemy(event)
    local is_mothership = event.enemy_type == "mothership"

    local atk = event.drone
    local def = event.enemy

    local damage_frontal = 10
    local damage_rear = 70
    local damage_mtsp = 50

    local atk_body = atk:get('Physical').body
    local atk_x, atk_y = atk_body:getPosition()
    local atk_vx, atk_vy = atk_body:getLinearVelocity()
    local atk_v = Vector.from_radians(atk_body:getAngle()):normalize()

    local def_body = def:get('Physical').body
    local def_x, def_y = def_body:getPosition()
    local def_vx, def_vy = def_body:getLinearVelocity()
    local def_v = Vector.from_radians(def_body:getAngle()):normalize()

    local atk_to_def = Vector(def_x-atk_x, def_y-atk_y):normalize()
    local def_to_atk = atk_to_def:neg()
    local atk_angle = atk_to_def:dot(atk_v)
    local def_angle = def_to_atk:dot(def_v)

    local atk_frontal = atk_angle > 0.60
    local def_frontal = def_angle > 0.60

    function handle_dmg(entity, hit_frontal)
        local health = entity:get('Health')
        if hit_frontal then
            health.points = health.points - damage_frontal
        else
            health.points = health.points - damage_rear
            if entity:has('HitIndicator') then
                entity:get('HitIndicator').hit = true
            end
        end
    end

    handle_dmg(atk, atk_frontal)

    local def_health = def:get('Health')
    if is_mothership then
        def_health.points = def_health.points - damage_mtsp
        if def:has('HitIndicator') then
            def:get('HitIndicator').hit = true
        end
    else
        handle_dmg(def, def_frontal)
    end
end

--[[
    tgt:get('Health').points =
        tgt:get('Health').points - event.bullet:get('Bullet').damage

    if tgt:get('Health').points <= 0 then
        self.gamestate:enqueue_event(DroneDead(tgt))
    end

    if tgt:has('HitIndicator') then
        tgt:get('HitIndicator').hit = true
    end]]

return DroneHitSystem
