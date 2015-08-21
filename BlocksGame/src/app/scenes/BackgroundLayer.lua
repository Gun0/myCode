
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
BackgroundLayer.aniRemove = {}
BackgroundLayer.blockType = nil
function BackgroundLayer:ctor()
    self.removeCount = 0 
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
    self.scoreCount = self.scene:getChildByName("scoreCount")
    self.levelFrame = self.scene:getChildByName("levelFrame")
    self.levelText:setLocalZOrder(200)
    self.levelCount:setLocalZOrder(200)
    self.scoreCount:setLocalZOrder(200)
    self.levelFrame:setLocalZOrder(150)
    
    self.levelCount:setString(self.level)
    self.adSprite = self.scene:getChildByName("adSprite")
    self.adSprite:setVisible(false)
    self.pauseBtn = self.scene:getChildByName("pauseBtn")
    self.frame = self.scene:getChildByName("frame")
    self.backFrame = self.scene:getChildByName("backFrame")
    
    self.pauseBtn:addTouchEventListener(handler(self,self.pause))
    
    self:targetBlocks(self.level)
    self:initBlocks()
    self:initTouch()
    
    local cBlock = BlockItem:new()
    cBlock:createItem(level,self.blockType)
    self.blockType = cBlock:getBlockType()
    self:currentBlock()
    
    self:nextBlock(self.level)
end

function BackgroundLayer:setScore(n)
    self.scoreCount:setString(n)
end

function BackgroundLayer:initBlocks()
    if self.level == 1 then 
        local block = BlockItem:new()
        block:createItem(self.level,self.blockType)
        self.blockType = block:getBlockType()
        self:setGameBlock("01")
        
        local block = BlockItem:new()
        block:createItem(self.level,self.blockType)
        self.blockType = block:getBlockType()
        self:setGameBlock("11")
        
        local block = BlockItem:new()
        block:createItem(self.level,self.blockType)
        self.blockType = block:getBlockType()
        self:setGameBlock("21")
        
    elseif self.level >= 2 and self.level <= 15 then
        local block = BlockItem:new()
        block:createItem(self.level,self.blockType)
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
    self.backFrame:setOpacity(0)
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
            local item2 = self.backFrame:getChildByName(v)
            item:setTexture("blocks/black.png")
            item2:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    elseif self.level > 2 and self.level <= 15 then
        for i,v in pairs(Levels.TARGET_POS_2)do
            local item = self.frame:getChildByName(v)
            local item2 = self.backFrame:getChildByName(v)
            item:setTexture("blocks/black.png")
            item2:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    elseif self.level >= 15 then 
        for i,v in pairs(Levels.TARGET_POS_3)do
            local item = self.frame:getChildByName(v)
            local item2 = self.backFrame:getChildByName(v)
            item:setTexture("blocks/black.png")
            item2:setTexture("blocks/black.png")
            self.targets[v]=1
        end
    end
end

function BackgroundLayer:nextBlock()
    local block = BlockItem:new()
    block:createItem(self.level,self.blockType)
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
        count = count -1
    end
    count =  self.colNum
    local flag = 0
    self.removeCount = 0
    for k = 1,#temp do
        if temp[k] ~= 0 then
            self.removeCount = self.removeCount + 1 
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
    self.removeCount = 0
    count =  self.colNum
    for k = 1,#temp do
        if temp[k] ~= 0 then
            self.removeCount = self.removeCount + 1
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
end

function BackgroundLayer:moveToEnd(block,startPos,endPos,distance)
    local item1 = nil
    local p = nil
    self.MOVE_OVER = false
    if distance ~= 0 then 
        local blockImg = cc.Sprite:create("blocks/"..block..".png")
        if self.level <= 15 then
            blockImg:setScale(0.8)
            if startPos == "-10" or startPos == "-11" or startPos == "-12" 
                or startPos == "30" or startPos == "31" or startPos == "32"then
                item1 = self.scene:getChildByName(startPos)
                self:pushAnimation(startPos,block)
                p = cc.p(item1:getPosition())
            else
                item1 = self.frame:getChildByName(startPos)
                self:getParent():updateOne(startPos)
                p = item1:getParent():convertToWorldSpace(cc.p(item1:getPosition()))
            end
        elseif self.level > 15 then
            blockImg:setScale(0.6)
            if startPos == "-10" or startPos == "-11" or startPos == "-12" or startPos == "-13"
                or startPos == "40" or startPos == "41" or startPos == "42" or startPos == "43" then
                item1 = self.scene:getChildByName(startPos)
                self:pushAnimation(startPos,block)
                p = cc.p(item1:getPosition())
            else
                item1 = self.frame:getChildByName(startPos)
                self:getParent():updateOne(startPos)
                p = item1:getParent():convertToWorldSpace(cc.p(item1:getPosition()))
            end
        end
        blockImg:setPosition(p.x,p.y)
        blockImg:addTo(self.scene)
        local item2 = self.frame:getChildByName(endPos)
        local p2 = item2:getParent():convertToWorldSpace(cc.p(item2:getPosition()))
        local function remove()
            blockImg:removeSelf()
            --self:getParent():updateOne(endPos)
            self.removeCount = self.removeCount - 1
            if self.removeCount == 0 then
                self.MOVE_OVER = true
                self:getParent():update()
            end
        end
        local action = transition.sequence({
            cc.MoveTo:create(distance/8,p2),
            cc.CallFunc:create(remove)
        })
    
        blockImg:runAction(action)
    else
        self.removeCount = self.removeCount - 1
    end
    
end

function BackgroundLayer:pushAnimation(pos,block)
    
    local item1 = self.scene:getChildByName(pos)
    item1:setOpacity(0)
    if self.level <= 15 then 
        for i,v in pairs(Levels.BLOCKS_TOUCH_1)do
            if v ~= pos then
                self:flyAway(v,pos,block) 
            end
        end
    elseif self.level > 15 then
        for i,v in pairs(Levels.BLOCKS_TOUCH_2)do
            if v ~= pos then
                self:flyAway(v,pos,block)
            end
        end
    end
    
    
    self:currentBlock()
    self:nextBlock()
    
    if self.level <= 15 then 
        for i,v in pairs(Levels.BLOCKS_TOUCH_1)do
            local item1 = self.scene:getChildByName(v)
            item1:setOpacity(0)
            
        end
    elseif self.level > 15 then
        for i,v in pairs(Levels.BLOCKS_TOUCH_2)do
            local item1 = self.scene:getChildByName(v)
            item1:setOpacity(0)
        end
    end

end
function BackgroundLayer:flyAway(v,pos,block)
    local item = self.scene:getChildByName(v)
    item:setOpacity(0)
    local p = cc.p(item:getPosition())
    local offset
    local blockImg = cc.Sprite:create("blocks/"..block..".png")
    if self.level <= 15 then
        blockImg:setScale(0.6)
        if v == "-10" or v == "-11" or v == "-12" then
            offset = 350
        elseif v == "30" or v == "31" or v == "32"then
            offset = -350
        end
    elseif self.level > 15 then
        blockImg:setScale(0.6)
        if v == "-10" or v == "-11" or v == "-12" or v == "-13"then
            offset = 300
        elseif v == "40" or v == "41" or v == "42" or v == "43"then
            offset = -300
        end
    end
    
    
    local p2 = cc.p(p.x,p.y + offset)
    blockImg:setPosition(p.x,p.y)
    blockImg:addTo(self.scene,100)
    local function remove()
        blockImg:removeSelf()
        
        if self.RORATE_OVER then
            item:setOpacity(255)
            local item1 = self.scene:getChildByName(pos)
            item1:setOpacity(255)
        end
    end
    local action = transition.sequence({
        cc.MoveTo:create(0.9,p2),
        cc.CallFunc:create(remove)
    })

    blockImg:runAction(action)
end

function BackgroundLayer:isColFill(pos,type)
    if cc.Director:getInstance():isPaused()then
        return
    end
    local offSet = 0
    local scaleParam = 0
    local wrongImg = nil
    local wrongImgList = {}
    self.flag = 1
    if self.level <= 15 then
        offSet = 100
        scaleParam = 1
        if type == "down" then 
            for i = 2,4 do
                if self.BLOCKS_LIST[Levels.COL_DOWN[pos][i]] == 0 then
                   self.flag = 0
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
        offSet = 80
        scaleParam = 0.7
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
        if self.level <= 15 then
            if type == "down" then 
                for i = 2,4 do
                    local temp = Levels.COL_DOWN[pos][i]
                    local tempItem = self.frame:getChildByName(temp)
                    p = self.scene:convertToWorldSpace(cc.p(tempItem:getPosition()))
                    wrongImg = cc.Sprite:create("wrong.png")
                    wrongImg:setPosition(p.x,p.y)
                    wrongImg:addTo(self.frame)
                    wrongImgList[wrongImg] = wrongImg
                end
            elseif type == "up" then
                for i = 2,4 do
                    local temp = Levels.COL_UP2[pos][i]
                    local tempItem = self.frame:getChildByName(temp)
                    p = self.scene:convertToWorldSpace(cc.p(tempItem:getPosition()))
                    wrongImg = cc.Sprite:create("wrong.png")
                    wrongImg:setPosition(p.x,p.y)
                    wrongImg:addTo(self.frame)
                    wrongImgList[wrongImg] = wrongImg
                end
            end 
        elseif self.level > 15 then
            offSet = 80
            scaleParam = 0.7
            if type == "down" then 
                for i = 2,5 do
                    local temp = Levels.COL_DOWN[pos][i]
                    local tempItem = self.frame:getChildByName(temp)
                    p = self.scene:convertToWorldSpace(cc.p(tempItem:getPosition()))
                    wrongImg = cc.Sprite:create("wrong.png")
                    wrongImg:setScale(0.75)
                    wrongImg:setPosition(p.x,p.y)
                    wrongImg:addTo(self.frame)
                    wrongImgList[wrongImg] = wrongImg
                end
            elseif type == "up" then
                for i = 2,5 do
                    local temp = Levels.COL_UP[pos][i]
                    local tempItem = self.frame:getChildByName(temp)
                    p = self.scene:convertToWorldSpace(cc.p(tempItem:getPosition()))
                    wrongImg = cc.Sprite:create("wrong.png")
                    wrongImg:setScale(0.75)
                    wrongImg:setPosition(p.x,p.y)
                    wrongImg:addTo(self.frame)
                    wrongImgList[wrongImg] = wrongImg
                end
            end
        end
        
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
            for i,v in pairs(wrongImgList) do
                wrongImgList[i] = nil
                v:removeSelf()
            end
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