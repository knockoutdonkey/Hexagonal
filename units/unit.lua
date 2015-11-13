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
  obj.image = love.graphics.newImage('assets/units/rabbit.png')

  obj.name = 'Unit'
  obj.moveRange = 3
  obj.jumpRange = 1
  obj.maxHealth = 10
  obj.attacks = {Attack:new(obj), Attack:new(obj), NoAttack:new(obj)}

  obj:setUp()

  return obj
end

function Unit:setUp()
  self.health = self.maxHealth
  self.movesLeft = self.moveRange
  self.ready = true

  self.image:setFilter('nearest', 'nearest')
end

function Unit:startTurn()
  self.movesLeft = self.moveRange
  self.ready = true
end

function Unit:endTurn()
  self.movesLeft = 0
  self.ready = false
end

-- TODO: check for hit collision before moving
function Unit:move(deltaCoord)
  self:moveTo(self.coord:add(deltaCoord))
end

function Unit:moveTo(nextCoord)
  local newTile = World.instance:get(nextCoord)
  local oldTile = World.instance:get(self.coord)
  if not newTile:getBlocking() and not newTile.item and newTile.highlighted and self.movesLeft and self.ready then

    self.movesLeft = self.movesLeft - self.coord:getDistance(nextCoord)
    self.coord = nextCoord:copy()

    oldTile.item = nil
    newTile.item = self

    return true
  end
  return false
end

function Unit:select()
  World.instance:unhighlight()
  if Unit.selected == self then
    Unit.selected = nil
  else
    Unit.selected = self

    function highlight(coord, distanceLeft)
      local tile = World.instance:get(coord)
      if distanceLeft < 0 or tile:getBlocking() then
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
  World.instance:removeUnit(self)
  World.instance:get(self.coord).item = nil
end

function Unit:draw()
  -- set team tinting
  if self.color == 'yellow' then
    if self.ready then
      love.graphics.setColor(240, 255, 150, 255)
    else
      love.graphics.setColor(140, 150, 90, 255)
    end
  else
    if self.ready then
      love.graphics.setColor(255, 205, 205, 255)
    else
      love.graphics.setColor(150, 130, 130, 255)
    end
  end

  pixelX, pixelY = World.instance:transformToPixels(self.coord)
  love.graphics.draw(self.image, pixelX - self.image:getWidth() / 2, pixelY - self.image:getWidth() / 2 - Tile.side / 2 - 4)

  self:drawHealthBar()
end

function Unit:drawHealthBar()
  pixelX, pixelY = World.instance:transformToPixels(self.coord)

  local healthLength = 30
  local healthHeight = 5
  local healthDistanceAway = 45
  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.rectangle("fill", pixelX - healthLength / 2, pixelY - healthHeight / 2 - healthDistanceAway, healthLength * self.health / self.maxHealth , healthHeight)
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