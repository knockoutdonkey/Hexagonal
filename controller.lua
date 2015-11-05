local Controller = {}

function Controller:new()

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.selectedUnit = nil

  return obj
end

function Controller:mouseDown(pX, pY)
  local x, y = self:getScreenCoords(pX, pY)
  World.instance:get(x, y):select()
end

function Controller:mouseMove(pX, pY)
  local x, y = self:getScreenCoords(pX, pY)
  print(x, y)
end

function Controller:mouseUp(pX, pY)
  local x, y = self:getScreenCoords(pX, pY)
  World.instance:moveSelectedTo(x, y)
end

function Controller:rClick(pX, pY)
  local x, y = self:getScreenCoords(pX, pY)
  World.instance:get(x, y):raise()
end

function Controller:fClick(pX, pY)
  local x, y = self:getScreenCoords(pX, pY)
  World.instance:get(x, y):lower()
end

function Controller:getScreenCoords(pX, pY)
  local width = love.graphics:getWidth()
  local height = love.graphics:getHeight()
  return World.instance:transformToCoords(pX - width / 2, pY - height / 2)
end

return Controller