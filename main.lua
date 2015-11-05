Tile = require('tile')
Controller = require('controller')
Unit = require('unit')
World = require('world')

-- render correctly

function love.load(arg)

  math.randomseed(os.time())

  world = World:new()
  controller = Controller:new()
end

local lMouseDown = false
local rMouseDown = false
local rDown = false
local fDown = false
function love.update(dt)

  if love.mouse.isDown('l') then
    if not lMouseDown then
      controller:leftClick(love.mouse.getPosition())
      lMouseDown = true
    end
  else
    lMouseDown = false
  end

  if love.mouse.isDown('r') then
    if not rMouseDown then
      controller:rightClick(love.mouse.getPosition())
      rMouseDown = true
    end
  else
    rMouseDown = false
  end

  if love.keyboard.isDown('r')then
    if not rDown then
      controller:rClick(love.mouse.getPosition())
      rDown = true
    end
  else
    rDown = false
  end

  if love.keyboard.isDown('f')then
    if not fDown then
      controller:fClick(love.mouse.getPosition())
      fDown = true
    end
  else
    fDown = false
  end

  if love.keyboard.isDown('up') and Tile.tilt < .99 then
    Tile.tilt = Tile.tilt + .01
  end

  if love.keyboard.isDown('down') and Tile.tilt > 0 then
    Tile.tilt = Tile.tilt - .01
  end
end

function love.draw(dt)
  local screenWidth = love.graphics:getWidth()
  local screenHeigth = love.graphics:getHeight()

  love.graphics.translate(screenWidth / 2, screenHeigth / 2)

  world:draw()
end