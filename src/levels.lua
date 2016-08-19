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

function sin_both(state, pos, velocity, enemy_pos, enemy_velocity)

    if state == nil then state = {x = "left", y = "up"} end

    if pos.y > h-100 then
        state.y = "up"
    end
    if pos.y < 100 then
        state.y = "down"
    end

    if state.y == "up" then
        vec_y = Vector(0, -0.7)
    else
         vec_y = Vector(0, 1.5)
    end


    if pos.x > w-100 then
        state.x = "left"
    end
    if pos.x < 100 then
        state.x = "right"
    end

    if state.x == "left" then
        vec_x = Vector(-3,0)
    else
        vec_x = Vector(0.8,0)
    end

    return state, (vec_x+vec_y):normalize()
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

levels[1].layers[items.ram.layer] = "ram"

levels[2].layers[items.missiles.layer] = "missiles"
levels[2].mothership_ai = sin_up_down

levels[3].layers[items.shield.layer] = "shield"
levels[3].layers[items.missiles.layer] = "missiles"
levels[3].mothership_ai = sin_both

levels[4].layers[items.shield.layer] = "shield"
levels[4].layers[items.laser.layer] = "laser"
levels[4].mothership_ai = sin_up_down

levels[5].layers[items.shield.layer] = "shield"
levels[5].layers[items.laser.layer] = "laser"
levels[5].mothership_ai = mimic

levels[6].layers[items.shield.layer] = "shield"
levels[6].layers[items.laser.layer] = "laser"
levels[6].mothership_ai = sin_both

levels[7].layers[items.shield.layer] = "shield"
levels[7].layers[items.laser.layer] = "laser"
levels[7].mothership_ai = mimic

levels[8].layers[items.shield.layer] = "shield"
levels[8].layers[items.laser.layer] = "laser"
levels[8].mothership_ai = sin_both

levels[9].layers[items.shield.layer] = "shield"
levels[9].layers[items.laser.layer] = "laser"
levels[9].mothership_ai = sin_both

levels[10].layers[items.shield.layer] = "shield"
levels[10].layers[items.laser.layer] = "laser"
levels[10].mothership_ai = sin_both
