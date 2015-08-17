PauseNode = class("PauseNode",function()
    return display.newNode("PauseNode")
end)

function PauseNode:ctor()
    self.pauseNode = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("PauseNode.csb")
    self.pauseNode:addTo(self)
    
    self.resumeBtn = self.pauseNode:getChildByName("resumeBtn")
    self.resumeBtn:addTouchEventListener(handler(self,self.resume))
    self.homeBtn = self.pauseNode:getChildByName("homeBtn")
    self.homeBtn:addTouchEventListener(handler(self,self.backHome))
    
    self.exitBtn = self.pauseNode:getChildByName("exitBtn")
    self.exitBtn:addTouchEventListener(handler(self,self.exitGame))
end

function PauseNode:resume(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("resumeeeeeeeeeee")
        self:removeSelf()
        display.resume()
        return true
    end  
end
function PauseNode:backHome(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("homeeeeeeeeeeeee")
        app:enterScene("StartScene")
        self:removeSelf()
        display.resume()
        return true
    end  
end

function PauseNode:exitGame(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("exitGame")
        app:exit()
        return true
    end 
end
return PauseNode