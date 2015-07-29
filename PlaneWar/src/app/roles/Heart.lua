local Heart = class("Heart", function()
    return display.newSprite("hp.png")
end)

Heart.speed  = 2
Heart.speedx  = 2
Heart.speedy  = 2
function Heart:ctor()
    self:createOneHeart()
end

function Heart:createOneHeart()
    self:setScale(0.06)
    self:pos(math.random(40,display.width - 40),display.height)
    self:scheduleUpdateWithPriorityLua(handler(self, self.downHeart),1)
end

function Heart:downHeart(dt)
    local x, y = self:getPosition()
    self:setPosition(x,y - self.speed)
end
return Heart