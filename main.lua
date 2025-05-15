local shakeAmount = 0
local shakeTimer = 0

Starfield = require("src/Starfield")
local DotPhysics = require("src/DotPhysics")
local BuyMenu = require("src/BuyMenu")
local MainCircle = require("src/MainCircle")
local Music = require("src/Music")

function love.load()
    anim8 = require "Libraries/anim8"
    ripple = require "Libraries/ripple"

    love.window.setMode(1500, 1100)
    love.window.setFullscreen(false, "desktop")

    sW, sH = love.graphics.getDimensions()
    paused = false
    startScreen = true
    buyMenuDisabled = true
    menuButton = false
    buyMenuUnlocked = false
    unlockedMenuAmount = 50
    score = 0
    solsPerSecond = 0
    dotsToAdd = 1
    textTimer = 0

    -- Sounds

    Music.load()

    love.graphics.setLineStyle("rough")
    font = love.graphics.newFont("Fonts/Junicode-Bold.ttf", 55)
    love.graphics.setFont(font)

    image = love.graphics.newImage("Sprites/stars.png")
    grid = anim8.newGrid(90, 90, image:getWidth(), image:getHeight())

    Starfield.load()

    circCenterX = sW / 2
    circCenterY = sH / 2 - 80
end

function love.update(dt)
    Starfield.update(dt)
    DotPhysics.update(dt, circCenterX, circCenterY)
    score = score + solsPerSecond * dt
    textTimer = textTimer + dt


    if Music.buttonHoverPing then
        Music.buttonHoverPing:update(dt)
    end


    if score >= unlockedMenuAmount and not buyMenuUnlocked then
        buyMenuUnlocked = true
        buyMenuDisabled = false
        Music.PlayOpenMenu()
    end

    if not previousHover then
        previousHover = {}
    end

    if not buyMenuDisabled then
        local mx, my = love.mouse.getPosition()
        BuyMenu.updateHover(mx, my)

        for i = 1, 4 do
            local current = BuyMenu.getHover(i)
            local previous = previousHover[i] or false
            if current and not previous then
                Music.PlayButtonHoverPing()
            end
            previousHover[i] = current
        end
    end
end

function love.draw()
    Starfield.draw()
    MainCircle.draw(circCenterX, circCenterY)
    DotPhysics.draw()

    local offsetX = math.cos(textTimer * 1.2) * 4
    local offsetY = math.sin(textTimer * 1.2) * 4

    love.graphics.setColor(0, 0, 0, 0.65)
    love.graphics.rectangle("fill", sW / 2 - 110 + offsetX, sH / 2 + 385 + offsetY, 220, 60, 20, 20)

    love.graphics.setColor(1, 0.15, 1)
    if startScreen then
        love.graphics.printf("1 CLICK = 1 SOL", offsetX, sH / 2 - 97 + offsetY, sW, "center")
    else
        displayedScore = math.floor(score)
        love.graphics.printf("SOLS: " .. displayedScore, offsetX, 940 + offsetY, sW, "center")
    end

    if not buyMenuDisabled then
        BuyMenu.draw()
    end

    if not buyMenuDisabled then
        local exitX, exitY = 45, 45
        love.graphics.setLineWidth(4)
        love.graphics.setColor(0.25, 0.25, 0.25, 0.9)
        love.graphics.rectangle("fill", exitX, exitY, 70, 70, 15, 15)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(love.graphics.newFont("Fonts/Junicode-Bold.ttf", 55))
        love.graphics.printf("X", exitX, exitY + 10, 70, "center")
    end

    if buyMenuDisabled and buyMenuUnlocked then
        love.graphics.setColor(0.55, 0.55, 0.55)
        love.graphics.rectangle("fill", 45, 45, 70, 70, 15, 15)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(love.graphics.newFont("Fonts/arial.ttf", 55))
        love.graphics.printf("≡", 45, 51, 70, "center")
        love.graphics.setFont(font)
    end
end

function love.keypressed(key)
    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "exclusive")
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and buyMenuDisabled then
        startScreen = false
        local dx = x - circCenterX
        local dy = y - circCenterY
        if math.sqrt(dx * dx + dy * dy) <= 425 then
            score = score + dotsToAdd
            DotPhysics.spawn(x, y, dotsToAdd, sW, sH)
        end
    end
    if not buyMenuDisabled then
        if x >= 55 and x <= 125 and y >= 55 and y <= 125 then
            buyMenuDisabled = true
            Music.PlayMenuExitBass()
        end
        BuyMenu.mousepressed(x, y, button)
    elseif buyMenuDisabled and buyMenuUnlocked then
        if x >= 45 and x <= 115 and y >= 45 and y <= 115 then
            buyMenuDisabled = false
            Music.PlayOpenMenu()
        end
    end
end
