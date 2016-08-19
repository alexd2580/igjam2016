local MothershipAI = Component.create("MothershipAI")

function MothershipAI:initialize(func)
    self.func = func
    self.state = nil
end
