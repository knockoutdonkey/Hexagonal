local Tile = {}

Tile.side = 25
Tile.tilt = .8
Tile.vertical = .7
Tile.selected = nil

function Tile:new(x, y)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.x = x
  obj.y = y
  obj.height = nil
  obj.blocking = nil
  obj:setHeight(math.random(0, 3)) -- use setter and getter to manipulate
  obj.shade = math.random(1, 80)

  obj.item = nil
  obj.highlighted = false

  return obj
end

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
  local heightColor = {
    r=100 + self.shade / 2,
    g=50 + self.shade / 2,
    b=10 + self.shade / 2,
    a=255
  }
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
    groundColor.r = 100 + 150 / 5 * self:getHeight()
    groundColor.g = 75 + 90 / 5 * self:getHeight()
    groundColor.b = 50
  end

  if Tile.selected == self then
    groundColor.r = 255
    groundColor.g = 255
    groundColor.b = 255
  end

  local tileRaise = Tile.side * .7 * math.sqrt(1 - Tile.tilt * Tile.tilt)

  -- draw height
  love.graphics.setColor(heightColor.r, heightColor.g, heightColor.b, heightColor.a)
  love.graphics.polygon('fill', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y),
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y))

  -- draw ground
  love.graphics.setColor(groundColor.r, groundColor.g, groundColor.b, groundColor.a)
  love.graphics.polygon('fill', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y) - self:getHeight() * tileRaise)


  if self.item then
    self.item:draw()
  end
end

return Tile