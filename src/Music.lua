local Music = {}
local ripple = require "Libraries/ripple"

function Music.load()

--SOUNDS

    local buttonHoverPingSource = love.audio.newSource("Sounds/buttonHoverPing.wav", "stream")
    Music.buttonHoverPing = ripple.newSound(buttonHoverPingSource, {
        volume = 0.6,
        loop = false
    })

    local menuExitBassSource = love.audio.newSource("Sounds/menuExitBass.wav", "stream")
    Music.menuExitBass = ripple.newSound(menuExitBassSource, {
        volume = 0.35,
        loop = false
    })

    local openMenuSoundSource = love.audio.newSource("Sounds/openMenuSound.wav", "stream")
    Music.openMenuSound = ripple.newSound(openMenuSoundSource, {
        volume = 0.9,
        loop = false
    })

    local activateButtonSound = love.audio.newSource("Sounds/activateButton.wav", "stream")
    Music.activateButtonSound = ripple.newSound(activateButtonSound, {
        volume = 0.65,
        loop = false
    })



--MUSIC

    local reggaeLoopSource = love.audio.newSource("Music/reggae_loop.wav", "stream")
    Music.reggaeLoop = ripple.newSound(reggaeLoopSource, {
        volume = 0.4,
        loop = true
    })

end



function Music.PlayButtonHoverPing()
    Music.buttonHoverPing:play()
end

function Music.PlayMenuExitBass()
    Music.menuExitBass:play()
end

function Music.PlayOpenMenu()
    Music.openMenuSound:play()
end

function Music.PlayReggaeLoop()
    Music.reggaeLoop:play()
end

function Music.PlayActivateButton()
  Music.activateButtonSound:play()
end


return Music
