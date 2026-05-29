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

		home:CreateLabel("Label text")

		local paragraph = home:CreateParagraph({
			Title = "Hello",
			Content = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et",
		})

		home:CreateButton({
			Name = "Auto Farm",
			Callback = function() end,
		})

		home:CreateDivider("Div")

		local label2 = home:CreateLabel("Label text2")

		home:CreateButton({
			Name = "Claim Rewards",
			Callback = function() end,
		})

		home:CreateButton({
			Name = "Change Label 2 name",
			Callback = function()
				label2:Set("new name")
			end,
		})

		return window.node
	end)
end
