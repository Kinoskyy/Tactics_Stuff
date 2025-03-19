local root = getRootElement()
local resourceRoot = getResourceRootElement(getThisResource())

function onDamageReceived(attacker, weapon, bodypart, loss)
    if not wasEventCancelled() then
        if attacker and getElementType(attacker) == "vehicle" then
            attacker = getVehicleController(attacker)
        end
        if attacker then
            triggerClientEvent(attacker, "onClientPlayerHit", source, attacker, weapon, bodypart, loss)
        end
    end
end

addEvent("onPlayerReceiveDamage", true)
addEventHandler("onPlayerReceiveDamage", root, onDamageReceived)