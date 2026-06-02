local ReplicatedStorage = game:GetService("ReplicatedStorage")

local uilabs = require(ReplicatedStorage.Packages.uilabs)
local vide = require(ReplicatedStorage.Packages.vide)
local PixlLib = require(ReplicatedStorage.PixlLib)

local toggle = true

if toggle then
	return uilabs.CreateVideStory({
		vide = vide,
		controls = {},
	}, function(props)
		local window = PixlLib:CreateWindow({
			Title = "PixlLib",
			ToggleKey = "RightControl",
		})

		local mainTab = window:CreateTab("Main", 15637376279)

		mainTab:CreateButton({
			Name = "Button Example",
			Callback = function()
				-- runs when the button is clicked
			end,
		})

		mainTab:CreateDropdown({
			Name = "Dropdown",
			Options = { "Option1", "Option2", "Option3", "Option4" },
			MultipleOptions = true,
			Flag = "Dropdown1",
			Callback = function(option) end,
		})

		mainTab:CreateToggle({
			Name = "Toggle Example",
			CurrentValue = false,
			Flag = "Toggle1",
			Callback = function(value)
				-- value is a boolean
			end,
		})

		mainTab:CreateLabel("Label Example")

		mainTab:CreateSlider({
			Name = "Slider Example",
			Range = { 0, 100 }, -- { min, max }
			Increment = 10,
			Suffix = "Bananas", -- optional, appended to the displayed value
			CurrentValue = 10,
			Flag = "Slider1",
			Callback = function(value)
				-- value is a number, snapped to the increment
			end,
		})

		mainTab:CreateDivider()

		mainTab:CreateInput({
			Name = "Input Example",
			IsNumber = false, -- true restricts input to valid numbers
			CurrentValue = "",
			Placeholder = "Enter text",
			Flag = "Input1",
			Callback = function(value)
				-- value is a string, or a number when IsNumber is true
			end,
		})

		mainTab:CreateParagraph({
			Title = "Paragraph Title",
			Content = "Longer body text that wraps and grows in height automatically.",
		})

		return window.node
	end)
end
