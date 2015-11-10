local World = {}

World.instance = nil
World.size = 5
World.playerUnitNum = 3
World.enemyUnitNum = 3

function World:new()

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  self.instance = obj

  local grid = {}
  for x = -World.size, World.size do
    grid[x] = {}

    for y = -World.size, World.size do
      grid[x][y] = Tile:new(x, y)
    end
  end
  obj.grid = grid

  obj.playersTurn = true
  obj.playerUnits = {}
  obj.enemyUnits = {}

  obj.selectedAttack = nil

  obj.deadTile = Tile:new(1000, 0)
  obj.deadTile:setHeight(1000)

  obj:placeUnits()

  return obj
end

function World:placeUnits()
  local randomCoord
  for i = 1, World.playerUnitNum do
    repeat
      randomCoord = HexCoord:new(math.random(-World.size, World.size),
                               math.random(-World.size, World.size))
    until not self:get(randomCoord).item and not self:get(randomCoord).blocking

    local newUnit = Unit:new(randomCoord, 'yellow')
    self:get(randomCoord).item = newUnit
    table.insert(self.playerUnits, newUnit)
  end

  for i = 1, World.enemyUnitNum do
    local randomCoord
    repeat
      randomCoord = HexCoord:new(math.random(-World.size, World.size),
                               math.random(-World.size, World.size))
    until not self:get(randomCoord).item and not self:get(randomCoord).blocking

    local newUnit = Unit:new(randomCoord, 'red')
    newUnit.ready = false
    self:get(randomCoord).item = newUnit
    table.insert(self.enemyUnits, newUnit)
  end
end

function World:showAttackRange(attackNum)
  self:unhighlight()
  local unit = Unit.selected
  if unit then
    local attack = unit.attacks[attackNum]
    self.selectedAttack = attack
    for i, coord in ipairs(attack:getRange()) do
      self:get(coord).attackHighlighted = true
    end
  else
    print('Error: no selected unit to show attack range')
  end
end

function World:attack(coord)
  local attackResult = false
  local tile = self:get(coord)
  if self.selectedAttack then
    -- returns true if the attack did something
    if tile.attackHighlighted then
      attackResult = self.selectedAttack:perform(tile)

      -- only reset selected attack, if an attack happened
      if attackResult then
        self.selectedAttack = nil
      end
    else
      self.selectedAttack = nil
    end
  else
  end
  return attackResult
end

function World:moveSelectedTo(coord)

  if Tile.selected and Tile.selected.item then
    local unit = Tile.selected.item

    if not unit.coord:equals(coord) then
      unit:moveTo(coord)
      Tile.selected:select()
    end
  end

  -- check to see if the turn is over
  local currentUnits = nil
  local otherUnits = nil
  if self.playersTurn then
    currentUnits = self.playerUnits
    otherUnits = self.enemyUnits
  else
    currentUnits = self.enemyUnits
    otherUnits = self.playerUnits
  end

  local readyToMove = 0
  for i, unit in ipairs(currentUnits) do
    if unit.ready then
      readyToMove = readyToMove + 1
    end
  end

  -- make other team ready to go
  if readyToMove <= 0 then
    self.playersTurn = not self.playersTurn

    for i, unit in ipairs(otherUnits) do
      unit.ready = true
    end
  end
end

function World:unhighlight()
  for x, y, tile in self:tiles(root) do
    tile.highlighted = false
    tile.attackHighlighted = false
  end
end

function World:draw()
  for x, y, tile in self:tiles(root) do
    tile:draw()
  end

  if Unit.selected then
    Unit.selected:drawAttacks()
  end
end

-- Returns the tile on the board, or a tile that won't be rendered if coordinates do not match a tile
function World:get(coord)
  if not self.grid[coord.x] or not self.grid[coord.x][coord.y] then
    return self.deadTile
  end
  return self.grid[coord.x][coord.y]
end

function World:eachTile()
  for x = -World.size, World.size do
    for y = World.size, -World.size, -1 do
      local tile = self.grid[x][y]
      coroutine.yield(x, y, tile)
    end
  end
end

-- Warning: Don't call this function (call eachTile instead)
function World:tiles()
  return coroutine.wrap(function() self:eachTile() end)
end

function World:transformToPixels(coord)
  local tile = self:get(coord)
  local tileRaise = tile.side * tile.vertical * math.sqrt(1 - tile.tilt * tile.tilt)
  local pX = tile.side * 1.5 * (coord.x + coord.y)
  local pY = .866 * tile.side * tile.tilt * (coord.x - coord.y) - tile.height * tileRaise
  return pX, pY
end

-- Takes height of tile into account
function World:transformToCoords(pX, pY)
  -- local tile = self.grid[x][y]
  -- local tileRaise = tile.side * tile.vertical * math.sqrt(1 - tile.tilt * tile.tilt)
  -- local y = ((pX) / (tile.side * 1.5) - (pY + tile.height * tileRaise) / (.866 * tile.side * tile.tilt)) / 2
  -- local x = (pX) / (tile.side * 1.5) - y
  -- return x, y
  local tileRaise = Tile.side * Tile.vertical * math.sqrt(1 - Tile.tilt * Tile.tilt)
  local y = ((pX) / (Tile.side * 1.5) - (pY) / (.866 * Tile.side * Tile.tilt)) / 2
  local x = (pX) / (Tile.side * 1.5) - y
  x = math.floor(x + .5)
  y = math.floor(y + .5)
  local coord = HexCoord:new(x, y)

  -- check for tiles in front
  local forwardTile = self:get(coord:add(HexCoord:new(1, -1)))
  local newPX, newPY = self:transformToPixels(forwardTile.coord)

  while newPY < pY + Tile.side * .866 do
    print('moving')
    coord = forwardTile.coord
    forwardTile = self:get(coord:add(HexCoord:new(1, -1)))
    newPX, newPY = self:transformToPixels(forwardTile.coord)
  end
  return coord
end

return World