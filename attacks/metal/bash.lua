Bash = {}
setmetatable(Bash, Attack)

function Bash:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/SpinAttackIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 2

  return obj
end

-- able to hit straight line in each direction
function Bash:getRange()
  local directions = HexCoord:new(0, 0):getNeighbors()

  local range = {}
  for i, direction in ipairs(directions) do

    local coord = self.unit.coord
    local lastTile = World.instance:get(coord)
    coord = coord:add(direction)
    local currentTile = World.instance:get(coord)

    while currentTile:getHeight() <= lastTile:getHeight() and -- can only lower in height
          not currentTile:getBlocking() and                   -- can not go over water
          not (lastTile.item and                              -- last tile cannot have a unit
          World.instance:get(self.unit.coord) ~= lastTile) do -- unless that tile was the first tile
      table.insert(range, currentTile.coord)

      lastTile = currentTile
      coord = coord:add(direction)
      currentTile = World.instance:get(coord)
    end
  end
  return range
end

-- TODO: make it fall it the water if water is in the way
-- TODO: maybe cause knockback
function Bash:perform(tile)

  local direction = self.unit.coord:getDirectionTo(tile.coord)
  local startTile = World.instance:get(self.unit.coord)

  -- move in direction until stopped
  local nextTile = World.instance:get(self.unit.coord:add(direction))
  while not nextTile.item and not nextTile:getBlocking() do
    World.instance:get(self.unit.coord).item = nil

    self.unit.coord = nextTile.coord:copy()
    nextTile.item = self.unit

    nextTile = World.instance:get(nextTile.coord:add(direction))
  end

  -- damage any unit that is hit
  local currentTile = World.instance:get(self.unit.coord)
  if nextTile.item then
    nextTile.item:damage((startTile:getHeight() - currentTile:getHeight() + 1) * self.damage)
  end

  return true
end

return Bash