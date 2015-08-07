local Bullet = class("Bullet", function()
    return display.newSprite("bullet.png")
end)
Bullet.speed  = 5
Bullet.bullet = nil
function Bullet:ctor()
	--self:createOneBullet()
end

function Bullet:createOneBullet(type,posx,posy)
    self:setPosition(posx, posy)
    self:setScale(0.2)
    if type == "player" then
        self:scheduleUpdateWithPriorityLua(handler(self, self.upBullte),1)
    elseif type == "enemy" then
       self:setRotation(180)
       self:scheduleUpdateWithPriorityLua(handler(self, self.downBullte),1)
    end
end


function Bullet:upBullte(dt)
    local x, y = self:getPosition()
    self:setPosition(x,y + self.speed)
end


function Bullet:downBullte(dt)
    local x, y = self:getPosition()
    self:setPosition(x,y - self.speed)
end

return Bullet