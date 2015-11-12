SelfDestruct = {}
setmetatable(SelfDestruct, Attack)

function SelfDestruct:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/SelfDestructIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 10

  return obj
end

-- able to hit all
function SelfDestruct:getRange()
  local neighbors = self.unit.coord:getAllWithin(2, 0)

  return neighbors
end

function SelfDestruct:perform(tile)
  self.unit.selfDestructing = true
  return true
end

return SelfDestruct