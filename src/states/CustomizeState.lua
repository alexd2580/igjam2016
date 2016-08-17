local CustomizeState = class('CustomizeState', State)

local suit = require('lib/suit')

local items = {
    warpDrive = {
        name = "Warp Drive"
        -- image, description, component etc.
    },
    shield = { name = "Shield" },
    yoMama = { name = "Yo Mama" }
}

local enabledItems = {}

function CustomizeState:update(dt)
    suit.layout:reset(100, 100)

    for id, item in pairs(items) do
        suit.Label(item.name, {align = "center", id = ("enableLabel_" .. id)}, suit.layout:row(100, 50))
        local text = enabledItems[id] and "Disable" or "Enable"
        if suit.Button(text, {id = ("enableButton_" .. id) }, suit.layout:row(100, 30)).hit then
            enabledItems[id] = not enabledItems[id]
        end
    end

    suit.layout:reset(300, 100)

    suit.Label("Enabled items:", {align = "left"}, suit.layout:row(100, 50))
    for id, enabled in pairs(enabledItems) do
        if enabled then
            suit.Label(items[id].name, {align = "center", id = ("enabledLabel_" .. id)}, suit.layout:row(100, 50))
        end
    end
end

function CustomizeState:draw()
    suit.draw()
end

function CustomizeState:textinput(t)
    suit.textinput(t)
end

function CustomizeState:keypressed(key)
    if key == "c" then
        stack:pop()
    end
    suit.keypressed(key)
end

return CustomizeState
