local Climb = {}
setmetatable(Climb, Attack)

function Climb:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/ClimbIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 0

  return obj
end

-- able to hit all
function Climb:getRange()
  local neighbors = self.unit.coord:getNeighbors()

  local range = {}
  for i, coord in ipairs(neighbors) do
    if math.abs(World.instance:get(coord):getHeight() - World.instance:get(self.unit.coord):getHeight()) >= 1 then
      table.insert(range, coord)
    end
  end
  return range
end

function Climb:perform(tile)
  if not tile.item and not tile:getBlocking() then
    self.unit.coord = tile.coord:copy()

    World.instance:get(self.unit.coord).item = nil
    tile.item = self.unit

    return true
  end
  return false
end

return Climb