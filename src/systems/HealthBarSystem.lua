local HealthBarSystem = class('HealthBarSystem', System)

function HealthBarSystem:draw()

end

function HealthBarSystem:requires()
    return {"Transformable"}
end

return HealthBarSystem
