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

		-- Restoring a saved toggle also runs its callback, so the feature behind it comes
		-- back on. Set to false if a restored config must not act on its own at launch.
		FireCallbacksOnLoad = true,
	},
})

local mainTab = window:CreateTab("Main", "house") -- icon: name, asset id, or rbxassetid://

mainTab:CreateSection("Elements")

mainTab:CreateButton({
	Name = "Button Example",
	Icon = "bell", -- optional
	Callback = function()
		PixlLib:Notify({
			Title = "Saved",
			Content = "Your configuration was saved successfully.",
			Icon = "settings", -- optional
			Duration = 10, -- optional, seconds; defaults to 6
		})
	end,
})

mainTab:CreateLabel("Label Example")

local toggle = mainTab:CreateToggle({
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

mainTab:CreateKeybind({
	Name = "Keybind Example",
	CurrentKeybind = "F",
	HoldToInteract = false, -- true: fires with true on press and false on release
	Flag = "Keybind1",
	Callback = function()
		-- click the element, then press a key, to rebind it
		PixlLib:Notify({ Title = "Keybind", Content = "The keybind fired." })
	end,
})

mainTab:CreateParagraph({
	Title = "Paragraph Title",
	Content = "Longer body text that wraps and grows in height automatically.",
})

local dropdown = mainTab:CreateDropdown({
	Name = "Dropdown",
	Options = { "Option1", "Option2", "Option3", "Option4" },
	CurrentOption = { "Option1" },
	MultipleOptions = true,
	Flag = "Dropdown1",
	Callback = function(options)
		-- options is an array of the selected names
	end,
})

mainTab:CreateSection("Handles")

mainTab:CreateButton({
	Name = "Flip the toggle from code",
	Callback = function()
		toggle:Set(not toggle:Get()) -- :Set fires the callback, exactly like a click
	end,
})

mainTab:CreateButton({
	Name = "Refresh the dropdown's options",
	Callback = function()
		-- for options that only exist once something has loaded
		dropdown:Refresh({ "Fresh1", "Fresh2", "Option1" })
	end,
})
