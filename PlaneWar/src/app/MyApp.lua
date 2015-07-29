
require("config")
require("cocos.init")
require("framework.init")
require("app.scenes.init")
require("app.roles.init")
require("app.init")
local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("GameScene")
end

return MyApp
