local messages = {}
local sW, sH = guiGetScreenSize()
local duration = 10000
local fadeTime = 1000
local drawMarginRight = 0.01
local drawMarginBottom = 0.35
local displayLines = 5

addEvent("createIconOnPlayer", true)
addEventHandler("createIconOnPlayer", resourceRoot, function(datos)
end)

function outputMessage(new)
    if (type(new) == "string") then
        new = {
            victim = {
                text = new,
                color = {255, 255, 255},
            },
        }
    end

    new.initTick = getTickCount()

    if new.icon and new.icon.path and fileExists(new.icon.path) then
        new.icon.texture = dxCreateTexture(new.icon.path)
    end

    table.insert(messages, new)

    local quantity = #messages

    if (quantity == 1) then
        addEventHandler("onClientRender", root, renderMessages)
    elseif (quantity > displayLines) then
        table.remove(messages, 1)
    end

    return true
end
addEvent("doOutputMessage", true)
addEventHandler("doOutputMessage", resourceRoot, outputMessage)

function renderMessages()
    local now = getTickCount()
    local lineHeight = 20
    local font = "default-bold"
    local y = sH - (sH * drawMarginBottom)
    local padding = 2 

    for k = #messages, 1, -1 do
        local v = messages[k]
        if v then
            local passed = now - v.initTick
            if (passed <= duration) then
                local alpha = 255

                if (passed <= fadeTime) then
                    alpha = 255 * passed / math.max(1, fadeTime)
                elseif (passed >= (duration - fadeTime)) then
                    alpha = 255 - 255 * ((now - duration + fadeTime) - v.initTick) / math.max(1, fadeTime)
                end

                local victim = v.victim
                local victimText = victim.text
                local victimColor = victim.color
                victimColor = tocolor(victimColor[1], victimColor[2], victimColor[3], alpha)
                local victimWidth = dxGetTextSize(victimText, 0, 1, 1, font, false, true)
                local x = sW - (sW * drawMarginRight) - victimWidth
                local totalWidth = victimWidth
                local icon = v.icon
                if icon and type(icon.width) == "number" then
                    totalWidth = totalWidth + padding + icon.width
                end

                local killer = v.killer
                local killerWidth = 0
                if killer then
                    local killerText = killer.text
                    killerWidth = dxGetTextSize(killerText, 0, 1, 1, font, false, true)
                    totalWidth = totalWidth + padding + killerWidth
                end

                local extraWidth = 10 
                local rectWidth = totalWidth + 2 * padding + extraWidth 
                local rectX = x - padding - (icon and icon.width or 0) - (killer and killerWidth or 0) - 10 
                local rectY = y - padding
                local rectHeight = lineHeight + 2 * padding 
                local borderColor
                
                if killer then
                    local killerTeam = getPlayerTeam(killer)
                    if killerTeam then
                        local r, g, b = getTeamColor(killerTeam)
                        borderColor = tocolor(r, g, b, alpha)
                    else
                        borderColor = tocolor(killer.color[1], killer.color[2], killer.color[3], alpha)
                    end
                else
                    borderColor = victimColor
                end

                dxDrawRectangle(rectX, rectY, rectWidth, rectHeight, tocolor(0, 0, 0, alpha * 0.5))
                
                local borderThickness = 1
                dxDrawRectangle(rectX - borderThickness, rectY - borderThickness, rectWidth + 2 * borderThickness, borderThickness, borderColor)
                dxDrawRectangle(rectX - borderThickness, rectY + rectHeight, rectWidth + 2 * borderThickness, borderThickness, borderColor) 
                dxDrawRectangle(rectX - borderThickness, rectY, borderThickness, rectHeight, borderColor)
                dxDrawRectangle(rectX + rectWidth, rectY, borderThickness, rectHeight, borderColor)
                dxDrawText(victimText, x + 2, y + 2, x + victimWidth, y + lineHeight, tocolor(0, 0, 0, alpha), 1, font, "center", "center")
                dxDrawText(victimText, x, y, x + victimWidth, y + lineHeight, victimColor, 1, font, "center", "center")

                if icon and icon.texture and isElement(icon.texture) then
                    local texture = icon.texture
                    local iconWidth = icon.width
                    x = x - padding - iconWidth
                    dxDrawImage(x, y, iconWidth, lineHeight, texture, 0, 0, 0, tocolor(255, 255, 255, alpha))
                end

                if killer then
                    local killerText = killer.text
                    local killerColor = killer.color
                    killerColor = tocolor(killerColor[1], killerColor[2], killerColor[3], alpha)
                    local killerWidth = dxGetTextSize(killerText, 0, 1, 1, font, false, true)
                    x = x - padding - killerWidth
                    dxDrawText(killerText, x + 2, y + 2, x + killerWidth, y + lineHeight, tocolor(0, 0, 0, alpha), 1, font, "center", "center")
                    dxDrawText(killerText, x, y, x + killerWidth, y + lineHeight, killerColor, 1, font, "center", "center")
                end
                y = y - lineHeight - padding - 10
            else
                
                if v.icon and v.icon.texture and isElement(v.icon.texture) then
                    destroyElement(v.icon.texture)
                    v.icon.texture = nil 
                end
                table.remove(messages, k)
                if (#messages == 0) then
                    removeEventHandler("onClientRender", root, renderMessages)
                end
            end
        end
    end
end