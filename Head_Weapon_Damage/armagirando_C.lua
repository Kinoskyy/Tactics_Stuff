local floatingWeapons = {}
local weaponTimers = {}
local iconObjects = {}
local rotation = 0
local rotationSpeed = 2 
local showDuration = 1750 
local icons = {
    armour = {model = 1242, texture = nil},
    health = {model = 1240, texture = nil}
}

local weaponModels = {
  [1] = 331, [2] = 333, [3] = 334, [4] = 335, [5] = 336, [6] = 337, [7] = 338,
  [8] = 339, [9] = 341, [10] = 321, [11] = 322, [12] = 323, [14] = 325,
  [15] = 326, [16] = 342, [17] = 343, [18] = 344, [22] = 346, [23] = 347,
  [24] = 348, [25] = 349, [26] = 350, [27] = 351, [28] = 352, [29] = 353,
  [30] = 355, [31] = 356, [32] = 372, [33] = 357, [34] = 358, [35] = 359,
  [36] = 360, [37] = 361, [38] = 362, [39] = 363, [40] = 364, [41] = 365,
  [42] = 366
}

addEvent("onDMG", true)
addEventHandler("onDMG", root, function(attacker, weaponID)
  if not isElement(attacker) then return end
  local modelID = weaponModels[weaponID]
  if not modelID then return end

  if isElement(floatingWeapons[attacker]) then
    destroyElement(floatingWeapons[attacker])
    floatingWeapons[attacker] = nil
  end

  local x, y, z = getElementPosition(attacker)
  floatingWeapons[attacker] = createObject(modelID, x, y, z + 1.2)
  setElementCollisionsEnabled(floatingWeapons[attacker], false)

  if isTimer(weaponTimers[attacker]) then
    killTimer(weaponTimers[attacker])
  end

  weaponTimers[attacker] = setTimer(function(player)
    if isElement(floatingWeapons[player]) then
      destroyElement(floatingWeapons[player])
      floatingWeapons[player] = nil
    end
  end, 6000, 1, attacker)
end)

addEventHandler("onClientPreRender", root, function()
  for player, weaponObject in pairs(floatingWeapons) do
    if isElement(player) and isElement(weaponObject) then
      local x, y, z = getElementPosition(player)
      local rx, ry, rz = getElementRotation(weaponObject)
      setElementPosition(weaponObject, x, y, z + 1.15)
      setElementRotation(weaponObject, rx, ry, rz + 5)
      setElementInterior(weaponObject, getElementInterior(player))
      setElementDimension(weaponObject, getElementDimension(player))
    else
      floatingWeapons[player] = nil
    end
  end
end)

function createIcon(player, iconType)
    if not player or not iconType then return end
    if iconObjects[player] then
        destroyElement(iconObjects[player])
        iconObjects[player] = nil
    end
    
    local modelID = icons[iconType].model
    local texture = icons[iconType].texture
    local x, y, z = getElementPosition(player)
    local obj = createObject(modelID, x, y, z + 1.15)

    if obj then
        setElementCollisionsEnabled(obj, false)
        setObjectScale(obj, 1)
        setElementPosition(obj, x, y, z + 1.15)
        setElementParent(obj, player)
        setElementInterior(obj, getElementInterior(player))
        setElementDimension(obj, getElementDimension(player))
        iconObjects[player] = obj
        setTimer(function()
            if isElement(obj) then
                destroyElement(obj)
                iconObjects[player] = nil
            end
        end, showDuration, 1)
    end
end

function updateIconRotation()
    if isKeyPressed("a") then
        rotation = rotation - rotationSpeed
    elseif isKeyPressed("d") then
        rotation = rotation + rotationSpeed
    end
    if rotation > 360 then rotation = rotation - 360 end
    if rotation < 0 then rotation = rotation + 360 end
    for player, obj in pairs(iconObjects) do
        if isElement(obj) then
            local x, y, z = getElementPosition(player)
            setElementPosition(obj, x, y, z + 1.15)
            setElementRotation(obj, 0, 0, rotation)
        end
    end
end

addEvent("createIconOnPlayer", true)
addEventHandler("createIconOnPlayer", root, function(player, iconType)
    createIcon(player, iconType)
end)

addEventHandler("onClientPlayerWasted", root, function()
    if iconObjects[source] then
        destroyElement(iconObjects[source])
        iconObjects[source] = nil
    end
end)

addEventHandler("onClientRender", root, updateIconRotation)
function isKeyPressed(key)
    return getKeyState(key)
end