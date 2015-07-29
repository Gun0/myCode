local Enemy1 = class("Enemy1", function()
    return display.newSprite("Enemy1.png")
end)
Enemy1.enemy1 = nil
Enemy1.targetX = nil
Enemy1.targetY = nil
Enemy1.speed  = 2
Enemy1.speedx  = 2
Enemy1.speedy  = 2
function Enemy1:ctor()
    local type = math.random(0,9)
	self:createEnemy1(type)
end
 
function Enemy1:createEnemy1(type)
    if type >= 5 then 
        self:setTexture("Enemy2.png")
        self.speed = 4
    end
    self:pos(math.random(0,display.width),display.height)
    self:setScale(0.7)
    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:scheduleUpdateWithPriorityLua(handler(self, self.step),1)	
end

function Enemy1:targetPos(posx,posy)
    self.targetX = posx
    self.targetY = posy
    local x, y = self:getPosition()
    local radians = math.atan2(self.targetY - y, self.targetX - x)
    self.speedx = math.cos(radians) * self.speed
    self.speedy = math.sin(radians) * self.speed
end

function Enemy1:step(dt)
    local x, y = self:getPosition()
    self:setPosition(x + self.speedx,y + self.speedy)
end

return Enemy1
