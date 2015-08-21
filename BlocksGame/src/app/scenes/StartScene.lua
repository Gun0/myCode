
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
    self.startBtn:addTouchEventListener(handler(self,self.startGame))
    
    self.musicBtn = scene:getChildByName("musicBtn")
    self.musicBtn:addTouchEventListener(handler(self,self.musicCtrl))
    
    self.moreBtn = scene:getChildByName("moreBtn")
    self.moreBtn:addTouchEventListener(handler(self,self.moreGame))
    
    self.noadsBtn = scene:getChildByName("noadsBtn")
    self.noadsBtn:addTouchEventListener(handler(self,self.noAds))
    self:setKeypadEnabled(true)
    
    self:addNodeEventListener(cc.KEYPAD_EVENT, function (event)  
        if event.key == "back" then  
            print("back")  
            device.showAlert("Confirm Exit", "Are you sure exit game ?", {"YES", "NO"}, function (event)  
                if event.buttonIndex == 1 then  
                    app:exit()
                else  
                    device.cancelAlert()   
                end  
            end) 
        end        
    end)
end

function StartScene:startGame(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        app:enterScene("PlayScene")
        return true
    end 
end

function StartScene:musicCtrl(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("musiccccccccccccccc")
        return true
    end 
end
function StartScene:moreGame(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("more gameeeeeeeeee")
        return true
    end 
end
function StartScene:noAds(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        print("no adsssssssssss")
        return true
    end 
end
function StartScene:onEnter()
end

function StartScene:onExit()
end

return StartScene