local GameData = class("GameData")

local GameState = require("framework.cc.utils.GameState")

function GameData:ctor(path, secretKey, encryptKey)
    self.data = {}
    GameState.init(function(param)
        local val = nil
        if not param.errorCode then
            if param.name == "save" then
                local str = json.encode(param.values)
                if encryptKey then
                    str = crypto.encryptXXTEA(str, encryptKey)
                end
                val = {data = str}
            elseif param.name == "load" then
                local str = param.values.data
                if encryptKey then
                    str = crypto.decryptXXTEA(str, encryptKey)
                end
                val = json.decode(str)
            end
        end
        return val
    end, path, secretKey)
end

function GameData:load()
    self.data = GameState.load()
    if not self.data then
        self.data = {}
    end
end

function GameData:save()
    GameState.save(self.data)
end

function GameData:set(key, value)
    self.data[key] = value
end

function GameData:get(key, default, needSave)
    local val =  self.data[key]
    if not val and default then
        val = default
        self.data[key] = val
        if needSave then
            self:save()
        end
    end
    return val
end

function GameData:dump()
    dump(self.data, "GameData")
end

return GameData