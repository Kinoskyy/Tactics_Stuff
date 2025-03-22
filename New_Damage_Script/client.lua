local root = getRootElement()
local resourceRoot = getResourceRootElement(getThisResource())
local localPlayer = getLocalPlayer()
local enableDingSound = true

function onClientPlayerHit(attacker, weapon, bodypart, loss)
    if enableDingSound and attacker ~= source and attacker == localPlayer and loss > 1 then
        playSound("campanota.mp3")
    end
end

function onClientPlayerDamage(attacker, weapon, bodypart, loss)
    if source == localPlayer and not wasEventCancelled() then
        triggerServerEvent("onPlayerReceiveDamage", localPlayer, attacker, weapon, bodypart, loss)
    end
end

addEvent("onClientPlayerHit", true)
addEventHandler("onClientPlayerHit", root, onClientPlayerHit)
addEventHandler("onClientPlayerDamage", root, onClientPlayerDamage)