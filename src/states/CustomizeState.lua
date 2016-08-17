local CustomizeState = class('CustomizeState', State)

local GameState = require('states/GameState')

local suit = require('lib/suit')

function CustomizeState:load()
    self.enabledItems = {}
end

function CustomizeState:update(dt)
    suit.layout:reset(100, 100)

    for id, item in pairs(items) do
        suit.Label(item.name, {align = "center", id = ("enableLabel_" .. id)}, suit.layout:row(100, 50))
        local text = self.enabledItems[id] and "Disable" or "Enable"
        if suit.Button(text, {id = ("enableButton_" .. id) }, suit.layout:row(100, 30)).hit then
            self.enabledItems[id] = not self.enabledItems[id]
        end
    end

    suit.layout:reset(300, 100)

    suit.Label("Enabled items:", {align = "left"}, suit.layout:row(100, 50))
    for id, enabled in pairs(self.enabledItems) do
        if enabled then
            suit.Label(items[id].name, {align = "center", id = ("enabledLabel_" .. id)}, suit.layout:row(100, 50))
        end
    end

    suit.layout:reset(constants.screenWidth - 240, constants.screenHeight - 80, 10, 10)
    if suit.Button("Into Battle!", suit.layout:row(200, 40)).hit then
        stack:push(GameState(self.enabledItems))
    end
end

function CustomizeState:draw()
    suit.draw()
end

function CustomizeState:textinput(t)
    suit.textinput(t)
end

function CustomizeState:keypressed(key)
    stack:push(GameState(self.enabledItems))
    suit.keypressed(key)
end

return CustomizeState
