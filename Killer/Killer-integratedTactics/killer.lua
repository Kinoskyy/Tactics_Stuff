local screenW, screenH = guiGetScreenSize()
local font = dxCreateFont("verdana.ttf", 80)
local showKiller = false
local killMessagesList = {}
local killerTimer = nil
local killMessages = {
    "#E70000You Took #FFFFFF%s#E70000's Life",
    "#E70000You Ate #FFFFFF%s#E70000's Ass",
    "#E70000You Sent #FFFFFF%s#E70000 to Cemetery",
    "#E70000You Owned #FFFFFF%s",
    "#E70000You Raped #FFFFFF%s",
    "#E70000You Eliminated #FFFFFF%s",
    "#E70000You Defeated #FFFFFF%s",
    "#E70000You Killed #FFFFFF%s"
}
local deathMessages = {
    "#E70000Killed By #FFFFFF%s",
    "#E70000Annihilated By #FFFFFF%s",
    "#E70000Owned By #FFFFFF%s",
    "#E70000Defeated By #FFFFFF%s",
    "#E70000Eliminated By #FFFFFF%s",
    "#E70000Sent to Cemetery By #FFFFFF%s",
    "#E70000Raped By #FFFFFF%s",
    "#E70000Destroyed By #FFFFFF%s",
    "#E70000Humiliated By #FFFFFF%s"
}

function removeColorCodes(text)
    return string.gsub(text, "#%x%x%x%x%x%x", "")
end

addEvent("showKiller", true)
addEventHandler("showKiller", root, function(victim)
    if #killMessagesList >= 5 then table.remove(killMessagesList, 1) end
    local killer = string.gsub(getPlayerName(victim), '#%x%x%x%x%x%x', '')
    local randomMessage = killMessages[math.random(1, #killMessages)]
    local formattedMessage = string.format(randomMessage, killer)
    table.insert(killMessagesList, formattedMessage)
    showKiller = true
    if isTimer(killerTimer) then killTimer(killerTimer) end
    killerTimer = setTimer(function() showKiller = false killMessagesList = {} end, 4000, 1)
end)

addEventHandler("onClientPlayerWasted", localPlayer, function(killer)
    if killer and killer ~= localPlayer then
        if #killMessagesList >= 5 then table.remove(killMessagesList, 1) end
        local killerName = string.gsub(getPlayerName(killer), '#%x%x%x%x%x%x', '')
        local randomMessage = deathMessages[math.random(1, #deathMessages)]
        local formattedMessage = string.format(randomMessage, killerName)
        table.insert(killMessagesList, formattedMessage)
        showKiller = true
        if isTimer(killerTimer) then killTimer(killerTimer) end
        killerTimer = setTimer(function() showKiller = false killMessagesList = {} end, 4000, 1)
    end
end)

function drawKillerMessage()
    if showKiller and #killMessagesList > 0 then
        local startY = screenH * 0.8300
        local offsetY = screenH * 0.025
        for i, message in ipairs(killMessagesList) do
            local shadowText = removeColorCodes(message)
            local textWidth = dxGetTextWidth(shadowText, screenH / 6000, font)
            local textHeight = dxGetFontHeight(screenH / 6000, font)
            local x = (screenW - textWidth) / 2
            local y = startY + (i - 1) * offsetY
            dxDrawText(shadowText, x + 1, y + 1, screenW, y + textHeight + 2, tocolor(0, 0, 0, 255), screenH / 6000, font, "left", "top", false, false, false, false, false)
            dxDrawText(message, x, y, screenW, y + textHeight, tocolor(255, 255, 255, 200), screenH / 6000, font, "left", "top", false, false, false, true, false)
        end
    end
end
addEventHandler("onClientRender", root, drawKillerMessage)