local Tile = {}

Tile.side = 25
Tile.tilt = .8
Tile.vertical = .7
Tile.selected = nil

function Tile:new(coordOrX, y)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self


  if y then
    -- given x/y parameters
    obj.coord = HexCoord:new(coordOrX, y)
  else
    -- given coordinate parameter
    obj.coord = coordOrX:copy()
  end


  obj.height = nil
  obj:setHeight(math.random(0, 2)) -- use setter and getter to manipulate

  obj.waterLevel = 0

  obj.item = nil
  obj.highlighted = false

  obj.attackHighlighted = false

  return obj
end

-- select tile and any unit that may be on it
function Tile:select()
  -- if character is highlighted for an attack, then don't select the character
  if self.attackHighlighted then
    return
  end

  if Tile.selected == self then
    Tile.selected = nil
  else
    Tile.selected = self
  end

  if self.item then
    self.item:select()
  else
    if Unit.selected then
      Unit.selected:select()
    end
  end
end

function Tile:raise()
  self:setHeight(self:getHeight() + 1)
  self:iterateWaterFlow()
end

function Tile:lower()
  self:setHeight(self:getHeight() - 1)
  self:iterateWaterFlow()
  for i, coord in ipairs(self.coord:getNeighbors()) do
    World.instance:get(coord):iterateWaterFlow()
  end
end

function Tile:getHeight()
  return self.height
end

function Tile:getBlocking()
  return self.waterLevel > .1 or self.height > 100
end

function Tile:setHeight(height)
  if height >= 0 then
    self.height = height
  end
end

function Tile:addWater()
  self.waterLevel = self.waterLevel + 1
  self:iterateWaterFlow()
end

local waterQuantum = .1

function Tile:iterateWaterFlow()
  local neighborCoords = self.coord:getNeighbors()

  local nextTiles = {}
  for i, neighborCoord in ipairs(neighborCoords) do

    local neighborTile = World.instance:get(neighborCoord)

    -- print(neighborTile:getHeight() + neighborTile.waterLevel + waterQuantum, self:getHeight() + self.waterLevel)
    if neighborTile:getHeight() + neighborTile.waterLevel + waterQuantum < self:getHeight() + self.waterLevel and self.waterLevel > 0 then

      neighborTile.waterLevel = neighborTile.waterLevel + waterQuantum
      self.waterLevel = math.floor((self.waterLevel - waterQuantum) / waterQuantum) * waterQuantum
      table.insert(nextTiles, neighborTile)
    end
  end

  if #nextTiles > 0 then
    table.insert(nextTiles, self)
  end

  for i, neighborTile in ipairs(nextTiles) do
    neighborTile:iterateWaterFlow()
  end
end

function Tile:draw()

  -- determine correct color
  local groundColor = {
    r=50,
    g=50 + 205 / 5 * self:getHeight(),
    b=50,
    a=255
  }

  -- if self.waterLevel > 0 then
  --   groundColor.r = 80
  --   groundColor.g = 100
  --   groundColor.b = 155 + 100 * self.waterLevel
  -- end

  if self.highlighted then
    groundColor.r = 70 + 185 / 5 * self:getHeight()
    groundColor.g = 75 + 50 / 5 * self:getHeight()
    groundColor.b = 70 + 185 / 5 * self:getHeight()
  end

  if self.attackHighlighted then
    groundColor.r = 150 + 105 / 5 * self:getHeight()
    groundColor.g = 50 + 0 / 5 * self:getHeight()
    groundColor.b = 50 + 0 / 5 * self:getHeight()
  end

  if Tile.selected == self then
    groundColor.r = 255
    groundColor.g = 255
    groundColor.b = 255
  end

  local tileRaise = Tile.side * .7 * math.sqrt(1 - Tile.tilt * Tile.tilt)

  -- draw height
  for level = 0, self:getHeight() - 1 do
    love.graphics.setColor(100 + 100 * level / 5, 50 + 75 * level / 5, 10 + 50 * level / 5, 255)
    love.graphics.polygon('fill', Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - level * tileRaise,
                                  Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (level + 1) * tileRaise,
                                  Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (level + 1) * tileRaise,
                                  Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (level + 1) * tileRaise,
                                  Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (level + 1) * tileRaise,
                                  Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - level * tileRaise,
                                  Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - level * tileRaise,
                                  Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - level * tileRaise)
  end

  -- draw ground
  love.graphics.setColor(groundColor.r, groundColor.g, groundColor.b, groundColor.a)
  love.graphics.polygon('fill', Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise)

  -- draw water
  if self.waterLevel > 0 then
    love.graphics.setColor(50, 70, 255, math.min(self.waterLevel * 3 * 255, 255))
    love.graphics.polygon('fill', Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - self.height * tileRaise,
                                Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (self.height + self.waterLevel) * tileRaise,
                                Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (self.height + self.waterLevel) * tileRaise,
                                Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (self.height + self.waterLevel) * tileRaise,
                                Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (self.height + self.waterLevel) * tileRaise,
                                Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - self.height * tileRaise,
                                Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - self.height * tileRaise,
                                Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - self.height * tileRaise)
  end

  -- show water level
  -- love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.print(self.waterLevel, Tile.side * (-.1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-.1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise)

  if self.item then
    self.item:draw()
  end
end

return Tile