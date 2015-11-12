Knife = {}
setmetatable(Knife, Attack)

function Knife:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/KnifeIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 3

  return obj
end

return Knife