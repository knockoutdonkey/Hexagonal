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
-- Public
-- Returns an array valid hexCoord locations
function Attack:getRange()
  return self.unit.coord:getNeighbors()
end

-- OVERWRITE to provide a different attack behavior
-- Private
-- Returns whether or not the attack did anything
function Attack:perform(tile)
  local targetUnit = tile.item
  if targetUnit then
    targetUnit:damage(self.damage)
    return true
  else
    return false
  end
end

-- Public, should be called for attacks
function Attack:attack(tile)
  if not self.unit.ready then
    return false
  end

  local result = self:perform(tile)
  if result then
    self.unit:endTurn()
  end
  return result
end

function Attack:draw(pX, pY)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", pX - 30, pY - 30, 60, 60)
end

return Attack