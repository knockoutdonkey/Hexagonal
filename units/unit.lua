local Unit = {}

Unit.selected = nil

function Unit:new(coord, color)

  -- Class setup
  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  -- Don't create a Unit if there is already something at that location
  if World.instance:get(coord).unit then
    print('Unit could not be placed')
    return false
  end

  World.instance:get(coord).unit = obj

  obj.coord = coord:copy()
  obj.color = color

  -- These are unique to this unit
  obj.image = love.graphics.newImage('assets/units/rabbit.png')

  obj.name = 'Unit'
  obj.moveRange = 3
  obj.jumpRange = 1
  obj.maxHealth = 10
  obj.attacks = {Attack:new(obj), Attack:new(obj), NoAttack:new(obj)}

  -- Movement options
  obj.waterWalker = false

  obj:setUp()

  obj.tasks = {}

  return obj
end

function Unit:setUp()
  self.health = self.maxHealth
  self.movesLeft = self.moveRange
  self.ready = false

  self.image:setFilter('nearest', 'nearest')
end

function Unit:startTurn()
  self.movesLeft = self.moveRange
  self.ready = true

  for i, task in ipairs(self.tasks) do
    task(self)
  end
  self.tasks = {}
end

function Unit:endTurn()
  self.movesLeft = 0
  self.ready = false
end

function Unit:addStartTurnTask(task)
  table.insert(self.tasks, task)
end

-- TODO: check for hit collision before moving
function Unit:move(deltaCoord)
  self:moveTo(self.coord:add(deltaCoord))
end

function Unit:moveTo(nextCoord)
  local startTile = World.instance:get(self.coord)
  local nextTile = World.instance:get(nextCoord)
  if nextTile.highlighted and self.ready then

    self.movesLeft = self.movesLeft - self.coord:getDistance(nextCoord)
    if nextTile:hasWater() or startTile:hasWater() then
      self.movesLeft = 0
    end

    return self:place(nextCoord)
  end
  return false
end

-- Places tile at the nextCoord if nothing is preventing it from going there
function Unit:place(nextCoord)
  local prevTile = World.instance:get(self.coord)
  local nextTile = World.instance:get(nextCoord)
  if not nextTile.unit and not nextTile:getBlocking() then
    self.coord = nextCoord:copy()

    prevTile.unit = nil
    nextTile.unit = self

    if nextTile.item then
      nextTile.item:touched(self)
    end
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

    local tileHash = {}
    function highlight(coord, distanceLeft)
      local tile = World.instance:get(coord)

      -- if tile has already been visited more quickly, stop
      if tileHash[tile] and tileHash[tile] > distanceLeft then
        return
      end
      tileHash[tile] = distanceLeft

      -- Only move while there is distance left
      if distanceLeft < 0 then
        return
      end

      -- Only allow movement through units of the same color
      if tile.unit and tile.unit.color ~= self.color then
        return
      end
      tile.highlighted = true

      -- Only allow one move if in water
      if (tile:hasWater() and not self.waterWalker) and distanceLeft > 0 then
        distanceLeft = 1
      end

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
  World.instance:get(self.coord).unit = nil
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