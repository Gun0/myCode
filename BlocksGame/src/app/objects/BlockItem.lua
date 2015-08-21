local BlockItem = class("BlockItem", function()
    return display.newSprite()
end)
local Levels = require("app.Levels")

BlockItem.blockType = nil
function BlockItem:ctor()
    --BLOCKS_COUNT[PlayScene.level]
end

function BlockItem:createItem(level,lastBlock)
    local count = Levels.BLOCKS_COUNT[level]
    self:setBlockType(count,lastBlock)
    self:setTexture("blocks/"..self.blockType..".png")
    self:setScale(1.0)
    self:setAnchorPoint(cc.p(0, 0));
end

function BlockItem:getBlockType()
    return self.blockType
end

function BlockItem:setBlockType(count,lastBlock)
    if lastBlock == nil then
        --print("init") 
        local type = math.random(1,count)
        self.blockType = Levels.BLOCKS_TYPE[type]
        --print("crruent:"..self.blockType)
    elseif string.len(lastBlock) == 1 then
        --print("1:"..lastBlock)
        local type = math.random(1,count)
        self.blockType = Levels.BLOCKS_TYPE[type]
        --print("crruent:"..self.blockType)
    elseif string.len(lastBlock) == 2 then
        --print("2:"..lastBlock)  
        repeat
            local type = math.random(1,count)
            self.temp = Levels.BLOCKS_TYPE[type]
        until string.len(self.temp) == 1
        
        self.blockType = self.temp
        --print("2 to 1:"..self.blockType)
    end
end

return BlockItem