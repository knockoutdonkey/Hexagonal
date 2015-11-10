-- Location on hexagonal board
-- Provides extra utility functions
local HexCoord = {}

function HexCoord:new(x, y)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.x = x
  obj.y = y

  return obj
end

function HexCoord:getNeighbors()
  return {
    HexCoord:new(self.x + 0, self.y + 1),
    HexCoord:new(self.x + 1, self.y + 0),
    HexCoord:new(self.x + 1, self.y - 1),
    HexCoord:new(self.x + 0, self.y - 1),
    HexCoord:new(self.x - 1, self.y + 0),
    HexCoord:new(self.x - 1, self.y + 1)
  }
end

function HexCoord:getAllWithin(maxRange, minRange)
  minRange = minRange or 0

  results = {}
  for x = -maxRange, maxRange do
    for y = -maxRange, maxRange do
      local nextCoord = HexCoord:new(self.x + x, self.y + y)
      if math.abs(x + y) <= maxRange and nextCoord:getDistance(self) >= minRange then
        table.insert(results, nextCoord)
      end
    end
  end
  return results
end

function HexCoord:copy()
  return HexCoord:new(self.x, self.y)
end

function HexCoord:equals(otherCoord)
  return self.x == otherCoord.x and self.y == otherCoord.y
end

function HexCoord:add(otherCoord)
  return HexCoord:new(self.x + otherCoord.x, self.y + otherCoord.y)
end

function HexCoord:subtract(otherCoord)
  return HexCoord:new(self.x - otherCoord.x, self.y - otherCoord.y)
end

-- get distance between two coords or from the origin
function HexCoord:getDistance(otherCoord)
  otherCoord = otherCoord or HexCoord:new(0, 0)

  local diffCoord = self:subtract(otherCoord)
  if (diffCoord.x > 0 and diffCoord.y < 0) or (diffCoord.x < 0 and diffCoord.y > 0) then
    return math.max(math.abs(diffCoord.x), math.abs(diffCoord.y))
  else
    return math.abs(diffCoord.x + diffCoord.y)
  end
end

return HexCoord