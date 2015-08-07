local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

local BackgroundLayer = require("app.scenes.BackgroundLayer")
local Levels = require("app.Levels")
local GameoverNode = require("app.scenes.GameoverNode")
local GameData=require("app.GameData")

PlayScene.level = 1
PlayScene.score = 0
PlayScene.record = 0


function PlayScene:ctor()

    self.data = GameData:new("data.txt", "1234",  "abcd")
    self.data:load()
    self.record = self.data:get("record")
    self.record = self.record or 0
    
    self.backgroundlayer = BackgroundLayer:new()
    self.backgroundlayer:initView(self.level)
    self.backgroundlayer:addTo(self,-4)
    --dump(Levels.BLOCKS_COUNT)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
    self:scheduleUpdate()
end



function PlayScene:update()
    if self.level <= 15 then 
        for i,v in pairs(Levels.TARGET_POS_2)do
            local item = self.backgroundlayer.scene:getChildByName(v)      
            if self.backgroundlayer.BLOCKS_LIST_1[v] == 0 and self.backgroundlayer.targets[v] == 1 then 
                item:setTexture("blocks/black.png")
            elseif self.backgroundlayer.BLOCKS_LIST_1[v] == 0 then 
                item:setTexture("blocks/gray.png")
            else
                item:setTexture("blocks/"..self.backgroundlayer.BLOCKS_LIST_1[v]..".png")
            end
        end
    elseif self.level > 15 then
        for i,v in pairs(Levels.TARGET_POS_3)do
            local item = self.backgroundlayer.scene:getChildByName(v)
            if self.backgroundlayer.BLOCKS_LIST_2[v] == 0 and self.backgroundlayer.targets[v] == 1 then 
                item:setTexture("blocks/black.png")
            elseif self.backgroundlayer.BLOCKS_LIST_2[v] == 0 then 
                item:setTexture("blocks/gray.png")
            else
                item:setTexture("blocks/"..self.backgroundlayer.BLOCKS_LIST_2[v]..".png")
            end
        end
    end
    --dump(dt)
    self:isRemoveable()
end

function PlayScene:isWin()
    self.flag = 0
    for i,v in pairs(self.backgroundlayer.targets) do 
        self.flag = self.flag + v
    end
    
    if self.flag ~= 0 then 
        return false
    else
        self:addLevel()
        return true
    end
    
    
end

function PlayScene:isLost()
    self.flag = 0
    if self.level <= 15 then
        for i,v in pairs(self.backgroundlayer.BLOCKS_LIST_1) do 
            if v == 0 then 
                self.flag = 1
            end
        end
    elseif self.level > 15 then
        for i,v in pairs(self.backgroundlayer.BLOCKS_LIST_2) do 
            if v == 0 then 
                self.flag = 1
            end
        end
    end
    if self.flag ~= 0 then 
        return false
    else
        local gameoverNode  = GameoverNode:new()
        if self.score > self.record then
            gameoverNode.cheerImg:setOpacity(255)
            self.record = self.score
            self.data:set("record", self.score)
            self.data:save()
        end
        
        local gameoverNode  = GameoverNode:new()
        gameoverNode:setPosition(display.cx,display.cy)
        gameoverNode:setRecordText(self.record)
        gameoverNode:setScoreText(self.score)
        gameoverNode:addTo(self)
        return true
    end
end

function PlayScene:isRemoveable()
    self.removeList = {}

    if self.level <= 15 then
        for k = 1,3 do 
            for i = 2,3 do 
--                print("k")
--                print(k)
--                print("i")
--                print(i)
                local left = Levels.ROW_1[k][i-1]
                local right = Levels.ROW_1[k][i]
                local a = self.backgroundlayer.BLOCKS_LIST_1[left]
                local b = self.backgroundlayer.BLOCKS_LIST_1[right]
                if self:isEqual(a,b) then
                    self.removeList[left] = left
                    self.removeList[right] = right
                end
            end
        end
        
    elseif self.level > 15 then
        for k = 1,4 do 
            for i = 2,4 do 
                local left = Levels.ROW_2[k][i-1]
                local right = Levels.ROW_2[k][i]
                local a = self.backgroundlayer.BLOCKS_LIST_2[left]
                local b = self.backgroundlayer.BLOCKS_LIST_2[right]
                if self:isEqual(a,b) then
                    self.removeList[left] = left
                    self.removeList[right] = right
                end
            end
        end
    
    end
    
    --dump(self.removeList)
    self:annimationRemove()
end

function PlayScene:isEqual(a,b)
    if a == 0 or b == 0 then
        return false
    else
        local aLeft ,aRight  
        aLeft =  string.byte(a)
        aRight = string.byte(a,-1)
    
        local bLeft ,bRight
        bLeft =  string.byte(b)
        bRight = string.byte(b,-1)
    
        if aRight == bLeft then
            return true
        else
            return false
        end
    end
end
function PlayScene:annimationRemove()
    for i,v in pairs(self.removeList)do
        if self.level <=2 then 
            self.backgroundlayer.BLOCKS_LIST_1[v] = 0
            self.removeList[i] = nil
            self.score = self.score + 5 * self.level
            self.backgroundlayer.targets[v] = 0
            dump(self.score)
            --dump(self.backgroundlayer.targets)
        elseif self.level > 2 and self.level <= 15 then
            self.backgroundlayer.BLOCKS_LIST_1[v] = 0
            self.removeList[i] = nil
            self.score = self.score + 5 * self.level
            self.backgroundlayer.targets[v] = 0
            dump(self.score)
            --dump(self.backgroundlayer.targets)
        elseif self.level > 15 then
            self.backgroundlayer.BLOCKS_LIST_2[v] = 0
            self.removeList[i] = nil
            self.score = self.score + 5 * self.level
            self.backgroundlayer.targets[v] = 0
            dump(self.score)
            --dump(self.backgroundlayer.targets)
        end
    end
    --dump(self.score)
    self:isWin()
    self:isLost()
end


function PlayScene:addLevel()
    self.level = self.level + 1
    self.backgroundlayer = BackgroundLayer:new()
    self.backgroundlayer:initView(self.level)
    self.backgroundlayer:addTo(self,-4)
    return true
end

return PlayScene