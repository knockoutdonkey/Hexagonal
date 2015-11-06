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
  obj.moveRange = 3
  obj.jumpRange = 1

  obj.maxHealth = 10
  obj.health = obj.maxHealth

  obj.attacks = {Attack:new(self), Attack:new(self)}

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
  if not newTile.blocking and not newTile.item and self.ready and newTile.highlighted then

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

      if tile.item and tile.item.color ~= self.color then
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
      love.graphics.setColor(160, 180, 100, 255)
    end
  else
    if self.ready then
      love.graphics.setColor(255, 50, 50, 255)
    else
      love.graphics.setColor(170, 100, 100, 255)
    end
  end

  -- Draw the player
  pixelX, pixelY = World.instance:transformToPixels(self.x, self.y)
  local playerRadius = 15
  love.graphics.circle("fill", pixelX, pixelY - math.sqrt(1 - Tile.tilt * Tile.tilt) * playerRadius, playerRadius)

  -- Draw the health bar
  local healthLength = 30
  local healthHeight = 5
  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.rectangle("fill", pixelX - healthLength / 2, pixelY - healthHeight / 2 - playerRadius * (1.4 + math.sqrt(1 - Tile.tilt * Tile.tilt)), healthLength * self.health / self.maxHealth , healthHeight)
end

return Unit