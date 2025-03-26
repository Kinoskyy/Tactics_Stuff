addEventHandler("onPlayerWasted", root, function(_, k)
    if isElement(k) and getElementType(k) == "player" then
        triggerClientEvent(k, "showKiller", k, source)
    end
end)
