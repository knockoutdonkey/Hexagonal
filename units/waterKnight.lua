local WaterKnight = {}
setmetatable(WaterKnight, Unit)

function WaterKnight:new(coord, color)

  -- Class setup
  local obj = Unit:new(coord, color)
  setmetatable(obj, self)
  self.__index = self

  obj.image = love.graphics.newImage('assets/units/bowGuy.png')

  obj.name = 'Water Knight'
  obj.moveRange = 3
  obj.jumpRange = 1
  obj.maxHealth = 8
  obj.attacks = {WaterBlast:new(obj), Storm:new(obj), NoAttack:new(obj)}

  obj.waterWalker = true

  obj:setUp()

  return obj
end

return WaterKnight