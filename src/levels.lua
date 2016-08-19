local Shield, Weapon = Component.load({"Shield", "Weapon"})

default_level = {
    layers = {},
    mothership_ai = nil
}

levels = {
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    },
    {
        layers = {},
        mothership_ai = nil
    }
}

local w, h = 512, 448

function sin_up_down(state, pos, velocity, enemy_pos, enemy_velocity)
    if state == nil then state = "up" end

    if pos.y > h-100 then
        state = "up"
    end
    if pos.y < 100 then
        state = "down"
    end

    if state == "up" then
        return state, Vector(0, -1)
    else
         return state, Vector(0, 1)
    end
end

function mimic(state, pos, velocity, enemy_pos, enemy_velocity)
    local desired_pos = Vector(512-enemy_pos.x, 448-enemy_pos.y)
    local diff = desired_pos - pos
    if diff:length() < 0.00001 then --rip
        return nil, Vector(0,0)
    else
        return nil, diff:normalize()
    end
end

levels[1].layers[items.shield.layer] = "shield"
levels[1].mothership_ai = mimic

levels[2].layers[items.shield.layer] = "shield"
levels[2].layers[items.missiles.layer] = "missiles"
levels[2].mothership_ai = mimic

levels[3].layers[items.shield.layer] = "shield"
levels[3].layers[items.missiles.layer] = "missiles"
levels[3].mothership_ai = mimic

levels[4].layers[items.shield.layer] = "shield"
levels[4].layers[items.laser.layer] = "laser"
levels[4].mothership_ai = sin_up_down

levels[5].layers[items.shield.layer] = "shield"
levels[5].layers[items.laser.layer] = "laser"
levels[5].mothership_ai = sin_up_down

levels[6].layers[items.shield.layer] = "shield"
levels[6].layers[items.laser.layer] = "laser"
levels[6].mothership_ai = sin_up_down

levels[7].layers[items.shield.layer] = "shield"
levels[7].layers[items.laser.layer] = "laser"
levels[7].mothership_ai = sin_up_down

levels[8].layers[items.shield.layer] = "shield"
levels[8].layers[items.laser.layer] = "laser"
levels[8].mothership_ai = sin_up_down

levels[9].layers[items.shield.layer] = "shield"
levels[9].layers[items.laser.layer] = "laser"
levels[9].mothership_ai = sin_up_down

levels[10].layers[items.shield.layer] = "shield"
levels[10].layers[items.laser.layer] = "laser"
levels[10].mothership_ai = sin_up_down
