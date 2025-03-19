local root = getRootElement()
local resourceRoot = getResourceRootElement(getThisResource())
local localPlayer = getLocalPlayer()
local enableDingSound = true

function onClientPlayerHit(attacker, weapon, bodypart, loss)
    if enableDingSound and attacker ~= source and attacker == localPlayer and loss > 1 then
        playSound("sounds/ding_a_ling.wav")
    end
end

function onClientPlayerDamage(attacker, weapon, bodypart, loss)
    if source == localPlayer and not wasEventCancelled() then
        triggerServerEvent("onPlayerReceiveDamage", localPlayer, attacker, weapon, bodypart, loss)
    end
end

--[[function toggleDingSound(command, state) -- BUGEADO
    if state then
        if state == "on" then
            enableDingSound = true
            outputChatBox("#FFC400* Sonido de golpe #66CC33activado", 255, 255, 255, true)
        elseif state == "off" then
            enableDingSound = false
            outputChatBox("#FFC400* Sonido de golpe #D93600desactivado", 255, 255, 255, true)
        end
    else
        enableDingSound = not enableDingSound 
        local status = enableDingSound and "#66CC33activado" or "#D93600desactivado"
        outputChatBox("#FFC400* Sonido de golpe " .. status, 255, 255, 255, true)
    end
end]]

addEvent("onClientPlayerHit", true)
addEventHandler("onClientPlayerHit", root, onClientPlayerHit)
addEventHandler("onClientPlayerDamage", root, onClientPlayerDamage)
--addCommandHandler("ding", toggleDingSound)
