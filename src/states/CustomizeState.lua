local CustomizeState = class('CustomizeState', State)

local GameState = require('states/GameState')
local WonGameState = require('states/WonGameState')
local PreBattleState = require('states/PreBattleState')

local suit = require('lib/suit')

function CustomizeState:startGame()
    stack:push(PreBattleState(self.level, self.enabledItems))
end

function CustomizeState:initialize(level)
    self:loadLevel(level)

    self.bg1_scale = 1.2
    self.bg1_speed = 0.2
    self.bg1_pos = 0
    self.bg2_scale = 1.22
    self.bg2_speed = 0.8
    self.bg2_pos = 0
    self.bg3_scale = 1.22
    self.bg3_speed = 1.2
    self.bg3_xpos = 700
    self.bg3_ypos = 80
    self.bg4_scale = 1.22
    self.bg4_speed = 0.9
    self.bg4_xpos = 500
    self.bg4_ypos = 40
    self.mask_pos = 0
end

function CustomizeState:load()
    local Transformable, LayeredDrawable = Component.load({"Transformable", "LayeredDrawable"})

    self.engine = Engine()

    self.engine:addSystem(require('systems/DrawSystem')())

    self.enabledItems = {}

    self.mask = Entity()
    self.layers = LayeredDrawable()

    self.original_mask_pos = Vector(230, 140)
    self.mask:add(Transformable(self.original_mask_pos, Vector(2, 2)))
    self.mask:add(self.layers)

    self.layers:setLayer(1, resources.images.mask_base)

    self.engine:addEntity(self.mask)
end

function CustomizeState:update(dt)
    suit.updateMouse(push:toGame(love.mouse.getPosition()))
    suit.layout:reset(50, 50)

    for id, item in pairs(items) do
        if self.level >= item.level then
            suit.Label(item.name, {align = "center", id = ("enableLabel_" .. id)}, suit.layout:row(100, 50))
            local text = (self.enabledItems[item.layer] == id) and "Disable" or "Enable"
            if suit.Button(text, {id = ("enableButton_" .. id) }, suit.layout:row(100, 30)).hit then
                resources.sounds.modificationApply:setVolume(0.5)
                resources.sounds.modificationApply:play()
                if self.enabledItems[item.layer] == id then
                    self.enabledItems[item.layer] = nil
                    self.layers:setLayer(item.layer, nil)
                else
                    self.enabledItems[item.layer] = id
                    self.layers:setLayer(item.layer, item.image)
                end
            end
        end
    end

    suit.layout:reset(300, 100)

    suit.layout:reset(push:getWidth() - 210, push:getHeight() - 100, 10, 10)
    if suit.Button("Into Battle!", suit.layout:row(200, 40)).hit then
        resources.sounds.click:play()
        self:startGame()
    end
    if suit.Button("Back", suit.layout:row(200, 40)).hit then
        resources.sounds.click:play()
        stack:pop()
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

    self.engine:update(dt)

    self.mask_pos = self.mask_pos + dt
end

function CustomizeState:draw()
    push:apply("start")
    love.graphics.draw(resources.images.bg1, self.bg1_pos, 80, 0, self.bg1_scale)
    love.graphics.draw(resources.images.bg1, self.bg1_pos + resources.images.bg1:getWidth() * self.bg1_scale, 80, 0, self.bg1_scale)
    love.graphics.draw(resources.images.bg2, self.bg2_pos, 80, 0, self.bg2_scale)
    love.graphics.draw(resources.images.bg2, self.bg2_pos + resources.images.bg2:getWidth() * self.bg2_scale, 80, 0, self.bg2_scale)
    love.graphics.draw(resources.images.bg4, self.bg4_xpos, self.bg4_ypos, 0, self.bg4_scale)
    love.graphics.draw(resources.images.bg3, self.bg3_xpos, self.bg3_ypos, 0, self.bg3_scale)
    love.graphics.draw(resources.images.hangar, 0, 0)

    love.graphics.setBlendMode('add')
    suit:draw()
    love.graphics.setBlendMode('alpha')

    self.engine:draw()
    love.graphics.print("Level " .. self.level, 20, 20, 0, 4)

    self.mask:get('Transformable').position.y = self.original_mask_pos.y + math.sin(self.mask_pos)
    self.mask:get('Transformable').position.x = self.original_mask_pos.x + math.sin(self.mask_pos * 3)
    self.mask:get('Transformable').scale = Vector(1, 1) * math.max(2, math.sin(self.mask_pos * 0.4) + 2)
    push:apply("end")
end

function CustomizeState:textinput(t)
    suit.textinput(t)
end

function CustomizeState:keypressed(key)
    if key == "space" then
        self:startGame()
    end
    if key == "[" then
        self:loadLevel(self.level - 1)
    end
    if key == "]" then
        self:loadLevel(self.level + 1)
    end

    suit.keypressed(key)
end

function CustomizeState:loadLevel(level)
    if level < 1 then
        level = 1
    end
    if level > #levels then
        stack:pop()
        stack:push(WonGameState())
    end

    self.level = level
    print("Loading level " .. self.level)
end

return CustomizeState
