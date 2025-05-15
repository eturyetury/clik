local DotPhysics = {}

local dots = {}

function DotPhysics.spawn(x, y, count, sW, sH)
    for i = 1, count do
        table.insert(dots, {
            dotX = x,
            dotY = y,
            xDirection = math.random(-sW, sW),
            yDirection = math.random(-sH, sH)
        })
    end
end

function DotPhysics.update(dt, centerX, centerY)
    local maxDistance = 423.5

    for i, dot in ipairs(dots) do
        --Direction/Velocity
        dot.dotX = dot.dotX + (dot.xDirection * dt / 10)
        dot.dotY = dot.dotY + (dot.yDirection * dt / 10)

        --Normal Vectors
        local dx = dot.dotX - centerX
        local dy = dot.dotY - centerY
        local distance = math.sqrt(dx * dx + dy * dy)
        
        if distance > maxDistance then
            local normalizeX = dx / distance
            local normalizeY = dy / distance

            local dotProduct = dot.xDirection * normalizeX + dot.yDirection * normalizeY
            dot.xDirection = dot.xDirection - 2 * dotProduct * normalizeX
            dot.yDirection = dot.yDirection - 2 * dotProduct * normalizeY

            local randomAngle = math.rad(math.random(-15, 15))
            local cosA = math.cos(randomAngle)
            local sinA = math.sin(randomAngle)
            local newX = dot.xDirection * cosA - dot.yDirection * sinA
            local newY = dot.xDirection * sinA + dot.yDirection * cosA
            dot.xDirection = newX
            dot.yDirection = newY

            dot.dotX = dot.dotX - normalizeX * 2
            dot.dotY = dot.dotY - normalizeY * 2
        end
    end
end

function DotPhysics.draw()
    for _, dot in ipairs(dots) do
        love.graphics.setColor(1, 0.15, 1)
        love.graphics.circle("fill", dot.dotX, dot.dotY, 1.75)
    end
end

return DotPhysics