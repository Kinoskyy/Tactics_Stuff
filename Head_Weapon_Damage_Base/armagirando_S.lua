addEventHandler("onPlayerDamage", root,
function(attacker, weapon)
	if attacker and getElementType(attacker) == "player" and attacker ~= source then
		triggerClientEvent(attacker, "onDMG", attacker, attacker, weapon)
	end
end)