
require("config")
require("cocos.init")
require("framework.init")
require("app.Levels")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("PlayScene")
end

return MyApp
