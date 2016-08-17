local Drawable = Component.create("Drawable")

function Drawable:initialize(color)
    self.color = color or {255, 0, 0, 255}
end
