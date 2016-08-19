local Health = Component.create("Health")

function Health:initialize(points)
    self.points = points
    self.max = points
end
