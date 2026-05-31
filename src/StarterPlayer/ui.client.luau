local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Window = require(ReplicatedStorage.UILib.Window)

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

vide.mount(function()
	local window = Window.new({ Title = "PixlLib" })

	local mainTab = window:CreateTab("Main", 15637376279)

	local dropdown = mainTab:CreateDropdown({
		Name = "Select Upgrades",
		Options = { "Option1", "Option2", "Option3", "Option4", "Option5", "Option6", "Option7", "Option8" },
	})

	local toggle = mainTab:CreateToggle({
		Name = "Toggle",
		CurrentValue = false,
		Flag = "Toggle1",
		Callback = function(value) end,
	})

	local input = mainTab:CreateInput({
		Name = "Input",
		InputType = "number",
		CurrentValue = 0,
		Placeholder = "Enter amount",
		Flag = "Input1",
		Callback = function(value) end,
	})

	return window.node
end, playerGui)
