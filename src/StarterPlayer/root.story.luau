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

		local home = window:CreateTab("Home", 15637376279)
		local farm = window:CreateTab("Farming", 15637359494)
		local shop = window:CreateTab("Shop", 15637380284)

		home:CreateButton({
			Name = "TestButton",
			Callback = function() end,
		})

		local button
		button = home:CreateButton({
			Name = "click me",
			Callback = function()
				button:Set("Clicked!")
			end,
		})

		return window.node
	end)
end
