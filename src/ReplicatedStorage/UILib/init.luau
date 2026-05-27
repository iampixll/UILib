local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local playerGui = Players.LocalPlayer.PlayerGui

local UILib = {}

function UILib:CreateWindow(config)
	local window = {}

	local function CreateTab() end

	window.CreateTab = CreateTab

	vide.mount(function()
		return Window(config)
	end, playerGui)
	return window
end

return UILib
