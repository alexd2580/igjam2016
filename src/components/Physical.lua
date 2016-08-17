local Physical = Component.create("Physical")

function Physical:initialize(body, fixture, shape)
    self.body = body
    self.shape = shape
    self.fixture = fixture
end
