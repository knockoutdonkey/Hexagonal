local Metal = {}
setmetatable(Metal, Unit)

function Metal:new(coord, color)

  -- Class setup
  local obj = Unit:new(coord, color)
  setmetatable(obj, self)
  self.__index = self

  obj.image = love.graphics.newImage('assets/units/metal.png')

  obj.name = 'Metal'
  obj.moveRange = 8
  obj.jumpRange = 0
  obj.maxHealth = 10
  obj.attacks = {SpinAttack:new(obj), Climb:new(obj), Bash:new(obj), SelfDestruct:new(obj), NoAttack:new(obj)}

  obj:setUp()

  return obj
end

return Metal