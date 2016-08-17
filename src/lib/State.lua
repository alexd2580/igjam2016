local State = class("State")

State.renderBelow = false

function State:load() end
function State:update(dt) end
function State:draw() end
function State:shutdown() end
function State:keypressed(key, isrepeat) end
function State:keyreleased(key, isrepeat) end
function State:mousepressed(x, y, key) end
function State:textinput(text) end
function State:load() end

return State
