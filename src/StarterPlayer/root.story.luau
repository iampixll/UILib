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
			Name = "Dropdown",
			Options = { "Option1", "Option2", "Option3", "Option4" },
			MultipleOptions = true,
			Flag = "Dropdown1",
			Callback = function(option) end,
		})

		return window.node
	end)
end
