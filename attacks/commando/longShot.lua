local LongShot = {}
setmetatable(LongShot, Attack)

function LongShot:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/LongShotIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 1

  return obj
end

-- shoots within a range of 3, but only in a clear line of sight
function LongShot:getRange()
  -- create a hash of all possible in range tiles
  return self.unit.coord:getAllWithin(5, 1)

  -- iterate through hash and remove all tiles that are blocked (blocked if tiles in front are two higher)
end

return LongShot