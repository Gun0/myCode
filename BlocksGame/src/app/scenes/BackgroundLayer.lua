
BackgroundLayer = class("BackgroundLayer",function()
    return display.newLayer("BackgroundLayer")
end)

local Levels = require("app.Levels")
local PauseNode = require("app.scenes.PauseNode")
local BlockItem = require("app.objects.BlockItem")
BackgroundLayer.BOOM_OVER = true
BackgroundLayer.MOVE_OVER = true
BackgroundLayer.RORATE_OVER = true
BackgroundLayer.targets ={}
function BackgroundLayer:ctor()

end

function BackgroundLayer:initView(level)
    self.level = level
    if self.level > 15 then 
        self.BLOCKS_LIST = {
            ["-10"]=0,["-11"]=0,["-12"]=0,["-13"]=0,
            ["00"]=0,["01"]=0,["02"]=0,["03"]=0,
            ["10"]=0,["11"]=0,["12"]=0,["13"]=0,
            ["20"]=0,["21"]=0,["22"]=0,["23"]=0,
            ["30"]=0,["31"]=0,["32"]=0,["33"]=0,
            ["40"]=0,["41"]=0,["42"]=0,["43"]=0
        }
    elseif self.level <= 15 then 
        self.BLOCKS_LIST = {
            ["-10"]=0,["-11"]=0,["-12"]=0,
            ["00"]=0,["01"]=0,["02"]=0,
            ["10"]=0,["11"]=0,["12"]=0,
            ["20"]=0,["21"]=0,["22"]=0,
            ["30"]=0,["31"]=0,["32"]=0
        }
    end
    
    math.randomseed(os.time())
    
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
    self.frame = self.scene:getChildByName("frame")
    self.pauseBtn:addTouchEventListener(handler(self,self.pause))
    
    
    
    self:targetBlocks(self.level)
    self:initBlocks()
    self:initTouch()
    
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
        self:setGameBlock("01")
        
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setGameBlock("11")
        
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setGameBlock("21")
        
    elseif self.level > 1 and self.level <= 15 then
        local block = BlockItem:new()
        block:createItem(self.level)
        self.blockType = block:getBlockType()
        self:setGameBlock("11")
    elseif self.level > 15 then
        return ture
    end
    
end

function BackgroundLayer:initTouch()

    if self.level <= 15 then 
        for i = 1,3 do
            local pos = Levels.BLOCKS_TOUCH_1[i]
            local item = self.scene:getChildByName(pos)
            item:setTouchEnabled(true)
            item:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
                if event.name == "began" then
                    return true
                elseif event.name == "ended" then
                    if self:isColFill(pos,"down") then
                        return true 
                    else
                        self:pushDown(pos,event)
                    end
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
                    if self:isColFill(pos,"up") then
                        return true 
                    else
                        self:pushUp(pos,event)
                    end
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
                    if self:isColFill(pos,"down") then
                        return true 
                    else
                        self:pushDown(pos,event)
                    end
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
                    if self:isColFill(pos,"up") then
                        return true 
                    else
                        self:pushUp(pos,event)
                    end
                end
            end)
        end
    end

end

function BackgroundLayer:setTouchBlocksInvisiable()

    if self.level <= 15 then 
        for i = 1,3 do
            local pos = Levels.BLOCKS_TOUCH_1[i]
            local item = self.scene:getChildByName(pos)
            item:setOpacity(0)
        end
        for i = 4,6 do
            local pos = Levels.BLOCKS_TOUCH_1[i]
            local item = self.scene:getChildByName(pos)
            item:setOpacity(0)
        end
    elseif self.level > 15 then
        for i = 1,4 do
            local pos = Levels.BLOCKS_TOUCH_2[i]
            local item = self.scene:getChildByName(pos)
            item:setOpacity(0)
        end
        for i = 5,8 do
            local pos = Levels.BLOCKS_TOUCH_2[i]
            local item = self.scene:getChildByName(pos)
            item:setOpacity(0)
        end
    end

end

function BackgroundLayer:isActing()
    if self.BOOM_OVER == true and self.MOVE_OVER == true
        and self.RORATE_OVER == true then
        return false
    else
        return true
    end
end

function BackgroundLayer:setTouchBlock(pos)
    local item = self.scene:getChildByName(pos)
    item:setTexture("blocks/"..self.blockType..".png")
    self.BLOCKS_LIST[pos] = self.blockType
end

function BackgroundLayer:setGameBlock(pos)
    local item = self.frame:getChildByName(pos)
    item:setTexture("blocks/"..self.blockType..".png")
    self.BLOCKS_LIST[pos] = self.blockType
end

function BackgroundLayer:currentBlock()
    if self.level <= 15 then 
        for i,v in pairs(Levels.BLOCKS_TOUCH_1)do
            self:setTouchBlock(v)
        end
    elseif self.level > 15 then
        for i,v in pairs(Levels.BLOCKS_TOUCH_2)do
            self:setTouchBlock(v)
        end
    end
end

function BackgroundLayer:targetBlocks()
    if self.level <=2 then 
        for i,v in pairs(Levels.TARGET_POS_1)do
            local item = self.frame:getChildByName(v)
            item:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    elseif self.level > 2 and self.level <= 15 then
        for i,v in pairs(Levels.TARGET_POS_2)do
            local item = self.frame:getChildByName(v)
            item:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    elseif self.level >= 15 then 
        for i,v in pairs(Levels.TARGET_POS_3)do
            local item = self.frame:getChildByName(v)
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
        
        self:getParent().pauseNode  = PauseNode:new()
        self:getParent().pauseNode:setPosition(display.cx,display.cy)
        self:getParent().pauseNode:addTo(self)
        display.pause()
        return true
    end  
end


function BackgroundLayer:pushDown(pos,event)
    if cc.Director:getInstance():isPaused()or self:isActing()then
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
        temp[i] = self.BLOCKS_LIST[Levels.COL_DOWN[pos][count]]
        --self.BLOCKS_LIST[Levels.COL_DOWN[pos][count]] = 0
        --print(self.BLOCKS_LIST[Levels.COL_DOWN[pos][count]])
        count = count -1
    end
    count =  self.colNum
    local flag = 0
    for k = 1,#temp do
        if temp[k] ~= 0 then          
            local startPos = Levels.COL_DOWN[pos][self.colNum +1 - k]
            local endPos = Levels.COL_DOWN[pos][self.colNum - flag]
            local distance = math.abs(1-k+flag)
            flag = flag + 1
            
            self.BLOCKS_LIST[startPos] = 0       
            self:moveToEnd(temp[k],startPos,endPos,distance)
            self.BLOCKS_LIST[Levels.COL_DOWN[pos][count]] = temp[k]
            count = count -1
        end
    end
    print("downwnwnwnwwnwnwnwn")
    self:currentBlock()
    self:nextBlock()
end

function BackgroundLayer:pushUp(pos,event)
    if cc.Director:getInstance():isPaused()or self:isActing() then
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
            temp[i] = self.BLOCKS_LIST[Levels.COL_UP2[pos][count]]
            --self.BLOCKS_LIST[Levels.COL_UP2[pos][count]] = 0
        elseif self.level > 15 then
            temp[i] = self.BLOCKS_LIST[Levels.COL_UP[pos][count]]
            --self.BLOCKS_LIST[Levels.COL_UP[pos][count]] = 0
        end
        count = count -1
    end
    --dump(temp)
    --dump(self.BLOCKS_LIST)
    
    local flag = 0
    count =  self.colNum
    for k = 1,#temp do
        if temp[k] ~= 0 then
            if self.level <= 15 then
                local startPos = Levels.COL_UP2[pos][self.colNum +1 - k]
                local endPos = Levels.COL_UP2[pos][self.colNum - flag]
                local distance = math.abs(1-k+flag)
                flag = flag + 1
                self.BLOCKS_LIST[startPos] = 0
                    self:moveToEnd(temp[k],startPos,endPos,distance)
                    self.BLOCKS_LIST[Levels.COL_UP2[pos][count]] = temp[k]
                    count = count -1
            elseif self.level > 15 then
                local startPos = Levels.COL_UP[pos][self.colNum +1 - k]
                local endPos = Levels.COL_UP[pos][self.colNum - flag]
                local distance = math.abs(1-k+flag)
                flag = flag + 1
                self.BLOCKS_LIST[startPos] = 0
                self:moveToEnd(temp[k],startPos,endPos,distance)
                self.BLOCKS_LIST[Levels.COL_UP[pos][count]] = temp[k]
                count = count -1

            end
        end
    end

    print("upupupupupupupuppppppp")
    self:currentBlock()
    self:nextBlock()
end

function BackgroundLayer:moveToEnd(block,startPos,endPos,distance)
    local item1 = nil
    local p = nil
    self.MOVE_OVER = false
    if distance ~= 0 then 
        local blockImg = cc.Sprite:create("blocks/"..block..".png")
        if self.level <= 15 then
            blockImg:setScale(0.6)
            if startPos == "-10" or startPos == "-11" or startPos == "-12" 
                or startPos == "30" or startPos == "31" or startPos == "32"then
                item1 = self.scene:getChildByName(startPos)
                p = cc.p(item1:getPosition())
            else
                item1 = self.frame:getChildByName(startPos)
                self:getParent():updateOne(startPos)
                p = item1:getParent():convertToWorldSpace(cc.p(item1:getPosition()))
            end
        elseif self.level > 15 then
            blockImg:setScale(0.5)
            if startPos == "-10" or startPos == "-11" or startPos == "-12" or startPos == "-13"
                or startPos == "40" or startPos == "41" or startPos == "42" or startPos == "43" then
                item1 = self.scene:getChildByName(startPos)
                p = cc.p(item1:getPosition())
            else
                item1 = self.frame:getChildByName(startPos)
                self:getParent():updateOne(startPos)
                p = item1:getParent():convertToWorldSpace(cc.p(item1:getPosition()))
            end
        end
            print(block.."moveToend")
        blockImg:setPosition(p.x,p.y)
        blockImg:addTo(self.scene)
        local item2 = self.frame:getChildByName(endPos)
        local p2 = item2:getParent():convertToWorldSpace(cc.p(item2:getPosition()))
        local function remove()
            print(block.."remove")
            blockImg:removeSelf()
            self:getParent():update()
            self.MOVE_OVER = true
        end
        local action = transition.sequence({
            cc.MoveTo:create(distance/8,p2),
            cc.CallFunc:create(remove)
        })
    
        blockImg:runAction(action)
    end
end

function BackgroundLayer:isColFill(pos,type)
    if cc.Director:getInstance():isPaused()then
        return
    end
    local offSet = 0
    local scaleParam = 0
    self.flag = 1
    if self.level <= 15 then
        offSet = 70
        scaleParam = 0.3
        if type == "down" then 
            for i = 2,4 do
                if self.BLOCKS_LIST[Levels.COL_DOWN[pos][i]] == 0 then
                   self.flag = 0
                    offSet = 0
                end
            end
        elseif type == "up" then
            for i = 2,4 do 
                if self.BLOCKS_LIST[Levels.COL_UP2[pos][i]] == 0 then
                    self.flag = 0
                end
            end
        end 
    elseif self.level > 15 then
        offSet = 50
        scaleParam = 0.25
        if type == "down" then 
            for i = 2,5 do 
                if self.BLOCKS_LIST[Levels.COL_DOWN[pos][i]] == 0 then
                    self.flag = 0
                end
            end
        elseif type == "up" then
            for i = 2,5 do
                if self.BLOCKS_LIST[Levels.COL_UP[pos][i]] == 0 then
                    self.flag = 0
                end
            end
        end
    end
    if self.flag == 0 then
        return false
    else
        local item1 = self.scene:getChildByName(pos)
        local invalidImg = cc.Sprite:create("invalid.png")
        invalidImg:setScale(scaleParam)
        if type == "up" then
            invalidImg:setPosition(item1:getPositionX(),item1:getPositionY()+offSet)
        elseif type == "down" then
            invalidImg:setPosition(item1:getPositionX(),item1:getPositionY()-offSet)
        end
        invalidImg:addTo(self.scene)
        
        local function remove()
            invalidImg:removeSelf()
        end
        local action = transition.sequence({
            cc.FadeIn:create(0.5),
            cc.FadeOut:create(0.5),
            cc.CallFunc:create(remove)
        })
        invalidImg:runAction(action)
        return true
    end
end

return BackgroundLayer