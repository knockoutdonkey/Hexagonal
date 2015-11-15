grenadeToss = {}
setmetatable(grenadeToss, Attack)

function grenadeToss:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/grenadeTossIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 4

  return obj
end

-- able to hit all
function grenadeToss:getRange()
  return self.unit.coord:getAllWithin(2, 1)
end

function grenadeToss:perform(tile)
  if not tile.item and not tile:hasWater() then
    tile.item = Grenade:new(tile.coord, self.damage, 2)
    return true
  end
  return false
end

return grenadeToss