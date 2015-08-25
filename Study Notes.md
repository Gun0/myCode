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

#### repeat-until
    repeat
       statement(s)
    until( condition )
## Quick-Cocos2d-x

#### 创建
* `return cc.Scene:create()`
* `return display.newScene("GameScene")`
* `local node = cc.Sprite:create("node.png")`

#### 关闭
    app:exit()

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

    self:scheduleUpdate()

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

#### 转换坐标系
    local p = parent:convertToNodeSpace(cc.p(event.x,event.y))
    CCNode::convertToNodeSpace(CCPoint ptInWorld);
    CCNode::convertToWorldSpace(CCPoint ptInNode);
    
convertToWorldSpace 这个是将坐标转换到游戏世界坐标。因为一个精灵有一个坐标通过 getPosition来得到，但是这个坐标是一个相对于parent的坐标 所以实际的绝对坐标是取决于parent的position。所以通过`getParent():convertToWorldSpace()`就可以将这个坐标转换成游戏的绝对坐标。转换成世界坐标后 就可以和其他不在一个坐标系下的精灵转换到了同一个坐标系下 这样就可以进行坐标的计算了。计算完坐标 如果需要重新设置精灵的坐标 那么 这时候又要转换回相对坐标了（因为setPosition 也是设置的相对坐标） 这时候调用`getParent():convertToNodeSpace()`即可转换回来 调用setPosition来设置。

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

#### 延时
    performWithDelay(bullet,function() bullet:removeSelf() end,0.01)

#### transition
    local function move()
        self:moveToEnd(temp[k],startPos,endPos)
    end
                    
    local action = transition.sequence({
        cc.CallFunc:create(move)
    })
    self:runAction(action)

#### Spawn
    cc.Spawn:create(cc.RotateTo:create(1.3,90),cc.FadeOut:create(1.3))

#### back
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

#### plist动画

    cc.SpriteFrameCache:getInstance():addSpriteFrames("BM.plist")
    local boom = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("BM04.png"))
    local p = item:getParent():convertToWorldSpace(cc.p(item:getPosition()))

    local animation = cc.Animation:create()
    for i = 4, 9 do
        local file = string.format("BM%02d.png",i)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file)
        animation:addSpriteFrame(frame)
    end
    self.backgroundlayer.BOOM_OVER = false
    animation:setDelayPerUnit(1.0 / 15.0)

    local action = cc.Animate:create(animation)

#### Particle System
    local particle = cc.ParticleGalaxy:create()
    particle:setTexture(cc.Director:getInstance():getTextureCache():addImage("gray.png"))
    particle:setScale(0.3)
    particle:setLifeVar(0.5)
    
    particle:setPosVar(cc.p(200,200))
    particle:setRadialAccel(50)
    particle:setPosition(p.x,p.y)
    particle:addTo(self)

#### MusicManager
    local MusicManager = class("MusicManager")
    MusicManager.isSoundPlay = true

    function MusicManager:ctor()
        audio.preloadMusic("music/BGM.mp3")
        audio.preloadSound("music/LevelUp.wav")
    end

    function MusicManager:stopBGM()
        if audio.isMusicPlaying() then
            audio.stopMusic()
            audio.stopAllSounds()
            self.isSoundPlay = false
        end
    end

    function MusicManager:playBGM()
        if not audio.isMusicPlaying()then
            audio.playMusic("music/BGM.mp3", true)
        end
    end

    function MusicManager:levelUp()
        if self.isSoundPlay then
            audio.playSound("music/LevelUp.wav")
        end
    end

    function MusicManager:pauseBGM()
        if audio.isMusicPlaying() then
            self.isMusicPause = true
            audio.pauseMusic()
        end
    end

    function MusicManager:resumeBGM()
        if self.isMusicPause then
            self.isMusicPause = false
            audio.resumeMusic()
        end
    end

    return MusicManager