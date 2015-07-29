local Bullet = class("Bullet", function()
    return display.newSprite("bullet.png")
end)
Bullet.speed  = 5
Bullet.bullet = nil
function Bullet:ctor()
	--self:createOneBullet()
end
--[[
function Bullet:create(param)
    local bullet = Bullet:new()
    for k,v in pairs(param) do
        bullet[k] = v
    end
    bullet:init()
    return bullet 
end
--]]
--function Bullet:createBullet(type,point,isTop)
--	if( isTop ) then
--		self:createOneBullet( type,point,point.x,display.top )
--	else
--		self:createOneBullet( type,point,point.x,display.bottom )
--	end
--
--	for i=1,count do
--		self:createByRotation( type,4*i,point,isTop )
--	end	
-- 	
-- 	local enemy1 = display.newSprite("bullet.png")
--    		:pos(display.cx,display.cy)
--    		:addTo(self)
--end


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
--    if Util.isOutside(self)then
--        --self:removeBullte()
--        --self:removeSelf()
--        GameScene.bullets[self] = nil
--    end
end


function Bullet:downBullte(dt)
    local x, y = self:getPosition()
    self:setPosition(x,y - self.speed)
end

return Bullet