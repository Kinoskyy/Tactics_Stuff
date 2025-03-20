addEventHandler("onPlayerDamage", root,
function(attacker, weapon)
	if attacker and getElementType(attacker) == "player" and attacker ~= source then
		triggerClientEvent(attacker, "onDMG", attacker, attacker, weapon)
	end
end)

local validWeapons = {
    [16] = true, -- Grenade
    [23] = true, -- Silenced
    [24] = true, -- Deagle
    [25] = true, -- Shotgun
    [26] = true, -- Sawed-off
    [27] = true, -- Combat Shotgun
    [28] = true, -- Uzi
    [30] = true, -- AK-47
    [31] = true, -- M4
    [33] = true, -- Rifle
    [34] = true, -- Sniper
}

addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart, loss)
    if attacker and attacker ~= source and validWeapons[weapon] then
        local iconType = (getPedArmor(source) > 0) and "armour" or "health"
        triggerClientEvent(attacker, "createIconOnPlayer", resourceRoot, source, iconType)
    end
end)