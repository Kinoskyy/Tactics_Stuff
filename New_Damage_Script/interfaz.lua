local screenW, screenH = guiGetScreenSize()
local damageList = {}
local hitList = {}
local futuraFont = dxCreateFont("futura.ttf", 10) or "default"
local scale = screenW / 1920
local displayTime = 3000

function fadeHitOverlays()
    local currentTime = getTickCount()

    for i = #damageList, 1, -1 do
        local entry = damageList[i]
        if currentTime - entry.lastUpdate >= displayTime then
            table.remove(damageList, i)
        end
    end

    for i = #hitList, 1, -1 do
        local entry = hitList[i]
        if currentTime - entry.lastUpdate >= displayTime then
            table.remove(hitList, i)
        end
    end
end

function drawHitTexts()
    local attacked = Vector2(screenW - (500 * scale), screenH - (200 * scale))
    for i, entry in ipairs(damageList) do
        local weaponName = getWeaponNameFromID(entry.weapon) or "Desconocido"
        local damageText = entry.damageText
        local attackerName = removeColorCodes(entry.name) or "Desconocido"
        local text = string.format("%s - %s - %s", damageText, weaponName, attackerName)
        dxDrawShadowText(text, attacked.x, attacked.y, _, _, tocolor(255, 0, 0, 255), 1, futuraFont, "right")
        attacked = attacked + Vector2(0, 30 * scale)
    end

    local received = Vector2(500 * scale, screenH - 200 * scale)
    for i, entry in ipairs(hitList) do
        local weaponName = getWeaponNameFromID(entry.weapon) or "Desconocido"
        local damageText = entry.damageText
        local victimName = removeColorCodes(entry.name) or "Desconocido"
        local text = string.format("%s + %s + %s", victimName, weaponName, damageText)
        dxDrawShadowText(text, received.x, received.y, _, _, tocolor(0, 160, 0, 255), 1, futuraFont, "left")
        received = received + Vector2(0, 20 * scale)
    end
end

function removeColorCodes(text)
    return text and text:gsub("#%x%x%x%x%x%x", "") or ""
end

function dxDrawShadowText(text, x, y, t, r, color, scale, font, alignx, aligny, ...)
    dxDrawText(text, x + 1, y + 1, _, _, tocolor(0, 0, 0, 255), scale, font, alignx, aligny, ...)
    dxDrawText(text, x, y, _, _, color, scale, font, alignx, aligny, ...)
end

function onPlayerDamage(attacker, weapon, bodypart, loss)
    if not wasEventCancelled() then
        local found = false
        for i, entry in ipairs(damageList) do
            if entry.attacker == attacker and entry.weapon == weapon then
                entry.damage = entry.damage + loss
                entry.damageText = string.format("%.2f", entry.damage)
                entry.lastUpdate = getTickCount()
                found = true
                break
            end
        end

        if not found then
            if #damageList >= 4 then
                table.remove(damageList, #damageList)
            end

            local name = "Self"
            if attacker and attacker ~= localPlayer and getElementType(attacker) == "player" then
                name = removeColorCodes(getPlayerName(attacker))
            end

            table.insert(damageList, 1, {
                attacker = attacker,
                weapon = weapon,
                damage = loss,
                lastUpdate = getTickCount(),
                name = name,
                damageText = string.format("%.2f", loss)
            })
        end
    end
end

function onClientPlayerHit(attacker, weapon, bodypart, loss)
    if attacker and attacker == localPlayer and source ~= localPlayer then
        local found = false
        for i, entry in ipairs(hitList) do
            if entry.victim == source and entry.weapon == weapon then
                entry.damage = entry.damage + loss
                entry.damageText = string.format("%.2f", entry.damage)
                entry.lastUpdate = getTickCount()
                found = true
                break
            end
        end

        if not found then
            if #hitList >= 4 then
                table.remove(hitList, #hitList)
            end

            table.insert(hitList, 1, {
                victim = source,
                weapon = weapon,
                damage = loss,
                lastUpdate = getTickCount(),
                name = removeColorCodes(getPlayerName(source)),
                damageText = string.format("%.2f", loss)
            })
        end
    end
end

function onPlayerWasted(attacker, weapon, bodypart)
    if source == localPlayer and damageList[1] and damageList[1].attacker == attacker and damageList[1].weapon == weapon then
        damageList[1].damageText = "Wasted"
        damageList[1].lastUpdate = getTickCount()
    elseif attacker == localPlayer and hitList[1] and hitList[1].victim == source and hitList[1].weapon == weapon then
        hitList[1].damageText = "Kill"
        hitList[1].lastUpdate = getTickCount()
    end
end

function onClientPlayerFallDamage(loss)
    table.insert(damageList, 1, {
        attacker = localPlayer,
        weapon = 54,
        damage = loss,
        lastUpdate = getTickCount(),
        name = "Fall",
        damageText = string.format("%.2f", loss)
    })
end

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon, bodypart, loss)
    if weapon == 54 then
        onClientPlayerFallDamage(loss)
    else
        onPlayerDamage(attacker, weapon, bodypart, loss)
    end
end)

setTimer(fadeHitOverlays, 50, 0)
addEventHandler("onClientPreRender", root, drawHitTexts)
addEventHandler("onClientPlayerHit", root, onClientPlayerHit)
addEventHandler("onClientPlayerWasted", root, onPlayerWasted)