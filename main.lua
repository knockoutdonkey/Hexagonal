-- Terrain
World = require('world')
Tile = require('tile')

-- Units
Unit = require('units/unit')
Commando = require('units/commando')
Metal = require('units/metal')
WaterKnight = require('units/waterKnight')

Grenade = require('units/grenade')

-- Attacks
Attack = require('attacks/attack')
NoAttack = require('attacks/noAttack')

LongShot = require('attacks/commando/longShot')
Knife = require('attacks/commando/knife')
GrenadeToss = require('attacks/commando/grenadeToss')
Outpost = require('attacks/commando/outpost')

SpinAttack = require('attacks/metal/spinAttack')
Bash = require('attacks/metal/bash')
Climb = require('attacks/metal/climb')
SelfDestruct = require('attacks/metal/selfDestruct')

-- Utilities
Controller = require('controller')
ClickManager = require('clickManager')
HexCoord = require('hexCoord')

-- render correctly

function love.load(arg)

  math.randomseed(os.time())

  world = World:new()
  controller = Controller:new()
  clickManager = ClickManager:new()
end

local mouseDown = false
local rDown = false
local fDown = false
function love.update(dt)

  if love.mouse.isDown('l') then
    if not mouseDown then
      mouseDown = true
      controller:mouseDown(love.mouse.getPosition())
    else
      controller:mouseMove(love.mouse.getPosition())
    end
  else
    if mouseDown then
      mouseDown = false
      controller:mouseUp(love.mouse.getPosition())
    end
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