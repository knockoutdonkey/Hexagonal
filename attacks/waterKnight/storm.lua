Storm = {}
setmetatable(Storm, Attack)

function Storm:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/StormIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 1

  return obj
end

-- able to hit all
function Storm:getRange()
  return self.unit.coord:getAllWithin(1, 0)
end

function Storm:perform(tile)
  local neighbors = self:getRange()

  for i, neighbor in ipairs(neighbors) do
    local tile = World.instance:get(neighbor)
    if tile.unit and not tile.coord:equals(self.unit.coord) then
      tile.unit:damage(self.damage)
    end
    tile:addWater()
  end

  return true
end

return Storm