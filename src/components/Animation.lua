local Animation = Component.create("Animation")

function Animation:initialize(images, frames_per_image)
    self.frames_per_image = frames_per_image
    self.frames_left = frames_per_image
    self.image_number = 1
    self.images = images
end
