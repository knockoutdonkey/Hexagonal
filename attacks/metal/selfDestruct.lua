SelfDestruct = {}
setmetatable(SelfDestruct, Attack)

function SelfDestruct:new(unit)

  local obj = Attack:new(unit, love.graphics.newImage('assets/attackIcons/SelfDestructIcon.png'))
  setmetatable(obj, self)
  self.__index = self

  obj.damage = 10

  return obj
end

-- able to hit all
function SelfDestruct:getRange()
  local neighbors = self.unit.coord:getAllWithin(2, 0)
  return neighbors
end

function SelfDestruct:perform(tile)
  self.unit:addStartTurnTask(function(selfUnit)
    local size = 2
    local height = World.instance:get(selfUnit.coord):getHeight()
    for i, neighborCoord in ipairs(selfUnit.coord:getAllWithin(size, 0)) do
      local tile = World.instance:get(neighborCoord)
      local unit = tile.unit
      if unit then
        unit:damage(selfUnit.attacks[4].damage)
      end

      local newHeight = height - size + selfUnit.coord:getDistance(neighborCoord)
      if newHeight < height then
        tile:setHeight(newHeight)
      end
    end
  end)
  return true
end

return SelfDestruct