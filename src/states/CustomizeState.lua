local CustomizeState = class('CustomizeState', State)

local GameState = require('states/GameState')

local suit = require('lib/suit')

function CustomizeState:load()
    local Transformable, LayeredDrawable = Component.load({"Transformable", "LayeredDrawable"})

    self.engine = Engine()

    self.engine:addSystem(require('systems/DrawSystem')())

    self.enabledItems = {}

    self.mask = Entity()
    self.layers = LayeredDrawable()

    self.mask:add(Transformable(Vector(400, 200), Vector(2, 2)))
    self.mask:add(self.layers)

    self.layers:setLayer(1, resources.images.mask_base)

    self.engine:addEntity(self.mask)
end

function CustomizeState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(100, 100)

    for id, item in pairs(items) do
        suit.Label(item.name, {align = "center", id = ("enableLabel_" .. id)}, suit.layout:row(100, 50))
        local text = (self.enabledItems[item.layer] == id) and "Disable" or "Enable"
        if suit.Button(text, {id = ("enableButton_" .. id) }, suit.layout:row(100, 30)).hit then
            if self.enabledItems[item.layer] == id then
                self.enabledItems[item.layer] = nil
                self.layers:setLayer(item.layer, nil)
            else
                self.enabledItems[item.layer] = id
                self.layers:setLayer(item.layer, item.image)
            end
        end
    end

    suit.layout:reset(300, 100)

    suit.layout:reset(push:getWidth() - 210, push:getHeight() - 100, 10, 10)
    if suit.Button("Into Battle!", suit.layout:row(200, 40)).hit then
        stack:push(GameState(self.enabledItems))
    end
    if suit.Button("Back", suit.layout:row(200, 40)).hit then
        stack:pop()
    end

    self.engine:update(dt)
end

function CustomizeState:draw()
    push:apply("start")
    suit.draw()
    self.engine:draw()
    push:apply("end")
end

function CustomizeState:textinput(t)
    suit.textinput(t)
end

function CustomizeState:keypressed(key)
    if key == "space" then
        stack:push(GameState(self.enabledItems))
        return
    end
    suit.keypressed(key)
end

return CustomizeState
