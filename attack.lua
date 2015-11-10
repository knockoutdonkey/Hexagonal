local Attack = {}

function Attack:new(unit)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.unit = unit

  obj.damage = 3
  obj.selected = false

  return obj
end

-- returns whether or not the attack did anything
function Attack:perform(tile)
  local targetUnit = tile.item
  if targetUnit and self.unit.ready then
    targetUnit:damage(self.damage)
    self.unit:endTurn()
    return true
  else
    return false
  end
end

function Attack:getRange()
  return self.unit.coord:getNeighbors()
end

function Attack:draw(pX, pY)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", pX - 30, pY - 30, 60, 60)
end

return Attack