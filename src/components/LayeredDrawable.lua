local LayeredDrawable = Component.create('LayeredDrawable')

function LayeredDrawable:initialize()
    self.layers = {}
    self.maxIndex = 0
end

function LayeredDrawable:setLayer(index, image)
    self.layers[index] = image
    if index > self.maxIndex then self.maxIndex = index end
end

return LayeredDrawable
