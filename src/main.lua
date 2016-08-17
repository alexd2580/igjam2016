
local lovetoys = require('lib.lovetoys.lovetoys')
lovetoys.initialize({
    globals = true,
    debug = true
})

-- Graphic components
require("components/graphic/Drawable")

--Graphic systems
DrawSystem = require("systems/graphic/DrawSystem")


function love.load()
	print('Load')
end

function love.update(dt)
	print('Update')
end

function love.draw()
	print('Draw')
end
