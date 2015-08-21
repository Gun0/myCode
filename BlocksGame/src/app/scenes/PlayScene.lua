local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

local BackgroundLayer = require("app.scenes.BackgroundLayer")
local Levels = require("app.Levels")
local GameoverNode = require("app.scenes.GameoverNode")
local PauseNode = require("app.scenes.PauseNode")
local GameData=require("app.GameData")

PlayScene.level = 16
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
    self:setKeypadEnabled(true)
    
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)
        if event.key == "back" then
            self:back()
        end
    end)
end

function PlayScene:back()
    print("back")
    dump(self.pauseNode)
    if cc.Director:getInstance():isPaused()then
        self.pauseNode:removeSelf()
        self.pauseNode = nil
        display.resume()
    else 
        self.pauseNode = PauseNode:new()
        self:addChild(self.pauseNode)
        display.pause()
    end
end


function PlayScene:update()
    print("update")
    
    if self.level <= 15 then 
        for i,v in pairs(Levels.TARGET_POS_2)do
            local item = self.backgroundlayer.frame:getChildByName(v)
            local item2 = self.backgroundlayer.backFrame:getChildByName(v)
            if self.backgroundlayer.BLOCKS_LIST[v] == 0 and self.backgroundlayer.targets[v] == 1 then 
                item:setTexture("blocks/black.png")
                item:setTexture("blocks/black.png")
            elseif self.backgroundlayer.BLOCKS_LIST[v] == 0 then
                item:setTexture("blocks/gray.png")
                item2:setTexture("blocks/gray.png")
            else
                item:setTexture("blocks/"..self.backgroundlayer.BLOCKS_LIST[v]..".png")
            end
        end
    elseif self.level > 15 then
        for i,v in pairs(Levels.TARGET_POS_3)do
            local item = self.backgroundlayer.frame:getChildByName(v)
            local item2 = self.backgroundlayer.backFrame:getChildByName(v)
            if self.backgroundlayer.BLOCKS_LIST[v] == 0 and self.backgroundlayer.targets[v] == 1 then 
                item:setTexture("blocks/black.png")
                item2:setTexture("blocks/black.png")
            elseif self.backgroundlayer.BLOCKS_LIST[v] == 0 then 
                item:setTexture("blocks/gray.png")
                item2:setTexture("blocks/gray.png")
            else
                item:setTexture("blocks/"..self.backgroundlayer.BLOCKS_LIST[v]..".png")
            end
        end
    end
    self:isRemoveable()
    self:isLost()
end

function PlayScene:updateOne(v)
    print("updateOne"..v)
    local item = self.backgroundlayer.frame:getChildByName(v)
    local item2 = self.backgroundlayer.backFrame:getChildByName(v)      
    if self.backgroundlayer.BLOCKS_LIST[v] == 0 and self.backgroundlayer.targets[v] == 1 then 
        item:setTexture("blocks/black.png")
        item2:setTexture("blocks/black.png")
    elseif self.backgroundlayer.BLOCKS_LIST[v] == 0 then
        item:setTexture("blocks/gray.png")
        item2:setTexture("blocks/gray.png")
    else
        item:setTexture("blocks/"..self.backgroundlayer.BLOCKS_LIST[v]..".png")
    end
end

function PlayScene:isWin()
    self.flag = 0
    for i,v in pairs(self.backgroundlayer.targets) do 
        self.flag = self.flag + v
    end
    
    if self.flag ~= 0 then 
        return false
    else
        if self.level < 24 then
            self.score = self.score + self.level * 100
            self.backgroundlayer:setScore(self.score)
            self:addLevel()
            print("win")
        elseif self.level == 24 then
            print("24")
        end
        return true
    end
end

function PlayScene:isLost()
    self.flag = 0
    for i,v in pairs(self.backgroundlayer.BLOCKS_LIST) do 
        if v == 0 then 
            self.flag = 1
        end
    end
    if self.flag ~= 0 then
        return false
    else
        self:initGameOver()
        return true
    end
end

function PlayScene:initGameOver()
    local gameoverNode  = GameoverNode:new()
    if self.score > self.record then
        gameoverNode:isNewRecord(true)
        self.record = self.score
        self.data:set("record", self.score)
        self.data:save()
    end
    gameoverNode:setRecordText(self.record)
    gameoverNode:setScoreText(self.score)
    gameoverNode:addTo(self)
end

function PlayScene:isRemoveable()
    self.removeList = {}
    if self.level <= 15 then
        for k = 1,3 do 
            for i = 2,3 do 
                local left = Levels.ROW_1[k][i-1]
                local right = Levels.ROW_1[k][i]
                local a = self.backgroundlayer.BLOCKS_LIST[left]
                local b = self.backgroundlayer.BLOCKS_LIST[right]
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
                local a = self.backgroundlayer.BLOCKS_LIST[left]
                local b = self.backgroundlayer.BLOCKS_LIST[right]
                if self:isEqual(a,b) then
                    self.removeList[left] = left
                    self.removeList[right] = right
                end
            end
        end
    end
    
    local flag = 0
    for i,v in pairs(self.removeList)do
        if v then
            flag =1
        end
    end
    
    if flag == 1 then 
        self:startRemove()
    else
        if self.backgroundlayer:isActing()then
            return
        else
            self:isWin()
        end
    end
end

function PlayScene:isEqual(a,b)
    if a == 0 or b == 0 then
        return false
    else
        local aRight = string.byte(a,-1)  
        local bLeft =  string.byte(b)
        if aRight == bLeft then
            return true
        else
            return false
        end
    end
end

function PlayScene:startRemove()
    self.boomCount = 0
    for i,v in pairs(self.removeList)do
        self.boomCount = self.boomCount + 1
        self:boomAnimation(i,v)
    end
end


function PlayScene:addLevel()
    self.backgroundlayer:setTouchBlocksInvisiable()
    self.backgroundlayer.RORATE_OVER = false
    
    local levelUpImg = cc.Sprite:create("levelup.png")
    levelUpImg:setPosition(display.cx,display.cy)
    levelUpImg:setScale(0.01)
    levelUpImg:addTo(self)
    
    local function remove()
        levelUpImg:removeSelf()
    end
    local showAction = transition.sequence({
        cc.ScaleTo:create(0.8,1.5),
        cc.FadeOut:create(0.5),
        cc.CallFunc:create(remove)
    })
    levelUpImg:runAction(showAction)
    
    local function initView()
        self.level = self.level + 1
        self.backgroundlayer = BackgroundLayer:new()
        self.backgroundlayer:initView(self.level)
        self.backgroundlayer:addTo(self,-4)
        self.backgroundlayer:setScore(self.score)
        self.backgroundlayer.RORATE_OVER = true
        return true
    end
    local rotateAction = cc.Spawn:create(cc.RotateTo:create(1.3,90),cc.FadeOut:create(1.3))

    local action = transition.sequence({
        rotateAction,
        cc.CallFunc:create(initView)
    })
    self.backgroundlayer.frame:runAction(action)
end

function PlayScene:boomAnimation(i,v)
    self.backgroundlayer.BOOM_OVER = false
    local pos = v
    local item = self.backgroundlayer.frame:getChildByName(pos)
    local p = item:getParent():convertToWorldSpace(cc.p(item:getPosition()))
    
    self.backgroundlayer.BLOCKS_LIST[v] = 0
    self.backgroundlayer.targets[v] = 0
    self.removeList[i] = nil
    
    local action = cc.FadeOut:create(0.5)
    
    local particle = cc.ParticleGalaxy:createWithTotalParticles(100)
    particle:setTexture(cc.Director:getInstance():getTextureCache():addImage("gray.png"))
    particle:setScale(0.3)
    particle:setLife(0.5)
    particle:setAngleVar(180)
    
    particle:setPosVar(cc.p(200,200))
    particle:setRadialAccel(50)
    particle:setPosition(p.x,p.y)
    particle:addTo(self)
    
    local function remove()
        self.score = self.score + 5 * self.level
        self.backgroundlayer:setScore(self.score)
        particle:removeSelf()
        item:setOpacity(255)
        
        self.boomCount = self.boomCount - 1
        if self.boomCount == 0 then
            self.backgroundlayer.BOOM_OVER = true
            self:update()
        end
    end
    
    local callfunc = cc.CallFunc:create(remove)
    item:runAction(cc.Sequence:create({action,callfunc}))
end

return PlayScene