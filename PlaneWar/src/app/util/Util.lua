local Util = class("Util")

Util.WIDTH = 640.00
Util.HEIGHT = 960.00

function Util.isOutside(obj)
    local x = obj:getPositionX()
    local y = obj:getPositionY()
    if x <= -30 or x >= Util.WIDTH + 30 or y <= -30 or y >= Util.HEIGHT + 30 then
        --obj:removeSelf()
        return true
    else 
        return false
    end
end
return Util