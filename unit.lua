local Unit = {}

Unit.selected = nil

function Unit:new(coord, color)

  -- Class setup
  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  -- Don't create a Unit if there is already something at that location
  if World.instance:get(coord).item then
    print('Unit could not be placed')
    return false
  end

  World.instance:get(coord).item = obj

  obj.coord = coord:copy()
  obj.color = color

  -- These are unique to this unit
  obj.moveRange = 3
  obj.jumpRange = 1
  obj.maxHealth = 10
  obj.attacks = {Attack:new(obj), Attack:new(obj)}

  obj:setUp()

  return obj
end

function Unit:setUp()
  self.health = self.maxHealth
  self.movesLeft = self.moveRange
  self.ready = true
end

function Unit:startTurn()
  self.movesLeft = self.moveRange
  self.ready = true
end

function Unit:endTurn()
  self.movesLeft = 0
  self.ready = false
end

--TODO: check for hit collision before moving
function Unit:move(deltaCoord)
  self:moveTo(self.coord:add(deltaCoord))
end

function Unit:moveTo(nextCoord)
  local newTile = World.instance:get(nextCoord)
  local oldTile = World.instance:get(self.coord)
  if not newTile.blocking and not newTile.item and newTile.highlighted and self.movesLeft and self.ready then

    self.movesLeft = self.movesLeft - self.coord:getDistance(nextCoord)
    self.coord = nextCoord:copy()

    oldTile.item = nil
    newTile.item = self
  end
end

function Unit:select()
  World.instance:unhighlight()
  if Unit.selected == self then
    Unit.selected = nil
  else
    Unit.selected = self

    function highlight(coord, distanceLeft)
      local tile = World.instance:get(coord)
      if distanceLeft < 0 or tile.blocking then
        return
      end

      if tile.item and tile.item.color ~= self.color then
        return
      end

      tile.highlighted = true

      for i, neighborCoord in ipairs(coord:getNeighbors()) do
        local nextTile = World.instance:get(neighborCoord)
        if math.abs(tile.height - nextTile.height) <= self.jumpRange then
          highlight(neighborCoord, distanceLeft - 1)
        end
      end
    end

    highlight(self.coord, self.movesLeft)
  end
end

function Unit:damage(damage)
  self.health = self.health - damage
  if self.health <= 0 then
    self.health = 0
    self:kill()
  end
end

function Unit:kill()
  print('Oh no', self.coord.x, self.coord.y, 'is dead')
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
  pixelX, pixelY = World.instance:transformToPixels(self.coord)
  local playerRadius = 15
  love.graphics.circle("fill", pixelX, pixelY - math.sqrt(1 - Tile.tilt * Tile.tilt) * playerRadius, playerRadius)

  -- Draw the health bar
  local healthLength = 30
  local healthHeight = 5
  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.rectangle("fill", pixelX - healthLength / 2, pixelY - healthHeight / 2 - playerRadius * (1.4 + math.sqrt(1 - Tile.tilt * Tile.tilt)), healthLength * self.health / self.maxHealth , healthHeight)
end

function Unit:drawAttacks()
  for i, attack in ipairs(self.attacks) do
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local attackBorder = 70

    attack:draw(attackBorder * i - screenWidth / 2, screenHeight / 2 - attackBorder)
  end
end

return Unit