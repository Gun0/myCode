GameoverNode = class("GameoverNode",function()
    return display.newNode("GameoverNode")
end)

function GameoverNode:ctor()
    self.scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("GameoverNode.csb")
    self.scene:addTo(self)

    self.scoreText = self.scene:getChildByName("scoreText")
    self.cheerImg = self.scene:getChildByName("cheerImg")

    self.recordText = self.scene:getChildByName("recordText")
    self.recordImg = self.scene:getChildByName("recordImg")
    self.cheerImg:setOpacity(0)
    self.scoreText:setString("My Score ".."0")
    self.recordText:setString("My Record ".."0")
    
    self.shareBtn = self.scene:getChildByName("shareBtn")
    self.shareBtn:addTouchEventListener(handler(self,self.share))
    
    self.homeBtn = self.scene:getChildByName("homeBtn")
    self.homeBtn:addTouchEventListener(handler(self,self.backHome))
    
    self.exitBtn = self.scene:getChildByName("exitBtn")
    self.exitBtn:addTouchEventListener(handler(self,self.exitGame))
end

function GameoverNode:share(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("shareeeeeeeeeee")
        --display.pause()
        return true
    end  
end
function GameoverNode:setRecordText(record)
    self.recordText:setString("My Record "..record)
end

function GameoverNode:setScoreText(score)
    self.scoreText:setString("My Score "..score)
end

function GameoverNode:backHome(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("homeeeeeeeeeeeee")
        display.resume()
        app:enterScene("StartScene")
        self:removeSelf()
        return true
    end  
end

function GameoverNode:exitGame(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("exitGame")
        app:exit()
        return true
    end 
end

return GameoverNode