local Grid = {}

-- Generation constants
Grid.size = 5
Grid.waterNum = 25
Grid.teamSize = 3

function Grid:new(gridData)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.teams = {}
  obj.items = {}

  -- tile that exsists in all spaces outside of bounds of the board
  obj.deadTile = Tile:new(HexCoord:new(1000, -1000))
  obj.deadTile:setHeight(100)

  if gridData then
    -- use data to generate grid
    print('creating loaded Grid')
    local grid = {}
    for x = -Grid.size, Grid.size do
      grid[x] = {}

      for y = -Grid.size, Grid.size do
        grid[x][y] = Tile:new(HexCoord:new(x, y), gridData[x][y].height, gridData[x][y].waterLevel)
      end
    end
    obj.grid = grid
    obj:placeUnits()
  else
    -- randomly generate a grid
    print('creating randomly generated Grid')
    local grid = {}
    for x = -Grid.size, Grid.size do
      grid[x] = {}

      for y = -Grid.size, Grid.size do
        grid[x][y] = Tile:new(HexCoord:new(x, y))
      end
    end
    obj.grid = grid
  end

  return obj
end

function Grid:randomlyFill()
  self:placeWater()
  self:placeTeam()
  self:placeTeam()
end

function Grid:placeWater()
  for i = 1, Grid.waterNum do
    local randomCoord = HexCoord:new(math.random(-Grid.size, Grid.size),
                                     math.random(-Grid.size, Grid.size))
    local tile = self:get(randomCoord)
    tile:addWater()
  end
end

local teamColors = {'yellow', 'red'}

function Grid:placeTeam()
  local teamNum = #self.teams
  local team = {}
  local randomCoord
  for i = 1, Grid.teamSize do
    repeat
      randomCoord = HexCoord:new(math.random(-Grid.size, Grid.size),
                                 math.random(-Grid.size, Grid.size))
    until not self:get(randomCoord).unit and not self:get(randomCoord):getBlocking()

    local newUnit
    if i == Grid.teamSize then
      newUnit = Metal:new(randomCoord, teamColors[teamNum])
    elseif i == Grid.teamSize - 1 then
      newUnit = WaterKnight:new(randomCoord, teamColors[teamNum])
    else
      newUnit = Commando:new(randomCoord, teamColors[teamNum])
    end
    table.insert(team, newUnit)
  end
  table.insert(self.teams, team)
end

-- RETURNS: true if removed and false if not
function Grid:removeUnit(removingUnit)
  for _, team in ipairs(self.teams) do
    for j, unit in ipairs(team) do
      if unit == removingUnit then
        table.remove(team, j)
        return true
      end
    end
  end
  return false
end

-- RETURNS: true if removed and false if not
function Grid:removeItem(removingItem)
  for i, item in ipairs(self.items) do
    if item == removingItem then
      table.remove(self.items, i)
      return true
    end
  end
  return false
end

function Grid:eachTile()
  for x = -Grid.size, Grid.size do
    for y = Grid.size, -Grid.size, -1 do
      local tile = self.grid[x][y]
      coroutine.yield(x, y, tile)
    end
  end
end

-- Warning: Don't call this function (call eachTile instead)
function Grid:tiles()
  return coroutine.wrap(function() self:eachTile() end)
end

function Grid:get(coord)
  if not self.grid[coord.x] or not self.grid[coord.x][coord.y] then
    return self.deadTile
  end
  return self.grid[coord.x][coord.y]
end

return Grid