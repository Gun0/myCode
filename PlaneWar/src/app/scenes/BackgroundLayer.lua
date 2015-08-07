local PauseLayer = require("app.scenes.PauseLayer")
BackgroundLayer = class("BackgroundLayer",function()
    return display.newLayer("BackgroundLayer")
end)


BackgroundLayer.text = nil
BackgroundLayer.pauseBtn = nil
BackgroundLayer.state = "normal"
BackgroundLayer.score = 0
BackgroundLayer.hpText = nil
BackgroundLayer.hp = 3

function BackgroundLayer:ctor()
    local scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("MainScene.csb")
    scene:addTo(self)
    self.anis = {}
    self.text = scene:getChildByName("countText")
    self.text:pos(300,900)
    --:addTo(self)
    
    local hpImage = scene:getChildByName("hpImg")
    hpImage:pos(50,900)
    
    self.hpText = scene:getChildByName("hpText")
    self.hpText:pos(100,900)
    
    self.pauseBtn = scene:getChildByName("pauseButton")
    self.pauseBtn:loadTextureNormal("pause.png")
    --dump(self.pauseBtn)
    self.pauseBtn:pos(display.width-60, 40)
    self.pauseBtn:setScale(0.5)
    self.pauseBtn:setTouchEnabled(true)
    --self.pauseBtn:addTo(self)
    self.pauseBtn:addTouchEventListener(handler(self,self.pause))
    self:setTouchEnabled(true)
    self.name = 1
    self:setName("scene")
    
    self.distanceBg = {}
    self.nearbyBg = {}
    self.tiledMapBg = {}
     
    self:createBackgrounds()
     
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
    self:scheduleUpdate()
end


function BackgroundLayer:createBackgrounds()
	local bg = display.newSprite("background.png")
		:pos(display.cx, display.cy)
		:addTo(self, -4)

	-- 创建远景背景
	local bg1 = display.newSprite("background.png")
    	:align(display.BOTTOM_LEFT, display.left + 22 , display.bottom)
    	:addTo(self, -3)
	local bg2 = display.newSprite("background.png")
    	:align(display.BOTTOM_LEFT, display.left + 22 , display.bottom + bg1:getContentSize().height)
    	:addTo(self, -3)

	table.insert(self.distanceBg, bg1) -- 把创建的bg1插入到了 self.distanceBg 中
	table.insert(self.distanceBg, bg2) -- 把创建的bg2插入到了 self.distanceBg 中
end


function BackgroundLayer:scrollBackgrounds(dt)
 
    if self.distanceBg[2]:getPositionY() <= 0 then
        self.distanceBg[1]:setPositionY(0)
    end
 
    local y1 = self.distanceBg[1]:getPositionY() - 70*dt -- 50*dt 相当于速度
    local y2 = y1 + self.distanceBg[1]:getContentSize().height 
 
    self.distanceBg[1]:setPositionY(y1)
    self.distanceBg[2]:setPositionY(y2)
end

function BackgroundLayer:pause(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        if self.state == "normal" then
            display.pause()
            self.state = "pause"
            self.pauseBtn:loadTextureNormal("resume.png")
            --local pauseLayer = PauseLayer:new()
            --pauseLayer:addTo(self,1)
        elseif  self.state == "pause" then
            display.resume()
            self.state = "normal"
            self.pauseBtn:loadTextureNormal("pause.png")      
        end
        return true
    end  
end


function BackgroundLayer:addScore()
    self.score = self.score + 1
    self.text:setString("Score:"..self.score)
end


return BackgroundLayer