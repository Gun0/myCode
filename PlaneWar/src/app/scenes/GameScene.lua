
local GameScene = class("GameScene", function()
    --return cc.Scene:create()
    return display.newScene("GameScene")
end)

local Player = require("app.roles.Player")
local Enemy1 = require("app.roles.Enemy1")
local Bullet = require("app.roles.Bullet")
local Heart  = require("app.roles.Heart")
--local BackgroundLayer = require("app.scenes.BackgroundLayer")
--constructor
GameScene.palyerX = nil
GameScene.palyerY = nil
GameScene.bullets = {}
GameScene.enemys = {}
GameScene.hearts = {}
GameScene.count = 0
GameScene.player  = nil
GameScene.enemy = nil
function GameScene:ctor()

    self.backgroundLayer = BackgroundLayer:new()    
    	:addTo(self,-4)

    self.player = Player:new()
    	:addTo(self,-2)
    
    self:schedule(handler(self, self.addPlayerBullet),0.2)
    self:schedule(handler(self, self.addEnemy1),2)
    self:schedule(handler(self, self.addHeart),20)
    
    
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT,handler(self , self.update))
    self:scheduleUpdate()
end

function GameScene:update(dt)
    for bKey,bullet_ in pairs(self.bullets) do
        for eKey,enemy_ in pairs(self.enemys) do
            if cc.rectIntersectsRect(bullet_:getBoundingBox(),enemy_:getBoundingBox()) then
                local x,y = enemy_:getBoundingBox().x,enemy_:getBoundingBox().y
                self:onHitEnemy(enemy_,x,y)
                self:removeBullet(bullet_)
                return true
            end
            
            if Util.isOutside(bullet_)then
                self:removeBullet(bullet_)
            end
            if Util.isOutside(enemy_)then
                self:removeEnemy(enemy_)
            end
        end
     end

     for eKey,enemy_ in pairs(self.enemys) do
        if cc.rectIntersectsRect(self.player:getBoundingBox(),enemy_:getBoundingBox()) then
            local x,y = enemy_:getBoundingBox().x,enemy_:getBoundingBox().y
            self:onHitEnemy(enemy_,x,y)
            if self.player:onHit(self.backgroundLayer,"enemy") then
                return true
            else 
                local posx = self.player:getPosition().x + 40
                local posy = self.player:getPosition().y + 40
                self:boomAnimation(posx,posy)
                self.player:removeSelf()
                --display:pause()
                self.player = Player:new()
                    :addTo(self,-2)
                --self:unScheduleUpdate()
            end
        end
     end
  
    for hKey,heart_ in pairs(self.hearts) do
        if cc.rectIntersectsRect(self.player:getBoundingBox(),heart_:getBoundingBox()) then
            
            self.player:onHit(self.backgroundLayer,"heart")
            self.hearts[hKey] = nil
            heart_:removeSelf()
        end
        
        if Util.isOutside(heart_)then
            self.hearts[heart_] = nil
            heart_:removeSelf()
        end
        
    end
end

function GameScene:addPlayerBullet(dt)
    local palyerX = self.player:getPosition().x
    local palyerY = self.player:getPosition().y
    local bullet = Bullet:new()
    bullet:createOneBullet("player",palyerX,palyerY+50)
    bullet:addTo(self,-3)
    self.bullets[bullet] = bullet
end

function GameScene:addEnemyBullet(enemy)
    local enemyX = enemy:getPositionX()
    local enemyY = enemy:getPositionY()
    local bullet = Bullet:new()
    bullet:createOneBullet("enemy",enemyX,enemyY-20)
    bullet:addTo(self,-3)
    
    self.enemys[bullet]= bullet
end


function GameScene:addHeart(dt)
    local heart = Heart:new()
    heart:addTo(self,-3)
    self.hearts[heart] = heart
end


function GameScene:boomAnimation(posx,posy)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("BM.plist")
    local boom = cc.Sprite:createWithSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("BM04.png"))
    boom:pos(posx,posy):addTo(self)

    local animation = cc.Animation:create()
    for i = 4, 9 do
        local file = string.format("BM%02d.png",i)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file)
        animation:addSpriteFrame(frame)
    end
    animation:setDelayPerUnit(1.0 / 6.0)

    local action = cc.Animate:create(animation)
    local function remove()
        boom:removeSelf()
    end
    
    local callfunc = cc.CallFunc:create(remove)
    boom:runAction(cc.Sequence:create(action,callfunc))
end


function GameScene:removeBullet(bKey)
    self.bullets[bKey] = nil
    bKey:removeSelf()
end

function GameScene:removeEnemy(eKey)
    self.enemys[eKey] = nil
    eKey:removeSelf()
end

function GameScene:getPlayer()
    return self.player
end

function GameScene:addEnemy1(dt)
    local enemy1 = Enemy1:new()
    self:addEnemyBullet(enemy1)
    local palyerX = self.player:getPosition().x
    local palyerY = self.player:getPosition().y    
    enemy1:targetPos(palyerX,palyerY)
    enemy1:addTo(self,-3)
    self.enemys[enemy1] = enemy1
end



function GameScene:onHitEnemy(enemy,x,y)
    local posx = x + 40
    local posy = y + 40

    self:boomAnimation(posx,posy)
    self:removeEnemy(enemy)
    self.count = self.count + 1
    self.backgroundLayer:addScore()
end

return GameScene