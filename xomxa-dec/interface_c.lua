local screenW, screenH = guiGetScreenSize()
local damageList = {} 
local hitList = {}

function fadeHitOverlays()
    for i, entry in ipairs(damageList) do
        entry.visibility = entry.visibility - 2
        if entry.visibility <= 0 then
            table.remove(damageList, i)
        end
    end

    for i, entry in ipairs(hitList) do
        entry.visibility = entry.visibility - 2
        if entry.visibility <= 0 then
            table.remove(hitList, i)
        end
    end
end

function drawHitTexts()
    for i, entry in ipairs(damageList) do
        local x = math.floor(screenW * 339 / 640 - 75 * screenW / 640 - 1)
        local y = math.floor(screenH * 192 / 480 - 15 * screenH / 480 * (i - 1) - 1)
        local weaponIcon = "images/weapons/" .. getWeaponNameFromID(entry.weapon) .. ".png"

        dxDrawText(entry.damageText, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "bottom")
        dxDrawText(entry.damageText, x, y, x, y, tocolor(217, 54, 0, 255), 1, "default-bold", "right", "bottom")
        x = x - 6 - 16 - dxGetTextWidth(entry.damageText)
        dxDrawImage(x, y - 16 + (16 - dxGetFontHeight()) / 2, 16, 16, weaponIcon, 0, 0, 0, tocolor(255, 255, 255, 255))
        x = x - 6
        dxDrawText(entry.name, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "bottom")
        dxDrawText(entry.name, x, y, x, y, tocolor(217, 54, 0, 255), 1, "default-bold", "right", "bottom")
    end

    for i, entry in ipairs(hitList) do
        local x = math.floor(screenW * 0.5296875 + 75 * screenW / 640 + 1)
        local y = math.floor(screenH * 0.4 + 15 * screenH / 480 * (i - 1) + 1)
        local weaponIcon = "images/weapons/" .. getWeaponNameFromID(entry.weapon) .. ".png"

        dxDrawText(entry.damageText, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "left", "top")
        dxDrawText(entry.damageText, x, y, x, y, tocolor(102, 204, 51, 255), 1, "default-bold", "left", "top")
        x = x + 6 + dxGetTextWidth(entry.damageText)
        dxDrawImage(x, y - (16 - dxGetFontHeight()) / 2, 16, 16, weaponIcon, 0, 0, 0, tocolor(255, 255, 255, 255))
        x = x + 16 + 6
        dxDrawText(entry.name, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0, 255), 1, "default-bold", "left", "top")
        dxDrawText(entry.name, x, y, x, y, tocolor(102, 204, 51, 255), 1, "default-bold", "left", "top")
    end
end

function onPlayerDamage(attacker, weapon, bodypart, loss)
    if not wasEventCancelled() then
        if damageList[1] and not damageList[1].noAdd and damageList[1].attacker == attacker and damageList[1].weapon == weapon then
            damageList[1].damage = damageList[1].damage + loss
            damageList[1].visibility = 255
            if attacker and getElementType(attacker) == "vehicle" then
                attacker = getVehicleController(attacker)
            end
            damageList[1].name = (attacker and attacker ~= localPlayer) and getPlayerName(attacker) or ""
            damageList[1].damageText = "- " .. string.format("%.2f", damageList[1].damage)
        else
            table.remove(damageList, 5)
            table.insert(damageList, 1, {
                attacker = attacker,
                weapon = weapon,
                damage = loss,
                visibility = 255,
                name = (attacker and getElementType(attacker) == "player" and attacker ~= localPlayer) and getPlayerName(attacker) or "",
                damageText = "- " .. string.format("%.2f", loss)
            })
        end
    end
end

function onPlayerHit(attacker, weapon, bodypart, loss)
    if attacker ~= source and attacker == localPlayer then
        if hitList[1] and not hitList[1].noAdd and hitList[1].victim == source and hitList[1].weapon == weapon then
            hitList[1].damage = hitList[1].damage + loss
            hitList[1].visibility = 255
            hitList[1].name = getPlayerName(source)
            hitList[1].damageText = "+ " .. string.format("%.2f", hitList[1].damage)
        else
            table.remove(hitList, 5)
            table.insert(hitList, 1, {
                victim = source,
                weapon = weapon,
                damage = loss,
                visibility = 255,
                name = getPlayerName(source),
                damageText = "+ " .. string.format("%.2f", loss)
            })
        end
    end
end

function onPlayerWasted(attacker, weapon, bodypart)
    if source == localPlayer and damageList[1] and damageList[1].attacker == attacker and damageList[1].weapon == weapon then
        damageList[1].damageText = damageList[1].damageText .. " (wasted)"
        damageList[1].noAdd = true
    elseif attacker == localPlayer and hitList[1] and hitList[1].victim == source and hitList[1].weapon == weapon then
        hitList[1].damageText = "(kill) " .. hitList[1].damageText
        hitList[1].noAdd = true
    end
end

setTimer(fadeHitOverlays, 50, 0)
addEventHandler("onClientPreRender", root, drawHitTexts)
addEventHandler("onClientPlayerDamage", localPlayer, onPlayerDamage)
addEventHandler("onClientPlayerHit", root, onPlayerHit)
addEventHandler("onClientPlayerWasted", root, onPlayerWasted)

local copyrightAlpha = 255
local copyrightTimer = nil

function fadeCopyright()
    copyrightAlpha = copyrightAlpha - 2
    if copyrightAlpha <= 0 then
        removeEventHandler("onClientRender", root, drawCopyright)
        killTimer(copyrightTimer)
    end
end

function drawCopyright()
    local y = screenH - 30
    local x = screenW - 5
    dxDrawText("Damage script decompiled by Kinoskyy", x + 2, y - 16, x + 2, y - 16, tocolor(0, 0, 0, 255), 1, "default-bold", "right", "top")
    dxDrawText("Damage script decompiled by Kinoskyy", x + 1, y - 15, x + 1, y - 15, tocolor(255, 0, 255, copyrightAlpha), 1, "default-bold", "right", "top")
end
copyrightTimer = setTimer(fadeCopyright, 50, 0)
addEventHandler("onClientRender", root, drawCopyright)