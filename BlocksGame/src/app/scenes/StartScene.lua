
local StartScene = class("StartScene", function()
    return display.newScene("StartScene")
end)

function StartScene:ctor()
    local scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("StartScene.csb")
    scene:addTo(self)
    scene:setScale(1)
    self:setTouchEnabled(true)
    self.backgroundImg = scene:getChildByName("backgroundImg")
    self.logoSprite = scene:getChildByName("logoSprite")
    self.gameImage = scene:getChildByName("gameImage")
    self.titleText = scene:getChildByName("titleText")
    
    self.startBtn = scene:getChildByName("startBtn")
    self.startBtn:setTouchEnabled(true)
    self.startBtn:addTouchEventListener(handler(self,self.startGame))
    
end

function StartScene:startGame(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        app:enterScene("PlayScene")
        return true
    end 
end

function StartScene:onEnter()
end

function StartScene:onExit()
end

return StartScene