grenadeToss = {}
setmetatable(grenadeToss, Attack)

function grenadeToss:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/grenadeTossIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 4

  return obj
end

-- able to hit all
function grenadeToss:getRange()
  local neighbors = self.unit.coord:getAllWithin(2, 1)

  local range = {}
  for i, coord in ipairs(neighbors) do
    if math.abs(World.instance:get(coord):getHeight() - World.instance:get(self.unit.coord):getHeight()) <= 4 then
      table.insert(range, coord)
    end
  end
  return range
end

function grenadeToss:perform(tile)
  local coords = self:getRange()
  local hit = false
  for i, coord in ipairs(coords) do
    local target = World.instance:get(coord).item
    if target then
      target:damage(self.damage)
      hit = true
    end
  end
  return hit
end

return grenadeToss