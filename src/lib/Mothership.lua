
Mothership = class("Mothership")

local

function Mothership.load()

end

function Mothership:initialize()
    if y == nil then
        self.x = x or 0
        self.y = x or 0
    else
        self.x = x
        self.y = y
    end
end

function Vector:set(x, y)
    if type(x) == "number" and type(y) == "number"then
        self.x = x
        self.y = y
    elseif x.class.name == "Vector" then
        self.x = x.x
        self.y = x.y
    end
end

function Vector:clone()
    return Vector(self.x,self.y)
end
