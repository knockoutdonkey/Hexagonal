Tsunami = {}
setmetatable(Tsunami, Attack)

function Tsunami:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/TsunamiIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 3

  return obj
end

-- able to hit all
function Tsunami:getRange()
  local neighbors = self.unit.coord:getNeighbors()

  local range = {}
  for i, coord in ipairs(neighbors) do
    if math.abs(Game.instance:get(coord):getHeight() - Game.instance:get(self.unit.coord):getHeight()) <= 1 then
      table.insert(range, coord)
    end
  end
  return range
end

function Tsunami:perform(tile)
  local coords = self:getRange()
  local hit = false
  for i, coord in ipairs(coords) do
    local target = Game.instance:get(coord).unit
    if target then
      target:damage(self.damage)
      hit = true
    end
  end
  return hit
end

return Tsunami