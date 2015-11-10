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
  return {self.unit.coord}
end

function Outpost:perform(tile)
  if self.unit.ready then
    tile:raise()
    self.unit:endTurn()
    return true
  else
    return false
  end
end

return Outpost