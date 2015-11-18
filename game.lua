local Game = {}

Game.instance = nil

function Game:new(GameData)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  self.instance = obj

  obj.currentTurn = 1

  obj.selectedAttack = nil

  obj.grid = Grid:new()
  obj.grid:randomlyFill()

  -- make first team ready to go
  for i, unit in ipairs(obj.grid.teams[1]) do
    unit.ready = true
  end

  return obj
end

function Game:showAttackRange(attackNum)
  self:unhighlight()
  local unit = Unit.selected
  if unit then
    local attack = unit.attacks[attackNum]
    self.selectedAttack = attack
    for i, coord in ipairs(attack:getRange()) do
      self:get(coord).attackHighlighted = true
    end

    -- only returns nothing for noAttack (in which case end turn)
    if #attack:getRange() == 1 then
      self:attack(unit.coord)
    end
  else
    print('Error: no selected unit to show attack range')
  end
end

function Game:attack(coord)
  local attackResult = false
  local tile = self:get(coord)
  if self.selectedAttack then
    -- returns true if the attack did something
    if tile.attackHighlighted then
      attackResult = self.selectedAttack:attack(tile)

      -- only reset selected attack, if an attack happened
      if attackResult then
        self.selectedAttack = nil
        Tile.selected = nil
        Unit.selected = nil
        self:unhighlight()
      end
    else
      self.selectedAttack = nil
    end
  end

  if attackResult then
    self:checkEndTurn()
  end

  return attackResult
end

function Game:removeUnit(unit)
  self.grid:removeUnit(unit)
end

function Game:removeItem(item)
  self.grid:removeItem(item)
end

function Game:moveSelectedTo(coord)
  if Tile.selected and Tile.selected.unit then
    local unit = Tile.selected.unit

    if not unit.coord:equals(coord) then
      unit:moveTo(coord)
      Tile.selected:select()
    end
  end
end

-- TODO: rethink how to decouple this function from gird
function Game:checkEndTurn()
  -- check to see if the turn is over
  local currentTeam = self.grid.teams[self.currentTurn]

  local readyToMove = 0
  for i, unit in ipairs(currentTeam) do
    if unit.ready then
      readyToMove = readyToMove + 1
    end
  end

  -- if turn is over make other team ready to go
  if readyToMove <= 0 then
    self.currentTurn = (self.currentTurn % #self.grid.teams) + 1

    for i, item in ipairs(self.grid.items) do
      item:startTurn()
    end

    for i, unit in ipairs(self.grid.teams[self.currentTurn]) do
      unit:startTurn()
    end
  end
end

function Game:unhighlight()
  for x, y, tile in self.grid:tiles(root) do
    tile.highlighted = false
    tile.attackHighlighted = false
  end
end

function Game:draw()
  for x, y, tile in self.grid:tiles(root) do
    tile:draw()
  end

  if Unit.selected then
    Unit.selected:drawAttacks()
  end
end

-- Returns the tile on the board, or a tile that won't be rendered if coordinates do not match a tile
function Game:get(coord)
  return self.grid:get(coord)
end

function Game:transformToPixels(coord)
  local tile = self:get(coord)
  local tileRaise = tile.side * tile.vertical * math.sqrt(1 - tile.tilt * tile.tilt)
  local pX = tile.side * 1.5 * (coord.x + coord.y)
  local pY = .866 * tile.side * tile.tilt * (coord.x - coord.y) - tile.height * tileRaise
  return pX, pY
end

-- Takes height of tile into account
function Game:transformToCoords(pX, pY)
  local tileRaise = Tile.side * Tile.vertical * math.sqrt(1 - Tile.tilt * Tile.tilt)
  local y = ((pX) / (Tile.side * 1.5) - (pY) / (.866 * Tile.side * Tile.tilt)) / 2
  local x = (pX) / (Tile.side * 1.5) - y
  x = math.floor(x + .5)
  y = math.floor(y + .5)
  local coord = HexCoord:new(x, y)

  -- check for tiles in front
  local forwardTile = self:get(coord:add(HexCoord:new(1, -1)))
  local newPX, newPY = self:transformToPixels(forwardTile.coord)

  while newPY < pY + Tile.side * .866 and forwardTile ~= self.deadTile do
    coord = forwardTile.coord
    forwardTile = self:get(coord:add(HexCoord:new(1, -1)))
    newPX, newPY = self:transformToPixels(forwardTile.coord)
  end
  return coord
end

return Game