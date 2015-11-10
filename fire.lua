local Fire = {}
setmetatable(Fire, Attack)

function Fire:new(unit)

  local obj = Attack:new(unit)
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 1

  return obj
end

-- shoots within a range of 3, but only in a clear line of sight
function Fire:getRange()
  -- create a hash of all possible in range tiles
  return self.unit.coord:getAllWithin(3, 1)

  -- iterate through hash and remove all tiles that are blocked (blocked if tiles in front are two higher)
end

return Fire