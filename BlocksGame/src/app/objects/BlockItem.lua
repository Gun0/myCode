local BlockItem = class("BlockItem", function()
    return display.newSprite("BlockItem")
end)
local Levels = require("app.Levels")

BlockItem.blockType = nil
function BlockItem:ctor()
    --BLOCKS_COUNT[PlayScene.level]
    
end

function BlockItem:createItem(level)
    local count = Levels.BLOCKS_COUNT[level]
    local type = math.random(1,count)
    self.blockType = Levels.BLOCKS_TYPE[type]
    print(self.blockType)
    self:setTexture("blocks/"..self.blockType..".png")
    self:setScale(1.0)
    self:setAnchorPoint(cc.p(0, 0));
end

function BlockItem:getBlockType()
    return self.blockType
end
return BlockItem