local ClickManager = {}

ClickManager.instance = nil

function ClickManager:new()

  local obj = {}
  setmetatable(obj, self)
  self.__index = self

  self.instance = obj

  -- enter attack mode on on attack button click, leave after an attack is performed
  self.attackMode = false

  return obj
end

function ClickManager:click(pX, pY)

  -- check if a tile is clicked
  local coord = Controller:getScreenCoord(pX, pY)
  local tile = World.instance:get(coord)
  if Tile.selected ~= tile and tile.coord.x ~= 1000 then
    tile:select()
  end

  -- TODO: check for click on top of tile, instead of bottem
  for i = World.size, -World.size, -1 do

  end

end

function ClickManager:endClick(pX, pY)

  -- first, check if a button is clicked (just attack buttons for now)
  local width = love.graphics:getWidth()
  local height = love.graphics:getHeight()

  local attackBorder = 70
  local attackSize = 60
  local buttonClicked = false
  if Unit.selected then
    for i, attack in ipairs(Unit.selected.attacks) do
      if math.abs(pX - attackBorder * i) < attackSize / 2 and
         math.abs(pY - height + attackBorder) < attackSize / 2 then
        World.instance:showAttackRange(i)
        buttonClicked = true
      end
    end
  end

  -- peform an attack or move selected character
  local coord = Controller:getScreenCoord(pX, pY)
  if World.instance.selectedAttack then
    if not buttonClicked then
      World.instance:attack(coord)
    end
  else
    World.instance:moveSelectedTo(coord)
  end
end

return ClickManager