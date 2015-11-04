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
  obj.height = math.random(0, 3)
  obj.shade = math.random(1, 80)

  obj.item = nil

  return obj
end

function Tile:select()
  if Tile.selected == self then
    Tile.selected = nil
  else
    Tile.selected = self
  end
end

function Tile:draw()

  local tileRaise = Tile.side * .7 * math.sqrt(1 - Tile.tilt * Tile.tilt)

  -- draw height
  love.graphics.setColor(100 + self.shade / 2, 50 + self.shade / 2, 10 + self.shade / 2, 255)
  love.graphics.polygon('fill', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y),
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y))

  -- draw ground
  if self.height == 0 then
    love.graphics.setColor(100, 100, 255, 255)
  else
    love.graphics.setColor(50, 175 + 80 / 3 * self.height, 50, 255)
  end
  love.graphics.polygon('fill', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y) - self.height * tileRaise,
                                Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y) - self.height * tileRaise)

  -- draw selected outline
  if self.selected == self then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(5)
    love.graphics.polygon('line', Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                  Tile.side * (1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self.height * tileRaise,
                                  Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self.height * tileRaise,
                                  Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (1 - self.x + self.y) - self.height * tileRaise,
                                  Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y) - self.height * tileRaise,
                                  Tile.side * (-1 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (0 - self.x + self.y),
                                  Tile.side * (-.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y),
                                  Tile.side * (.5 + self.x * 1.5 + self.y * 1.5), .866 * -Tile.side * Tile.tilt * (-1 - self.x + self.y))
  end


  if self.item then
    self.item:draw()
  end
end

return Tile