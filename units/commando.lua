local Commando = {}
setmetatable(Commando, Unit)

function Commando:new(coord, color)

  -- Class setup
  local obj = Unit:new(coord, color)
  setmetatable(obj, self)
  self.__index = self

  obj.image = love.graphics.newImage('assets/units/knifeGuy.png')

  obj.name = 'Commando'
  obj.moveRange = 4
  obj.jumpRange = 1
  obj.maxHealth = 7
  obj.attacks = {LongShot:new(obj), Knife:new(obj), Outpost:new(obj)}

  obj:setUp()

  return obj
end

return Commando