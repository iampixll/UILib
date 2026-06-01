local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = require(ReplicatedStorage.PixlLib.Window)

local PixlLib = {}

function PixlLib:CreateWindow(config)
	return Window.new(config)
end

return PixlLib
