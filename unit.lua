local Unit = {}

function Unit:new(x, y, color)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  -- Don't create a Unit if there is already something at that location
  if World.instance.grid[x][y].item then
    print('Unit could not be placed')
    return false
  end

  World.instance.grid[x][y].item = obj

  obj.x = x
  obj.y = y
  obj.color = color

  return obj
end

--TODO: check for hit collision before moving
function Unit:move(dX, dY)
  World.instance.grid[self.x][self.y].item = nil

  self.x = self.x + dX
  self.y = self.y + dY

  World.instance.grid[self.x][self.y].item = self
end

function Unit:draw()

  -- Set the player color
  if self.color == 'yellow' then
    love.graphics.setColor(220, 255, 0, 255)
  else
    love.graphics.setColor(255, 50, 50, 255)
  end

  -- Draw the player
  pixelX, pixelY = World.instance:transformToPixels(self.x, self.y)
  love.graphics.circle("fill", pixelX, pixelY, 15)
end

return Unit