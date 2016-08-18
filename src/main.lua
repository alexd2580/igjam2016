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

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")
require("components/HasEnemy")
require("components/Weapon")
require("components/Bullet")
require("components/Shield")
require("components/Health")

require('items')

local MenuState = require('states/MenuState')

function love.load()
    love.window.setMode(1000, 768, {fullscreen=false, vsync=true, resizable=false})
    require('constants')

    stack = Stack()
    stack:push(MenuState())

    resources = Resources()

    resources:addImage('fighter', 'assets/img/fighterConfig/fighter1.png')
    resources:addImage('fighter_missile', 'assets/img/fighterConfig/missileSimple.png')
    resources:addImage('mask_base', 'assets/img/maskConfig/base.png')
    resources:addMusic('bg', 'assets/music/glowing_geometry.mp3')

    resources:load()

    resources.music.bg:setLooping(true)
    -- love.audio.play(resources.music.bg)
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
