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

  obj:placeUnits()

  return obj
end

function World:placeUnits()
  local x, y
  for i = 1, World.playerUnitNum do
    repeat
      x = math.random(-World.size, World.size)
      y = math.random(-World.size, World.size)
    until not self:get(x, y).item and not self:get(x, y).blocking

    local newUnit = Unit:new(x, y, 'yellow')
    self.grid[x][y].item = newUnit
    table.insert(self.playerUnits, newUnit)
  end

  for i = 1, World.enemyUnitNum do
    local x, y
    repeat
      x = math.random(-World.size, World.size)
      y = math.random(-World.size, World.size)
    until not self:get(x, y).item and not self:get(x, y).blocking

    local newUnit = Unit:new(x, y, 'red')
    self.grid[x][y].item = newUnit
    table.insert(self.enemyUnits, newUnit)
  end
end

function World:moveSelectedTo(x, y)
  if Tile.selected and Tile.selected.item then
    local unit = Tile.selected.item
    unit:moveTo(x, y)
    Tile.selected:select()
  end
end

function World:unhighlight()
  for x, y, tile in self:tiles(root) do
    tile.highlighted = false
  end
end

function World:draw()
  for x, y, tile in self:tiles(root) do
    tile:draw()
  end

  -- if Tile.selected then
  --   Tile.selected:draw()
  -- end
end


local deadTile = Tile:new(1000, 1000)
-- Returns the tile on the board, or a tile that won't be rendered if coordinates do not match a tile
function World:get(x, y)
  if not self.grid[x] or not self.grid[x][y] then
    return deadTile
  end
  return self.grid[x][y]
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

function World:transformToPixels(x, y)
  local tile = self:get(x, y)
  local tileRaise = tile.side * tile.vertical * math.sqrt(1 - tile.tilt * tile.tilt)
  local pX = tile.side * 1.5 * (x + y)
  local pY = .866 * tile.side * tile.tilt * (x - y) - tile.height * tileRaise
  return pX, pY
end

-- TODO: Make sure that it can select things at different heights
function World:transformToCoords(pX, pY)
  -- local tile = self.grid[x][y]
  -- local tileRaise = tile.side * tile.vertical * math.sqrt(1 - tile.tilt * tile.tilt)
  -- local y = ((pX) / (tile.side * 1.5) - (pY + tile.height * tileRaise) / (.866 * tile.side * tile.tilt)) / 2
  -- local x = (pX) / (tile.side * 1.5) - y
  -- return x, y
  local tileRaise = Tile.side * Tile.vertical * math.sqrt(1 - Tile.tilt * Tile.tilt)
  local y = ((pX) / (Tile.side * 1.5) - (pY) / (.866 * Tile.side * Tile.tilt)) / 2
  local x = (pX) / (Tile.side * 1.5) - y
  return math.floor(x + .5), math.floor(y + .5)
end

return World