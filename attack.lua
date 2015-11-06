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

function Attack:getRange()
  local x = obj.unit.x
  local y = obj.unit.y

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
  love.graphics.setColor(255, 0, 0, 0)
  love.graphics.rectangle(x - 30, y - 30, 30, 30)
end

return Attack