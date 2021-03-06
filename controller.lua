local Controller = {}

function Controller:new()

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  obj.selectedUnit = nil

  return obj
end

function Controller:mouseDown(pX, pY)
  ClickManager.instance:click(pX, pY)
end

function Controller:mouseMove(pX, pY)
  local coord = self:getScreenCoord(pX, pY)
end

function Controller:mouseUp(pX, pY)
  ClickManager.instance:endClick(pX, pY)
end

function Controller:rClick(pX, pY)
  local coord = self:getScreenCoord(pX, pY)
  Game.instance:get(coord):raise()
end

function Controller:fClick(pX, pY)
  local coord = self:getScreenCoord(pX, pY)
  Game.instance:get(coord):lower()
end

function Controller:tClick(pX, pY)
  local coord = self:getScreenCoord(pX, pY)
  Game.instance:get(coord):addWater()
end

function Controller:gClick(pX, pY)
  local coord = self:getScreenCoord(pX, pY)
  Game.instance:get(coord):removeWater()
end

function Controller:getScreenCoord(pX, pY)
  local width = love.graphics:getWidth()
  local height = love.graphics:getHeight()
  return Game.instance:transformToCoords(pX - width / 2, pY - height / 2)
end

return Controller