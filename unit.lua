local Unit = {}

Unit.selected = nil

function Unit:new(x, y, color)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  -- Don't create a Unit if there is already something at that location
  if World.instance:get(x, y).item then
    print('Unit could not be placed')
    return false
  end

  World.instance:get(x, y).item = obj

  obj.x = x
  obj.y = y
  obj.color = color
  obj.moveRange = 5
  obj.jumpRange = 1

  obj.ready = true

  return obj
end

--TODO: check for hit collision before moving
function Unit:move(dX, dY)
  self:moveTo(self.x + dX, self.y + dY)
end

function Unit:moveTo(x, y)
  local newTile = World.instance:get(x, y)
  local oldTile = World.instance:get(self.x, self.y)
  if not newTile.blocking and not newTile.item and self.ready then

    self.x = x
    self.y = y

    oldTile.item = nil
    newTile.item = self

    self.ready = false
  end
end

function Unit:select()

  World.instance:unhighlight()
  if Unit.selected == self then
    Unit.selected = nil
  else
    Unit.selected = self

    function highlight(x, y, distanceLeft)
      local tile = World.instance:get(x,y)
      if distanceLeft < 0 or tile.blocking then
        return
      end

      tile.highlighted = true

      -- highlight all neighbors
      local nextCoords = {
        {dX= 0, dY= 1},
        {dX= 1, dY= 0},
        {dX= 1, dY=-1},
        {dX= 0, dY=-1},
        {dX=-1, dY= 0},
        {dX=-1, dY= 1}
      }

      for i, coord in ipairs(nextCoords) do
        local nextTile = World.instance:get(x + coord.dX, y + coord.dY)
        if math.abs(tile.height - nextTile.height) <= self.jumpRange then
          highlight(x + coord.dX, y + coord.dY, distanceLeft - 1)
        end
      end
    end

    highlight(self.x, self.y, self.moveRange)
  end
end

function Unit:draw()

  -- Set the unit color
  if self.color == 'yellow' then
    if self.ready then
      love.graphics.setColor(220, 255, 40, 255)
    else
      love.graphics.setColor(190, 225, 80, 255)
    end
  else
    if self.ready then
      love.graphics.setColor(255, 50, 50, 255)
    else
      love.graphics.setColor(200, 100, 100, 255)
    end
  end

  -- Draw the player
  pixelX, pixelY = World.instance:transformToPixels(self.x, self.y)
  love.graphics.circle("fill", pixelX, pixelY - math.sqrt(1 - Tile.tilt * Tile.tilt) * 15, 15)

  -- Draw selected border
  if Unit.selected == self then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", pixelX, pixelY - math.sqrt(1 - Tile.tilt * Tile.tilt) * 15, 15)
  end
end

return Unit