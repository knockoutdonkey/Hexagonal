Bash = {}
setmetatable(Bash, Attack)

function Bash:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/BashIcon.png'))
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
          not lastTile:hasWater() and                         -- can more than 1 in water
          not (lastTile.unit and                              -- last tile cannot have a unit
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
  local currentTile = World.instance:get(self.unit.coord)
  local nextTile = World.instance:get(self.unit.coord:add(direction))
  while nextTile.attackHighlighted and self.unit:place(nextTile.coord) do
    currentTile = nextTile
    nextTile = World.instance:get(nextTile.coord:add(direction))
  end

  -- damage any unit that is hit
  if nextTile.unit and nextTile:getHeight() <= currentTile:getHeight() then
    nextTile.unit:damage((startTile:getHeight() - currentTile:getHeight() + 1) * self.damage)
  end

  return true
end

return Bash