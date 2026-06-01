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

		local mainTab = window:CreateTab("Main", 15637376279)

		mainTab:CreateDropdown({
			Name = "Select Upgrades",
			MultipleOptions = true,
			Options = { "Option1", "Option2", "Option3", "Option4", "Option5", "Option6", "Option7", "Option8" },
		})

		mainTab:CreateToggle({
			Name = "Toggle",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(value) end,
		})

		mainTab:CreateInput({
			Name = "Input",
			InputType = "a",
			CurrentValue = "",
			Placeholder = "Enter amount",
			Flag = "Input1",
			Callback = function(value) end,
		})

		mainTab:CreateDivider("Divider")

		mainTab:CreateDropdown({
			Name = "Select Upgrades 2",
			MultipleOptions = false,
			Options = { "Option1", "Option2", "Option3", "Option4", "Option5", "Option6", "Option7", "Option8" },
		})
		return window.node
	end)
end
