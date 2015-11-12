Metal = {}
setmetatable(Metal, Unit)

function Metal:new(coord, color)
  local obj = Unit:new(coord, color)
  setmetatable(obj, self)
  self.__index = self

  obj.image = love.graphics.newImage('assets/metal.png')

  obj.moveRange = 8
  obj.jumpRange = 0
  obj.maxHealth = 10
  obj.attacks = {Fire:new(obj), Attack:new(obj), Outpost:new(obj)}

  obj:setUp()

  return obj
end

return Metal