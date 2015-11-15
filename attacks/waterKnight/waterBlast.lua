WaterBlast = {}
setmetatable(WaterBlast, Attack)

function WaterBlast:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/WaterBlastIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 2

  return obj
end

-- able to hit all
function WaterBlast:getRange()
  return self.unit.coord:getAllWithin(3, 1)
end

function WaterBlast:perform(tile)
  local unit = tile.unit
  if unit then
    unit:damage(self.damage)

    local direction = self.unit.coord:getDirectionTo(tile.coord)
    unit:place(unit.coord:add(direction))
    return true
  end

  return false
end

return WaterBlast