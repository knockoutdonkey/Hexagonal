local Grenade = {}
setmetatable(Grenade, Unit)

function Grenade:new(coord, color)

  -- Class setup
  local obj = Unit:new(coord, color)
  setmetatable(obj, self)
  self.__index = self

  obj.image = love.graphics.newImage('assets/units/grenade.png')

  obj.name = 'Grenade'
  obj.moveRange = 1
  obj.jumpRange = 0
  obj.maxHealth = 100000
  obj.attacks = {}

  obj:setUp()

  return obj
end

function Grenade:startTurn()
  self.ready = true
  self:explode()
end

function Grenade:explode()
  --self:kill()
end

return Grenade