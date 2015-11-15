local Item = {}

function Item:new(coord)

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.coord = coord
  World.instance:get(coord).item = obj
  table.insert(World.instance.items, obj)

  obj.image = love.graphics.newImage('assets/units/grenade.png')
  obj.image:setFilter('nearest', 'nearest')

  return obj
end

function Item:remove()
  World.instance:get(self.coord).item = nil
  World.instance:removeItem(self)
end

-- Overwrite this for start turn behavior
function Item:startTurn()

end

-- Overwrite this for unit behavior
function Item:touched(unit)

end

function Item:draw()
  love.graphics.setColor(255, 255, 255, 255)
  pixelX, pixelY = World.instance:transformToPixels(self.coord)
  love.graphics.draw(self.image, pixelX - self.image:getWidth() / 2, pixelY - self.image:getHeight() / 2 - Tile.side / 2 + 8)
end

return Item