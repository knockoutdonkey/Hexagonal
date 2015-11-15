local Grenade = {}
setmetatable(Grenade, Item)

function Grenade:new(coord, damage, timer)

  -- Class setup
  local obj = Item:new(coord)
  setmetatable(obj, self)
  self.__index = self

  self.image = love.graphics.newImage('assets/units/grenade.png')

  obj.damage = damage
  obj.timer = timer or 2 -- # number of turns till explosion

  return obj
end

function Grenade:startTurn()
  self.timer = self.timer - 1
  if self.timer <= 0 then
    self:explode()
  end
end

function Grenade:explode()
  -- remove item from the game
  self:remove()

  -- damage surrounding neighbors by one less than damage
  for i, neighborCoord in ipairs(self.coord:getNeighbors()) do
    local tile = World.instance:get(neighborCoord)
    if tile.unit then
      tile.unit:damage(self.damage - 1)
    end
  end

  -- damage center and create crater
  local tile = World.instance:get(self.coord)
  tile:lower()
  if tile.unit then
    tile.unit:damage(self.damage)
  end
end

return Grenade