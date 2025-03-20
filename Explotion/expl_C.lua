addEvent( "explodeBody", true )
addEventHandler( "explodeBody", getRootElement(), 
function(x,y,z) 
	createExplosion ( x,y,z, 12, false, 0, false)
end)