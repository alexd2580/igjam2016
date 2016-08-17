lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})

State = require('lib/State')
Stack = require('lib/StackHelper')
Vector = require('lib/vector')
local Resources = require('lib/Resources')
require('lib/tables')

local MenuState = require('states/MenuState')

function love.load()
    love.window.setMode(1000, 768, {fullscreen=false, vsync=true, resizable=false})
    require('constants')

    stack = Stack()
    stack:push(MenuState())

    resources = Resources()

    resources:addMusic('bg', 'assets/music/glowing_geometry.mp3')

    resources:load()

    resources.music.bg:setLooping(true)
    love.audio.play(resources.music.bg)
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

function love.textinput(text)
    stack:current():textinput(text)
end

function love.draw()
    stack:current():draw()
end
