local PreBattleState = class('PreBattleState', State)
local GameState = require('states/GameState')


local suit = require('lib/suit')
function PreBattleState:initialize(level, enabledItems)
    self.level = level
    self.enabledItems = enabledItems
    self.countDown = 1
    self.done = false
end

function PreBattleState:update(dt)
    self.countDown = self.countDown - dt
    if self.done == false then 
        if self.countDown < 0 then
            stack:push(GameState(self.level, self.enabledItems, levels[self.level] or default_level))
            self.done = true
        end
    end
end
function PreBattleState:load()
    resources.sounds.startBattle:setVolume(0.7)
    resources.sounds.startBattle:play()
end


function PreBattleState:draw()
    push:apply("start")
    love.graphics.draw(resources.images.preBattle, 0, 0)
    push:apply("end")
end

return PreBattleState
