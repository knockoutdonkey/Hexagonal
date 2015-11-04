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

local mouseDown = false
local rDown = false
local fDown = false
function love.update(dt)

  if love.mouse.isDown('l') then
    if not mouseDown then
      controller:click(love.mouse.getPosition())
      mouseDown = true
    end
  else
    mouseDown = false
  end

  if love.keyboard.isDown('r')then
    if not rDown then
      controller:raise(love.mouse.getPosition())
      rDown = true
    end
  else
    rDown = false
  end

  if love.keyboard.isDown('f')then
    if not fDown then
      controller:lower(love.mouse.getPosition())
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