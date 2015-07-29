
local Player = class("Player", function()
    return display.newSprite("JitPlane.png")
end)
Player.player = nil
Player.hp = 3

function Player:ctor()
    self:createPlayer()
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.touchPlane))
    
    local beganp=nil

    local state = "Normal"
end
 
Player.buttleNum = 0

function Player:createPlayer()
    self:pos(display.cx,display.cy/4)
end

function Player:onHit(bglayer,type)
    if type == "enemy" then
        self.hp = self.hp - 1
        if self.hp > 0 then        
            bglayer.hpText:setString("X "..self.hp)
            return true
        elseif self.hp == 0 then         
            print("hp = 0")
            self.hp = 3
            bglayer.hpText:setString("X "..self.hp)
            return false
        end 
    elseif type == "heart" then
        self.hp = self.hp + 1
        bglayer.hpText:setString("X "..self.hp)
        return true
    end
end

function Player:touchPlane(event)
    if cc.Director:getInstance():isPaused() then
        return
    end
    if(event.name == "began") then
        self.beganp = cc.p(event.x,event.y)
        return true
    end
    if(event.name == "moved") then
        local pox = cc.pSub(cc.p(event.x,event.y), self.beganp)
        self.beganp = cc.p(event.x,event.y)
        self:setPosition(cc.pAdd(cc.p(self:getPositionX(),self:getPositionY()),pox))
    end

end

function Player:getPosition()
    return cc.p(self:getPositionX(),self:getPositionY())
end


function Player:update(dt)
        local buttlet = Bullet.new():createOneBullet(cc.p( self.player:getPosition().x,
        self:getPosition().y+20))
        buttlet:addTo(self)
end

return Player