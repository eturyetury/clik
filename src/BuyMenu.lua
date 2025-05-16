local BuyMenu = {}
local Music = require("src/Music")

local Button1 = {
    x = 645,
    y = 215,
    width = 210,
    height = 130,
    corner = 18,
    icon = love.graphics.newImage("Sprites/plus_per_click_icon.png"),

    stages = {
        { text = "+1 SOLS per [CLICK]",  price = 50,    effect = 1 },
        { text = "+2 SOLS per [CLICK]",  price = 200,   effect = 4 },
        { text = "+3 SOLS per [CLICK]",  price = 700,   effect = 15 },
        { text = "+5 SOLS per [CLICK]",  price = 2200,  effect = 45 },
        { text = "+8 SOLS per [CLICK]",  price = 5200,  effect = 100 },
        { text = "+12 SOLS per [CLICK]", price = 11200, effect = 225 },
        { text = "+20 SOLS per [CLICK]", price = 21200, effect = 475 },
        { text = "+35 SOLS per [CLICK]", price = 41200, effect = 1000 },
        { text = "MAXED OUT",            maxed = true }
    },

    currentStage = 1
}

local Button2 = {
    x = 375,
    y = 405,
    width = 210,
    height = 130,
    corner = 18,
    icon = love.graphics.newImage("Sprites/per s2.png"),

    stages = {
        { text = "+5 SOLS/s",   price = 50,    effect = 5 },
        { text = "+10 SOLS/s",  price = 350,   effect = 20 },
        { text = "+20 SOLS/s",  price = 1250,  effect = 60 },
        { text = "+40 SOLS/s",  price = 3250,  effect = 150 },
        { text = "+80 SOLS/s",  price = 7250,  effect = 350 },
        { text = "+150 SOLS/s", price = 15250, effect = 750 },
        { text = "+300 SOLS/s", price = 31250, effect = 1500 },
        { text = "+600 SOLS/s", price = 61250, effect = 3000 },
        { text = "MAXED OUT",   maxed = true }
    },

    currentStage = 1
}

local Button3 = {
    x = 915,
    y = 405,
    width = 210,
    height = 130,
    corner = 18,
    icon = love.graphics.newImage("Sprites/music_icon.png"),

    stages = {
        { text = "BUY SONG", price = 50,   effect = 1 },
        { text = "BUY SONG", price = 1000, effect = 1 },
        { text = "BUY SONG", price = 3000, effect = 1 },
        { text = "BUY SONG", price = 50,   effect = 1 }
    },

    currentStage = 1
}

local Button4 = {
    x = 645,
    y = 595,
    width = 210,
    height = 130,
    corner = 18,
    icon = love.graphics.newImage("Sprites/cursor_icon.png"),

    stages = {
        { text = "BUY CURSOR", price = 50,  effect = 1 },
        { text = "BUY CURSOR", price = 100, effect = 1 }
    },

    currentStage = 1
}

local buttons = { Button1, Button2, Button3, Button4 }

function BuyMenu.draw()
    love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
    love.graphics.rectangle("fill", 0, 0, sW, sH)

    for _, button in ipairs(buttons) do
        local stage = button.stages[button.currentStage]
        local isMaxed = stage.maxed
        local c = isMaxed and 0.1 or (score < (stage.price or 0) and 0.22 or (button.isHovered and 0.95 or 0.6))
        love.graphics.setColor(c, c, c)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, button.corner, button.corner)

        love.graphics.draw(button.icon, button.x + 62.5, button.y + 17, 0, 0.8, 0.8)

        if button.isHovered then
            menuFont = love.graphics.newFont("Fonts/PerfectDOSVGA437.ttf", 27)
            love.graphics.setFont(menuFont)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(stage.text or "Unknown", sW / 2 - 150, sH / 2 - 80, 300, "center")

            if stage.price then
                menuFont = love.graphics.newFont("Fonts/PerfectDOSVGA437.ttf", 20)
                love.graphics.setFont(menuFont)
                love.graphics.printf("SOLS Required: " .. stage.price, sW / 2 - 150, sH / 2 - 35, 300, "center")
            end
        end
    end
end

function BuyMenu.updateHover(mouseX, mouseY)
    for _, button in ipairs(buttons) do
        button.isHovered =
            mouseX >= button.x and mouseX <= button.x + button.width and
            mouseY >= button.y and mouseY <= button.y + button.height
    end
end

function BuyMenu.getHover(index)
    return buttons[index] and buttons[index].isHovered
end

function BuyMenu.mousepressed(mouseX, mouseY, mouseButton)
    if mouseButton ~= 1 then return end

    for i, button in ipairs(buttons) do
        if mouseX >= button.x and mouseX <= button.x + button.width and
            mouseY >= button.y and mouseY <= button.y + button.height then
            local stage = button.stages[button.currentStage]
            if stage.maxed then return end
            if score >= (stage.price or 0) then
                Music.PlayActivateButton()
                score = score - stage.price

                if i == 1 then
                    dotsToAdd = dotsToAdd + stage.effect
                elseif i == 2 then
                    solsPerSecond = solsPerSecond + stage.effect
                elseif i == 3 then
                    Music.PlayReggaeLoop()
                elseif i == 4 then
                    -- Placeholder for cursor effect
                end

                if button.currentStage < #button.stages then
                    button.currentStage = button.currentStage + 1
                end
            end
        end
    end
end

return BuyMenu
