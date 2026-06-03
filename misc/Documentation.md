# PixlLib
A Rayfield-style UI library built with Vide

## Booting the Library
```luau
local PixlLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampixll/PixlLib/refs/heads/main/source.luau"))()
```

## Creating a Window
```luau
local Window = PixlLib:CreateWindow({
	Title = "PixlLib",
	ToggleKey = "K", -- Enum.KeyCode name to minimize/restore, defaults to "K"

	Configuration = { -- optional; omit to disable saving/loading
		Saving = true, -- writes element values to file (needs executor writefile)
		Loading = true, -- reads them back on launch (skipped in Studio)
		FolderName = "PixlLib",
		FileName = "MyConfig", -- values are keyed by each element's Flag
	},
})
```

## Creating a Tab
```luau
local Tab = Window:CreateTab("Main", 15637376279) -- Name, icon asset id (positional, optional)
```

## Creating a Button
```luau
local Button = Tab:CreateButton({
	Name = "Button Example",
	Callback = function()
		-- runs when the button is clicked
	end,
})

Button:Set("New Label") -- updates the button text
```

## Creating a Toggle
```luau
local Toggle = Tab:CreateToggle({
	Name = "Toggle Example",
	CurrentValue = false,
	Flag = "Toggle1", -- identifier for config saving; keep every Flag unique
	Callback = function(value)
		-- value is a boolean
	end,
})
```

## Creating a Slider
```luau
local Slider = Tab:CreateSlider({
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
```

## Creating an Input
```luau
local Input = Tab:CreateInput({
	Name = "Input Example",
	IsNumber = false, -- true rejects non-numbers and snaps back to the last valid value
	CurrentValue = "",
	Placeholder = "Enter text",
	Flag = "Input1",
	Callback = function(value)
		-- value is a string, or a number when IsNumber is true
	end,
})
```

## Creating a Dropdown
```luau
local Dropdown = Tab:CreateDropdown({
	Name = "Dropdown Example",
	Options = { "Option1", "Option2", "Option3" },
	MultipleOptions = true, -- defaults to true; false for single-select. Multi-select shows an "All" toggle
	Flag = "Dropdown1",
	Callback = function(options)
		-- options is an array of the currently selected option names
	end,
})

Dropdown:Set({ "Option1", "Option2" }) -- :Set takes an array, :Get returns one
```

## Creating a Label
```luau
local Label = Tab:CreateLabel("Label Example") -- text is positional

Label:Set("New text") -- updates the text
```

## Creating a Paragraph
```luau
local Paragraph = Tab:CreateParagraph({
	Title = "Paragraph Title",
	Content = "Longer body text that wraps and grows in height automatically.",
})
```

## Creating a Divider
```luau
local Divider = Tab:CreateDivider() -- blank spacer between elements
```

## Element Interface
```luau
-- Toggle, Slider, Input and Dropdown share this interface:
Toggle:Set(true) -- updates state SILENTLY: the Callback does NOT fire (only real user input fires it)
local value = Toggle:Get() -- reads the current value (bool / number / string / array of strings)
print(Toggle.flag) -- the Flag string, used as the config save key
-- Button, Label, Paragraph and Divider have no value, no Flag and no :Get(); Button/Label keep :Set() for their text
```

## Notifying the User
```luau
PixlLib:Notify({
	Title = "Saved",
	Content = "Your configuration was saved successfully.",
	Duration = 5, -- optional, seconds; defaults to 6
}) -- toasts stack bottom-right and need a window to be visible first
```