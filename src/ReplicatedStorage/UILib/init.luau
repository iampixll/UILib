local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = require(ReplicatedStorage.UILib.Window)

local UILib = {}

function UILib:CreateWindow(config)
	return Window.new(config)
end

return UILib
