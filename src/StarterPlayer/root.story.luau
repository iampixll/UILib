local ReplicatedStorage = game:GetService("ReplicatedStorage")

local uilabs = require(ReplicatedStorage.Packages.uilabs)
local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local toggle = true

if toggle then
	return uilabs.CreateVideStory({
		vide = vide,
		controls = {},
	}, function(props)
		local window = Window.new({ Title = "PixlLib" })

		window:CreateTab("Home", 15637376279)
		window:CreateTab("Farming", 15637359494)
		window:CreateTab("Shop", 15637380284)

		return window.node
	end)
end
