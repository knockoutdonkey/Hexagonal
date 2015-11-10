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
  local unit = tile.item
  if unit then
    unit:damage(self.damage)
    return true
  else
    return false
  end
end

function Attack:getRange()
  local x = self.unit.x
  local y = self.unit.y

  return {
    {x=x  , y=y+1},
    {x=x+1, y=y  },
    {x=x+1, y=y-1},
    {x=x  , y=y-1},
    {x=x-1, y=y  },
    {x=x-1, y=y+1}
  }
end

function Attack:draw(x, y)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", x - 30, y - 30, 60, 60)
end

return Attack