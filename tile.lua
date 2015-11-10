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
  obj.blocking = nil
  obj:setHeight(math.random(0, 3)) -- use setter and getter to manipulate

  obj.item = nil
  obj.highlighted = false

  obj.attackHighlighted = false

  return obj
end

-- select tile and any unit that may be on it
function Tile:select()
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
end

function Tile:lower()
  self:setHeight(self:getHeight() - 1)
end

function Tile:getHeight()
  return self.height
end

function Tile:setHeight(height)

  if height >= 0 then
    self.height = height
    if self.height == 0 then
      self.blocking = true
    else
      self.blocking = false
    end
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

  if self:getHeight() == 0 then
    groundColor.r = 100
    groundColor.g = 100
    groundColor.b = 255
  end

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


  if self.item then
    self.item:draw()
  end
end

return Tile