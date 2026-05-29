local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

vide.mount(function()
	local window = Window.new({ Title = "PixlLib" })

	window:CreateTab("Home", 15637376279)
	window:CreateTab("Farming", 15637359494)
	window:CreateTab("Shop", 15637380284)

	return window.node
end, playerGui)
