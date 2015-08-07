
BackgroundLayer = class("BackgroundLayer",function()
    return display.newLayer("BackgroundLayer")
end)
local Levels = require("app.Levels")
local PauseNode = require("app.scenes.PauseNode")
local BlockItem = require("app.objects.BlockItem")

BackgroundLayer.targets ={}
function BackgroundLayer:ctor()

end

function BackgroundLayer:initView(level)
    self.BLOCKS_LIST_2 = {
        ["-10"]=0,["-11"]=0,["-12"]=0,["-13"]=0,
        ["00"]=0,["01"]=0,["02"]=0,["03"]=0,
        ["10"]=0,["11"]=0,["12"]=0,["13"]=0,
        ["20"]=0,["21"]=0,["22"]=0,["23"]=0,
        ["30"]=0,["31"]=0,["32"]=0,["33"]=0,
        ["40"]=0,["41"]=0,["42"]=0,["43"]=0
    }

    self.BLOCKS_LIST_1 = {
        ["-10"]=0,["-11"]=0,["-12"]=0,
        ["00"]=0,["01"]=0,["02"]=0,
        ["10"]=0,["11"]=0,["12"]=0,
        ["20"]=0,["21"]=0,["22"]=0,
        ["30"]=0,["31"]=0,["32"]=0
    }
    
    math.randomseed(os.time())
    self.level = level
    if self.level >= 16 then
        self.scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("4_BackgroundLayer.csb")
    elseif self.level < 16 then
        self.scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("3_BackgroundLayer.csb")
    end
    self.scene:addTo(self)
    self.nextText = self.scene:getChildByName("nextText")
    self.nextImg = self.scene:getChildByName("nextImg")

    self.levelText = self.scene:getChildByName("levelText")
    self.levelCount = self.scene:getChildByName("levelCount")
    self.levelCount:setString(self.level)
    self.adSprite = self.scene:getChildByName("adSprite")

    self.pauseBtn = self.scene:getChildByName("pauseBtn")
    self.pauseBtn:addTouchEventListener(handler(self,self.pause))
    
    
    self:initTouch()
    
    self:initBlocks()
    self:targetBlocks(self.level)
    
    local cBlock = BlockItem:new()
    cBlock:createItem(level)
    self.blockType = cBlock:getBlockType()
    self:currentBlock()
    
    self:nextBlock(self.level)
    
    
end


function BackgroundLayer:initBlocks()
    if self.level == 1 then 
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setBlock("01")
        
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setBlock("11")
        
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setBlock("21")
        
    elseif self.level > 1 and self.level <= 15 then
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setBlock("11")
    elseif self.level > 15 then
        return ture
    end
end

function BackgroundLayer:initTouch()

    if self.level <= 15 then 
        for i = 1,3 do
            local pos = Levels.BLOCKS_TOUCH_1[i]
            local item = self.scene:getChildByName(pos)
            --item:setOpacity(0)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
                if event.name == "began" then
                    return true
                elseif event.name == "ended" then
                    self:pushDown(pos,event)
                end
            end)
        end
        for i = 4,6 do
            local pos = Levels.BLOCKS_TOUCH_1[i]
            local item = self.scene:getChildByName(pos)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
                if event.name == "began" then
                    return true
                elseif event.name == "ended" then
                    self:pushUp(pos,event)
                end
            end)
        end
    elseif self.level > 15 then
        for i = 1,4 do
            local pos = Levels.BLOCKS_TOUCH_2[i]
            local item = self.scene:getChildByName(pos)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
                if event.name == "began" then
                    return true
                elseif event.name == "ended" then
                    self:pushDown(pos,event)
                end
            end)
        end
        for i = 5,8 do
            local pos = Levels.BLOCKS_TOUCH_2[i]
            local item = self.scene:getChildByName(pos)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
                if event.name == "began" then
                    return true
                elseif event.name == "ended" then
                    self:pushUp(pos,event)
                end
            end)
        end
    end

end

function BackgroundLayer:setBlock(pos)
    local item = self.scene:getChildByName(pos)
    item:setTexture("blocks/"..self.blockType..".png")
    if self.level <= 15 then 
        self.BLOCKS_LIST_1[pos] = self.blockType
        --dump(Levels.BLOCKS_LIST_1)
    elseif self.level > 15 then
        self.BLOCKS_LIST_2[pos] = self.blockType
        --dump(Levels.BLOCKS_LIST_2)
    end
    
    
end

function BackgroundLayer:currentBlock()
    if self.level <= 15 then 
        for i,v in pairs(Levels.BLOCKS_TOUCH_1)do
            self:setBlock(v)
        end
    elseif self.level > 15 then
        for i,v in pairs(Levels.BLOCKS_TOUCH_2)do
            self:setBlock(v)
        end
    end
    
end

function BackgroundLayer:targetBlocks()
    if self.level <=2 then 
        for i,v in pairs(Levels.TARGET_POS_1)do
            local item = self.scene:getChildByName(v)
            item:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    elseif self.level > 2 and self.level <= 15 then
        for i,v in pairs(Levels.TARGET_POS_2)do
            local item = self.scene:getChildByName(v)
            item:setTexture("blocks/black.png")
            self.targets[v]=1
            
        end
    elseif self.level >= 15 then 
        for i,v in pairs(Levels.TARGET_POS_3)do
            local item = self.scene:getChildByName(v)
            item:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    end
end

function BackgroundLayer:nextBlock()
    local block = BlockItem:new()
    block:createItem(self.level)
    self.blockType = block:getBlockType()
    self.nextImg:setTexture("blocks/"..self.blockType..".png")
    return block
end



function BackgroundLayer:pause(sender, touchType)
    if cc.Director:getInstance():isPaused() then
        return
    end
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("pausssssssssssss")
        --self:getParent():update()
        
        local pauseNode  = PauseNode:new()
        pauseNode:setPosition(display.cx,display.cy)
        pauseNode:addTo(self)
        display.pause()
        return true
    end  
end


function BackgroundLayer:pushDown(pos,event)
    if cc.Director:getInstance():isPaused() then
        return
    end
    if self.level <= 15 then 
        self.colNum = 4
    elseif self.level > 15 then
        self.colNum = 5
    end
    local count = self.colNum
    local temp = {}
    for  i= 1,self.colNum do  
        if self.level <= 15 then 
            temp[i] = self.BLOCKS_LIST_1[Levels.COL_DOWN[pos][count]]
        elseif self.level > 15 then
            temp[i] = self.BLOCKS_LIST_2[Levels.COL_DOWN[pos][count]]
        end
        count = count -1
    end
    count =  self.colNum
    for k = 1,self.colNum do
            if temp[k] ~= 0 then
            if self.level <= 15 then
                self.BLOCKS_LIST_1[Levels.COL_DOWN[pos][count]] = temp[k]
            elseif self.level > 15 then
                self.BLOCKS_LIST_2[Levels.COL_DOWN[pos][count]] = temp[k]
            end
            count = count -1
            end
    end
    while count >0 do
        if self.level <= 15 then
            self.BLOCKS_LIST_1[Levels.COL_DOWN[pos][count]] = 0
        elseif self.level > 15 then
            self.BLOCKS_LIST_2[Levels.COL_DOWN[pos][count]] = 0
        end
        count = count -1
    end
    --dump(Levels.BLOCKS_LIST_2)
    print("downwnwnwnwwnwnwnwn")
    self:currentBlock()
    self:nextBlock()
end


function BackgroundLayer:pushUp(pos,event)
    if cc.Director:getInstance():isPaused() then
        return
    end
    if self.level <= 15 then 
        self.colNum = 4
    elseif self.level > 15 then
        self.colNum = 5
    end
    local count = self.colNum
    local temp = {}
    for  i= 1,self.colNum do  
        if self.level <= 15 then 
            temp[i] = self.BLOCKS_LIST_1[Levels.COL_UP2[pos][count]]
        elseif self.level > 15 then
            temp[i] = self.BLOCKS_LIST_2[Levels.COL_UP[pos][count]]
        end
        count = count -1
    end
    count =  self.colNum
    for k = 1,self.colNum do
        if temp[k] ~= 0 then
            if self.level <= 15 then
                self.BLOCKS_LIST_1[Levels.COL_UP2[pos][count]] = temp[k]
            elseif self.level > 15 then
                self.BLOCKS_LIST_2[Levels.COL_UP[pos][count]] = temp[k]
            end
            count = count -1
        end
    end
    while count >0 do
        if self.level <= 15 then
            self.BLOCKS_LIST_1[Levels.COL_UP2[pos][count]] = 0
        elseif self.level > 15 then
            self.BLOCKS_LIST_2[Levels.COL_UP[pos][count]] = 0
        end
        count = count -1
    end
    --dump(self.BLOCKS_LIST_2)
    print("upupupupupupupuppppppp")
    self:currentBlock()
    self:nextBlock()
end

function BackgroundLayer:isColFill()
    local invalidImg = cc.Sprite:create("invalid.png")
        
    invalidImg:setPosition(display.cx,display.cy)
    invalidImg:addTo(self.scene,-1)
end
return BackgroundLayer