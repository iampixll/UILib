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

		home:CreateLabel("Label text")

		home:CreateParagraph({
			Title = "yo gurt",
			Content = "gurt: yo",
		})

		home:CreateButton({
			Name = "Auto Farm",
			Callback = function()
				print("clicked")
			end,
		})

		home:CreateDivider("Divider")

		local label2 = home:CreateLabel("Label text2")

		home:CreateButton({
			Name = "Change Label 2 name",
			Callback = function()
				label2:Set("new name")
			end,
		})

		home:CreateDivider("Divider")

		local toggle = home:CreateToggle({
			Name = "Toggle",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(value) end,
		})

		home:CreateButton({
			Name = "turn toggle off",
			Callback = function()
				toggle:Set(false)
			end,
		})
		home:CreateButton({
			Name = "get toggle state",
			Callback = function()
				local state = toggle:Get()
				print(state)
			end,
		})

		return window.node
	end)
end
