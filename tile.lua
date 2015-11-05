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
  obj:setHeight(math.random(0, 5)) -- use setter and getter to manipulate
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

  local tileRaise = Tile.side * .7 * math.sqrt(1 - Tile.tilt * Tile.tilt)

  -- draw height
  love.graphics.setColor(100 + self.shade / 2, 50 + self.shade / 2, 10 + self.shade / 2, 255)
  love.graphics.polygon('fill', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y),
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y))

  -- draw ground
  if self:getHeight() == 0 then
    love.graphics.setColor(100, 100, 255, 255)
  else
    love.graphics.setColor(50, 50 + 205 / 5 * self:getHeight(), 50, 255)
  end
  love.graphics.polygon('fill', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y) - self:getHeight() * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y) - self:getHeight() * tileRaise)

  -- draw highlighted outline
  if self.highlighted then
    love.graphics.setColor(255, 100, 0, 255)
    love.graphics.setLineWidth(3)
    love.graphics.polygon('line', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                  Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                  Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y),
                                  Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y))
  end

  -- draw selected outline
  if Tile.selected == self then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(3)
    love.graphics.polygon('line', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                  Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self:getHeight() * tileRaise - 1,
                                  Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                  Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y),
                                  Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y))
  end


  if self.item then
    self.item:draw()
  end
end

return Tile