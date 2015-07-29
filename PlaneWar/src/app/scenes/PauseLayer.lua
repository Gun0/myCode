
local PauseLayer = class("PauseLayer", function()
    return display.newLayer("PauseLayer")
end)

function PauseLayer:ctor()
    local scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("Layer.csb")
    self:addChild(scene)
    local img = scene:getChildByName("pauseImg")
    img:setScale(2.0)
    img:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return true
    end)
    local resumeBtn = scene:getChildByName("resumeBtn")
    resumeBtn:setPosition(display.cx,display.cy)
    resumeBtn:setScale(1.0)
    resumeBtn:addTouchEventListener(handler(self,self.resume))
    
end

function PauseLayer:resume(sender, touchType)
    if touchType == ccui.TouchEventType.began then
        return true
    elseif touchType == ccui.TouchEventType.ended then
        display.resume()
        self:removeSelf()
        print("hahahahhaa")
    end
end

function PauseLayer:onEnter()
end

function PauseLayer:onExit()
end

return PauseLayer