local MainCircle = {}

sW, sH = love.graphics.getDimensions()
circCenterX = sW / 2
circCenterY = sH / 2 - 80

function MainCircle.draw(circCenterX, circCenterY)
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.circle("fill", circCenterX, circCenterY, 490)

    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", circCenterX, circCenterY, 425)

    lineOpacity = 0
    love.graphics.setColor(1, 1, 1, lineOpacity)
    love.graphics.setLineWidth(2)
    love.graphics.circle("line", circCenterX, circCenterY, 425)
end

return MainCircle
