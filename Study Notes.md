[TOC]

# 学习笔记

## Lua
#### continue
    for i = 1, 100 do
        while true do
            if i % 2 == 1 then break end
            -- 这里有一大堆代码
            --
            --
            break
    end

#### string
    aLeft =  string.byte("a")---97
     
    aRight = string.byte("abc",-1)---99

    string.char(97)---a
    string.len(s)

#### random
    math.randomseed(os.time())
    math.random(1,count)

## Quick-Cocos2d-x

#### 创建
* `return cc.Scene:create()`
* `return display.newScene("GameScene")`
* `local node = cc.Sprite:create("node.png")`

#### 监听事件
##### Node

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            self:addNode(self,event)
        end
    end)


    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,handler(self , self.update))

##### Touch

    self.pauseBtn:addTouchEventListener(handler(self,self.pause))

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
#### 转换坐标系
    local p = parent:convertToNodeSpace(cc.p(event.x,event.y))
    CCNode::convertToNodeSpace(CCPoint ptInWorld);
    CCNode::convertToWorldSpace(CCPoint ptInNode);

#### 设置锚点
    setAnchorPoint(cc.p(0, 0));

#### 读入csb
    local scene = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("MainScene.csb")
    scene:addTo(self)
    self.text = scene:getChildByName("countText")

#### gameData
    local GameData=require("app.GameData")

    self.data = GameData:new("data.txt", "1234",  "abcd")
    self.data:load()
    self.record = self.data:get("record")
    self.record = self.record or 0

    self.data:set("record", self.score)
    self.data:save()


#### 透明度
    item:setOpacity(0)