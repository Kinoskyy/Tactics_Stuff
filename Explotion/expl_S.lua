addEventHandler( "onPlayerWasted", getRootElement(), 
function(_,killer) 
	if(killer) then playSoundFrontEnd ( killer,40 ) end	
	local x,y,z = getElementPosition(source)
	triggerClientEvent("explodeBody", getRootElement(), x,y,z)
end)