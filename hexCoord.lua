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

function HexCoord:copy()
  return HexCoord:new(self.x, self.y)
end

function HexCoord:equals(otherCoord)
  return self.x == otherCoord.x and self.y == otherCoord.y
end

function HexCoord:add(otherCoord)
  return HexCoord:new(self.x + otherCoord.x, self.y + otherCoord.y)
end

return HexCoord