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
  obj.attacks = {SpinAttack:new(obj), Climb:new(obj), SelfDestruct:new(obj)}

  -- for self destruct
  obj.selfDestructing = false

  obj:setUp()

  return obj
end

function Metal:startTurn()
  Unit.startTurn(self)

  -- blow up if self destructing
  if self.selfDestructing then
    for i, neighborCoord in ipairs(self.coord:getAllWithin(2, 0)) do
      local unit = World.instance:get(neighborCoord).item
      if unit then
        unit:damage(self.attacks[3].damage)
      end
    end
  end

end

return Metal