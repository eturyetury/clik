local Starfield = {}

local stars = {}
local image
local grid

function Starfield.load()
    anim8 = require( "Libraries/anim8" )
    image = love.graphics.newImage( "Sprites/stars.png" )
    grid = anim8.newGrid( 90, 90, image:getWidth(), image:getHeight() )

    for i = 1, 450 do
        table.insert(stars, {
            animation = anim8.newAnimation(grid('1-10', 1), 0.1, 'pauseAtEnd'),
            randomX = math.random(50, 1450),
            randomY = math.random(50, 1050),
            timer = math.random(0., 2.5),
            delay = math.random(30, 100) / 100,
            waiting = true
        })
    end
        

end
function Starfield.update(dt)
    for _, star in ipairs(stars) do
        if star.waiting then
            star.timer = star.timer + dt
            if star.timer >= star.delay then
                star.randomX = math.random(0, 1500)
                star.randomY = math.random(0, 1100)
                star.animation:gotoFrame(1)
                star.animation:resume()
                star.timer = 0
                star.waiting = false
                star.delay = math.random(30, 100) / 100
            end
        else
            star.animation:update(dt)
            if star.animation.status == "paused" then
                star.animation:pause()
                star.waiting = true
            end
        end
    end
end
function Starfield.draw()
    for _, star in ipairs(stars) do
        love.graphics.setColor(1, 1, 1)
        star.animation:draw(image, star.randomX, star.randomY, 0 ,0.15, 0.15)
    end
end

return Starfield