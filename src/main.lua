push = require('lib/push/push')
lt = require('lib/lovetoys/lovetoys')
lt.initialize({
    globals = true,
    debug = true
})
debug = false

State = require('lib/State')
Stack = require('lib/StackHelper')
Vector = require('lib/vector')
local Resources = require('lib/Resources')
Shine = require('lib/shine')
require('lib/tables')

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")
require("components/HasEnemy")
require("components/Weapon")
require("components/Bullet")
require("components/Shield")
require("components/Health")
require("components/Particles")
require("components/Mothership")
require("components/LayeredDrawable")
require("components/Transformable")
require("components/Animation")
require("components/LaserBeam")
require("components/HitIndicator")
require("components/Pulse")

local MenuState = require('states/MenuState')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest', 0)
    glyph_string = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-=[]\\,./;')!@#$%^&*(+{}!<>?:\""
    font = love.graphics.newImageFont('assets/img/font.png', glyph_string, 2)
    love.graphics.setFont(font)

    stack = Stack()
    stack:push(MenuState())

    resources = Resources()

    resources:addImage('fighter', 'assets/img/fighterConfig/fighterTiny.png')
    resources:addImage('fighter_missile', 'assets/img/fighterConfig/missile.png')
    resources:addImage('mask_base', 'assets/img/player/colorBlackSmall.png')
    resources:addImage('block_particle', 'assets/img/block_particle.png')
    resources:addImage('round_particle', 'assets/img/round_particle.png')
    resources:addImage('stars_bg', 'assets/img/stars_bg.png')
    resources:addImage('stars_90', 'assets/img/stars_90.png')
    resources:addImage('stars_180', 'assets/img/stars_180.png')
    resources:addImage('core2', 'assets/img/player/core2Small.png')
    resources:addImage('eyes2', 'assets/img/player/eyes2Small.png')
    resources:addImage('eyes3', 'assets/img/player/eyes3Small.png')
    resources:addImage('eyes4', 'assets/img/player/eyes4Small.png')
    resources:addImage('explosion_1', 'assets/img/fighterConfig/explosion_1.png')
    resources:addImage('explosion_2', 'assets/img/fighterConfig/explosion_2.png')
    resources:addImage('explosion_3', 'assets/img/fighterConfig/explosion_3.png')
    resources:addImage('explosion_4', 'assets/img/fighterConfig/explosion_4.png')
    resources:addImage('explosion_5', 'assets/img/fighterConfig/explosion_5.png')
    resources:addImage('bg1', 'assets/img/parallax-space-background.png')
    resources:addImage('bg2', 'assets/img/parallax-space-stars.png')
    resources:addImage('bg3', 'assets/img/parallax-space-big-planet.png')
    resources:addImage('bg4', 'assets/img/parallax-space-far-planets.png')
    resources:addImage('title', 'assets/img/startScene.png')
    resources:addImage('hangar', 'assets/img/hangar.png')
    resources:addMusic('bg', 'assets/music/glowing_geometry.mp3')
    resources:addMusic('laserShot', 'assets/music/laserShot.ogg')

    resources:load()

    require('items')

    resources.music.bg:setLooping(true)
    -- love.audio.play(resources.music.bg)
    game_width, game_height = 512, 448
    local window_width, window_height = love.window.getDesktopDimensions()

    push:setupScreen(game_width, game_height, window_width * 0.8, window_height * 0.8, {fullscreen=false, resizable=true})
end

function love.update(dt)
    stack:current():update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "0" then
        debug = not debug
    end

    stack:current():keypressed(key)
end

function love.textinput(text)
    stack:current():textinput(text)
end

function love.draw()
    push:apply('start')
    stack:current():draw()
    push:apply('end')
end

function love.resize(w, h)
  push:resize(w, h)
end
