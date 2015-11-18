local SaveManager = {}

SaveManager.instance = nil
SaveManager.levelDir = 'level'

function SaveManager:new()

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  self.instance = obj

  -- create directory if it doesn't exist
  if not love.filesystem.exists(self.levelDir) then
    love.filesystem.createDirectory(self.levelDir)
  end

  return obj
end

-- returns true if level data exists, false otherwise
function SaveManager:loadLevel(world, num)
  local path = self.levelDir..'/level'..num..'.lua'
  local data = loadstring(love.filesystem.read(path))()

  if data then
    World:new(data)
  else
    print('no data found for level '..num)
  end
end

function SaveManager:saveLevel(world, num)
  local data = serialize(self:getLevelData(world))
  local path = self.levelDir..'/level'..num..'.lua'

  if not love.filesystem.exists(path) then
    love.filesystem.newFile(path)
  end
  love.filesystem.write(path, data)
end

function SaveManager:getLevelData(world)
  -- print(love.filesystem.write('saveData.ser', data))
  -- print(love.filesystem.read('saveData.ser'))
  local grid = {}
  for x = -world.size, world.size do
    grid[x] = {}

    for y = -world.size, world.size do
      local tile = world:get(HexCoord:new(x, y))
      grid[x][y] = {height = tile.height, waterLevel = tile.waterLevel}
    end
  end
  return grid
end

return SaveManager