Vector = class("Vector")

function Vector:initialize(x, y)
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

function Vector:sum()
    return math.abs(self.x) + math.abs(self.y)
end

function Vector:length()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector:normalize()
    local l = self:length()
    return Vector(self.x / l, self.y / l)
end

function Vector:dot(other)
    return other.x * self.x + other.y * self.y
end

function Vector:distanceTo(other)
    return self:subtract(other):length()
end

function Vector:getRadian()
    return math.atan2(self.y, self.x)
end

function Vector:add(vector)
    if type(vector) == "number" then
        return Vector(self.x + vector, self.y + vector)
    elseif vector.class.name == "Vector" then
        return Vector(self.x + vector.x, self.y + vector.y)
    end
end

function Vector:subtract(vector)
    if type(vector) == "number" then
        return Vector(self.x - vector, self.y - vector)
    elseif vector.class.name == "Vector" then
        return Vector(self.x - vector.x, self.y - vector.y)
    end
end

function Vector:multiply(vector)
    if type(vector) == "number" then
        return Vector(self.x * vector, self.y * vector)
    elseif vector.class.name == "Vector" then
        return Vector(self.x * vector.x, self.y * vector.y)
    end
end

function Vector:divide(vector)
    if type(vector) == "number" then
        return Vector(self.x / vector, self.y / vector)
    elseif vector.class.name == "Vector" then
        return Vector(self.x / vector.x, self.y / vector.y)
    end
end

function Vector:modulo(vector)
    if type(vector) == "number" then
        return Vector(self.x % vector, self.y % vector)
    elseif vector.class.name == "Vector" then
        return Vector(self.x % vector.x, self.x % vector.y)
    end
end

function Vector:abs()
    return Vector(math.abs(self.x), math.abs(self.y))
end

function Vector:rotate(radian)
    local x, y
    x = self.x * math.cos(radian) - self.y * math.sin(radian)
    y = self.x * math.sin(radian) + self.y * math.cos(radian)
    return Vector(x, y)
end

function Vector:eq(vector)
    if type(vector) == "table" then
        return vector.x == self.x and vector.y == self.y
    end
    return false
end

function Vector.from_radians(rad)
    local x = math.cos(rad)
    local y = math.sin(rad)
    return Vector(x, y)
end

function Vector:unpack()
    return self.x, self.y
end

Vector.__add = Vector.add
Vector.__sub = Vector.subtract
Vector.__mul = Vector.multiply
Vector.__div = Vector.divide
Vector.__mod = Vector.modulo
Vector.__eq = Vector.eq

return Vector
