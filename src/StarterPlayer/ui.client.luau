local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PixlLib = require(ReplicatedStorage.PixlLib)

local window = PixlLib:CreateWindow({
	Title = "PixlLib",
	ToggleKey = "RightControl",

	Configuration = {
		Saving = true,
		Loading = true,
		FolderName = "PixlLib",
		FileName = "PixlHub",
	},
})

local mainTab = window:CreateTab("Main", 15637376279)

mainTab:CreateButton({
	Name = "Button Example",
	Callback = function()
		PixlLib:Notify({
			Title = "Saved",
			Content = "Your configuration was saved successfully.",
			Duration = 10, -- optional, seconds; defaults to 6
		})
	end,
})

mainTab:CreateLabel("Label Example")

mainTab:CreateToggle({
	Name = "Toggle Example",
	CurrentValue = false,
	Flag = "SuperMegaToggle",
	Callback = function(value)
		-- value is a boolean
	end,
})

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
mainTab:CreateDivider()

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

mainTab:CreateParagraph({
	Title = "Paragraph Title",
	Content = "Longer body text that wraps and grows in height automatically.",
})

mainTab:CreateDropdown({
	Name = "Dropdown",
	Options = { "Option1", "Option2", "Option3", "Option4" },
	MultipleOptions = true,
	Flag = "Dropdown1",
	Callback = function(option) end,
})
