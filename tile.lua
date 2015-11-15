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

  obj.waterLevel = 0

  obj.item = nil
  obj.unit = nil
  obj.highlighted = false

  obj.attackHighlighted = false

  obj.height = 0
  obj:setHeight(math.random(1, 3)) -- use setter and getter to manipulate

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

  if self.unit then
    self.unit:select()
  else
    if Unit.selected then
      Unit.selected:select()
    end
  end
end

function Tile:raise()
  self:setHeight(self:getHeight() + 1)
end

function Tile:lower()
  self:setHeight(self:getHeight() - 1)
end

function Tile:setHeight(height)
  if height < 0 then
    height = 0
  end

  local oldHeight = self:getHeight()
  self.height = height

  self:iterateWaterFlow()
  if self.height < oldHeight then
    for i, coord in ipairs(self.coord:getNeighbors()) do
      World.instance:get(coord):iterateWaterFlow()
    end
  end
end

function Tile:getHeight()
  return self.height
end

function Tile:getBlocking()
  return self.height > 100
end

function Tile:addWater()
  self.waterLevel = self.waterLevel + 1
  self:iterateWaterFlow()
end

function Tile:hasWater()
  return self.waterLevel > .3
end

local waterQuantum = .1

-- TODO: Make this iterative instead of recursive
function Tile:iterateWaterFlow()
  if self.waterLevel <= 0 then
    return
  end

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

  local highlightColor = {r = 0, b = 0, c = 0, a = 0}
  if self.highlighted then
    highlightColor.r = 70 + 185 / 5 * self:getHeight()
    highlightColor.g = 75 + 50 / 5 * self:getHeight()
    highlightColor.b = 70 + 185 / 5 * self:getHeight()
    highlightColor.a = 200
  end

  if self.attackHighlighted then
    highlightColor.r = 150 + 105 / 5 * self:getHeight()
    highlightColor.g = 50 + 0 / 5 * self:getHeight()
    highlightColor.b = 50 + 0 / 5 * self:getHeight()
    highlightColor.a = 200
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
    if self:hasWater() then
      love.graphics.setColor(50, 70,255, 255)
    else
      love.graphics.setColor(50, 70, 255, math.min(self.waterLevel * 2 * 255, 255))
    end
    love.graphics.polygon('fill', Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                  Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                  Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise,
                                  Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise)
  end

  -- draw highlighting
  if self.attackHighlighted or self.highlighted then
    love.graphics.setColor(highlightColor.r, highlightColor.g, highlightColor.b, highlightColor.a)
    love.graphics.polygon('fill', Tile.side * (1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (-1 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (-.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise,
                                  Tile.side * (.5 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.coord.x + self.coord.y) - (self:getHeight() + self.waterLevel) * tileRaise)
  end

  -- show water level
  -- love.graphics.setColor(255, 255, 255, 255)
  -- love.graphics.print(self.waterLevel, Tile.side * (-.4 + self.coord.x * 1.5 + self.coord.y * 1.5), .866 * -Tile.side * Tile.tilt * (.9 - self.coord.x + self.coord.y) - self:getHeight() * tileRaise)

  if self.unit then
    self.unit:draw()
  end

  if self.item then
    self.item:draw()
  end
end

return Tile