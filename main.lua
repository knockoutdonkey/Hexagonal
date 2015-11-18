-- Terrain
World = require('World')
Tile = require('tile')

-- Units
Unit = require('units/unit')
Commando = require('units/commando')
Metal = require('units/metal')
WaterKnight = require('units/waterKnight')

-- Items
Item = require('items/item')
Grenade = require('items/grenade')

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

WaterBlast = require('attacks/waterKnight/waterBlast')
Storm = require('attacks/waterKnight/storm')

-- Utilities
Controller = require('controller')
ClickManager = require('clickManager')
SaveManager = require('saveManager')
HexCoord = require('hexCoord')
serialize = require('ser')

-- render correctly

function love.load(arg)

  math.randomseed(os.time())

  world = World:new()
  controller = Controller:new()
  clickManager = ClickManager:new()
  saveManager = SaveManager:new()

  love.graphics.setBackgroundColor(120, 170, 255)
end

local mouseDown = false
local rDown = false
local fDown = false
local gDown = false
local tDown = false
local sDown = false
local numDown = false
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

  if love.keyboard.isDown('t')then
    if not tDown then
      controller:tClick(love.mouse.getPosition())
      tDown = true
    end
  else
    tDown = false
  end

  if love.keyboard.isDown('g')then
    if not gDown then
      controller:gClick(love.mouse.getPosition())
      gDown = true
    end
  else
    gDown = false
  end

  if love.keyboard.isDown('s')then
    if not sDown then
      SaveManager.instance:saveLevel(World.instance, 1)
      print('saved')
      sDown = true
    end
  else
    sDown = false
  end

  if love.keyboard.isDown('1')then
    if not numDown then
      SaveManager.instance:loadLevel(World.instance, 1)
      print('loaded level 1')
      numDown = true
    end
  else
    numDown = false
  end
end

function love.draw(dt)
  local screenWidth = love.graphics:getWidth()
  local screenHeigth = love.graphics:getHeight()

  love.graphics.translate(screenWidth / 2, screenHeigth / 2)

  World.instance:draw()
end
-- love.filesystem.setIdentity('~/Practice/Lua/Hexagonal')

-- local data = love.filesystem.load('data/saveData.ser')()
-- data = serialize({x = 1, y = 2})
-- print(data)
-- print('saved', love.filesystem.write('data/saveData.ser', data))

if not love.filesystem.exists('saveData.ser') then
  love.filesystem.newFile('saveData.ser')
end

local data = serialize({x = 1})
-- print(love.filesystem.write('saveData.ser', data))
-- print(love.filesystem.read('saveData.ser'))