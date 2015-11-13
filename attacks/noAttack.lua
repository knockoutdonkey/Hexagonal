NoAttack = {}
setmetatable(NoAttack, Attack)

function NoAttack:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/NoAttackIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 0

  return obj
end

-- able to hit all
function NoAttack:getRange()
  return {self.unit.coord}
end

function NoAttack:perform(tile)
  return true
end

return NoAttack