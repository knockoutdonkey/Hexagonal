local Controller = {}

function Controller:new()

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.selectedUnit = nil

  return obj
end

function Controller:click(pX, pY)
  local width = love.graphics:getWidth()
  local height = love.graphics:getHeight()

  local x, y = World.instance:transformToCoords(pX - width / 2, pY - height / 2)
  World.instance:get(x, y):select()
end

function Controller:raise(pX, pY)
  local width = love.graphics:getWidth()
  local height = love.graphics:getHeight()

  local x, y = World.instance:transformToCoords(pX - width / 2, pY - height / 2)
  World.instance:get(x, y):raise()
end

function Controller:lower(pX, pY)
  local width = love.graphics:getWidth()
  local height = love.graphics:getHeight()

  local x, y = World.instance:transformToCoords(pX - width / 2, pY - height / 2)
  World.instance:get(x, y):lower()
end

return Controller