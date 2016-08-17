local GameState = class('GameState', State)

require("components/Drawable")
require("components/Physical")
require("components/SwarmMember")

-- systems
DrawSystem = require("systems/DrawSystem")
PlayerControlSystem = require("systems/PlayerControlSystem")
SwarmSystem = require("systems/SwarmSystem")

local Drawable = Component.load({'Drawable'})

function GameState:load()
    self.engine = Engine()
    self.world = love.physics.newWorld(0, 0, false)
    -- world:setCallbacks(beginContact, endContact)
    self.eventmanager = lt.EventManager()

    -- add systems to engine
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(PlayerControlSystem())

    player = Entity()
    player:add(Drawable(100, 100, 20))

    self.engine:addEntity(player)
end

function GameState:update(dt)
    self.engine:update(dt)
    self.world:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key)
end

return GameState
