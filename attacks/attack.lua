local Attack = {}

function Attack:new(unit)

  -- Class setup
  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.unit = unit

  -- This is unique to this attack
  obj.damage = 3

  return obj
end

-- OVERWRITE to provide a different attack range
-- Returns an array valid hexCoord locations
function Attack:getRange()
  return self.unit.coord:getNeighbors()
end

-- OVERWRITE to provide a different attack behavior
-- Returns whether or not the attack did anything
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

function Attack:draw(pX, pY)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", pX - 30, pY - 30, 60, 60)
end

return Attack