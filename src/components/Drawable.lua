local Drawable = Component.create("Drawable")

function Drawable:initialize(ox, oy, r)
    if ox then self.ox = ox end
    if oy then self.oy = oy end
    if r then self.r = r end
end
