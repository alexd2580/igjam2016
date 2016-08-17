lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})

State = require('lib/State')
Stack = require('lib/StackHelper')
Vector = require('lib/vector')
require('lib/tables')
require('constants')

local GameState = require('states/GameState')

function love.load()
    love.window.setMode(1000, 768, {fullscreen=false, vsync=true, resizable=false})
    stack = Stack()
    stack:push(GameState())
end

function love.update(dt)
    stack:current():update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    stack:current():keypressed(key)
end

function love.draw()
    stack:current():draw()
end
