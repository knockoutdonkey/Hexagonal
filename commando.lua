local Commando = {}
setmetatable(Commando, Unit)

function Commando:new(coord, color)

  -- Class setup
  local obj = Unit:new(coord, color)
  setmetatable(obj, self)
  self.__index = self

  obj.moveRange = 4
  obj.jumpRange = 1
  obj.maxHealth = 7
  obj.attacks = {Fire:new(obj), Attack:new(obj), Outpost:new(obj)}

  obj:setUp()

  return obj
end

return Commando