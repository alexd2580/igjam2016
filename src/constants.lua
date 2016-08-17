local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
local smallerDimension = sw < sh and sw or sh

function percentToPixels(percent)
    return percent * smallerDimension/100
end

constants = {
    screenWidth = sw,
    screenHeight = sh
}
