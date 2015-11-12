SpinAttack = {}
setmetatable(SpinAttack, Attack)

function SpinAttack:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/SpinAttackIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 3

  return obj
end

-- able to hit all
function SpinAttack:getRange()
  local neighbors = self.unit.coord:getNeighbors()

  local range = {}
  for i, coord in ipairs(neighbors) do
    if math.abs(World.instance:get(coord):getHeight() - World.instance:get(self.unit.coord):getHeight()) <= 1 then
      table.insert(range, coord)
    end
  end
  return range
end

function SpinAttack:perform(tile)
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

return SpinAttack