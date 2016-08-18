local MenuState = class('MenuState', State)

local suit = require('lib/suit')

local CustomizeState = require('states/CustomizeState')
local CreditsState = require('states/CreditsState')

function MenuState:initialize()
    self.bg1_scale = 3
    self.bg1_speed = 0.2
    self.bg1_pos = 0
    self.bg2_scale = 3
    self.bg2_speed = 0.8
    self.bg2_pos = 0
    self.bg3_scale = 1
    self.bg3_speed = 1.2
    self.bg3_xpos = 700
    self.bg3_ypos = 80
    self.bg4_scale = 1
    self.bg4_speed = 0.9
    self.bg4_xpos = 500
    self.bg4_ypos = 40
end

function MenuState:load()
end

function MenuState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(push:getWidth() - 210, push:getHeight() - 100, 10, 10)

    if suit.Button("Start Game", suit.layout:row(200, 40)).hit then
        stack:push(CustomizeState(1))
    end

    if suit.Button("Credits", suit.layout:row(200, 40)).hit then
        stack:push(CreditsState())
    end

    self.bg1_pos = self.bg1_pos - self.bg1_speed
    if self.bg1_pos <= -resources.images.bg1:getWidth() * self.bg1_scale then
        self.bg1_pos = 0
    end

    self.bg2_pos = self.bg2_pos - self.bg2_speed
    if self.bg2_pos <= -resources.images.bg2:getWidth() * self.bg2_scale then
        self.bg2_pos = 0
    end

    self.bg3_xpos = self.bg3_xpos - self.bg3_speed
    if self.bg3_xpos <= -resources.images.bg3:getWidth() * self.bg3_scale then
        self.bg3_xpos = game_width * 2
        self.bg3_ypos = math.random(20, game_height - 20)
    end

    self.bg4_xpos = self.bg4_xpos - self.bg4_speed
    if self.bg4_xpos <= -resources.images.bg4:getWidth() * self.bg4_scale then
        self.bg4_xpos = game_width * 2
        self.bg4_ypos = math.random(20, game_height - 20)
    end
end

function MenuState:draw()
    push:apply("start")
    love.graphics.draw(resources.images.bg1, self.bg1_pos, 0, 0, self.bg1_scale)
    love.graphics.draw(resources.images.bg1, self.bg1_pos + resources.images.bg1:getWidth() * self.bg1_scale, 0, 0, self.bg1_scale)
    love.graphics.draw(resources.images.bg2, self.bg2_pos, 0, 0, self.bg2_scale)
    love.graphics.draw(resources.images.bg2, self.bg2_pos + resources.images.bg2:getWidth() * self.bg2_scale, 0, 0, self.bg2_scale)
    love.graphics.draw(resources.images.bg4, self.bg4_xpos, self.bg4_ypos, 0, self.bg4_scale)
    love.graphics.draw(resources.images.bg3, self.bg3_xpos, self.bg3_ypos, 0, self.bg3_scale)
    love.graphics.draw(resources.images.title, 0, 0)
    suit:draw()
    push:apply("end")
end

function MenuState:keypressed(key)
    if key == "space" then
        stack:push(CustomizeState(1))
    end
end

return MenuState
