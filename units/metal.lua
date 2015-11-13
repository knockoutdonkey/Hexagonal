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

  -- for self destruct
  obj.selfDestructing = false

  obj:setUp()

  return obj
end

function Metal:startTurn()
  Unit.startTurn(self)

  -- blow up if self destructing
  if self.selfDestructing then

    local size = 2
    local height = World.instance:get(self.coord):getHeight()
    for i, neighborCoord in ipairs(self.coord:getAllWithin(size, 0)) do
      local tile = World.instance:get(neighborCoord)
      local unit = tile.item
      if unit then
        unit:damage(self.attacks[4].damage)
      end

      local newHeight = height - size + self.coord:getDistance(neighborCoord)
      if newHeight < height then
        tile:setHeight(newHeight)
      end
    end
  end

end

return Metal