Outpost = {}
setmetatable(Outpost, Attack)

function Outpost:new(unit)

  local obj = Attack:new(unit)
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 0

  return obj
end

function Outpost:getRange()
  return self.unit.coord:getAllWithin(1, 0)
end

function Outpost:perform(tile)
  tile:raise()
  tile:raise()
  return true
end

return Outpost