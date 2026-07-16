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
	ToggleKey = "K", -- Enum.KeyCode name to minimize/restore, defaults to "K". Also
	-- rebindable at runtime in the settings view (see below); with Saving on, the new
	-- key is written to the config and survives a reload.

	Configuration = { -- optional; omit to disable saving/loading
		Saving = true, -- writes element values to file (needs executor writefile)
		Loading = true, -- reads them back on launch (skipped in Studio)
		FolderName = "PixlLib",
		FileName = "MyConfig", -- values are keyed by each element's Flag

		FireCallbacksOnLoad = true, -- default. A restored toggle also runs its Callback, so
		-- the feature behind it comes back on. Set to false when a restored config must not
		-- act on its own at launch.
	},
})
```

Saves are debounced (0.5s), so dragging a slider writes the file once, on release - not once
per step.

## Icons
Anywhere an icon is taken (tabs, buttons, notifications) you may pass:

```luau
"farming"                -- a name from Icons.Named (see PixlLib/Icons.luau)
15637359494              -- a raw asset id
"rbxassetid://15637359494" -- an explicit asset string (rbxthumb:// works too)
```

Unknown names warn and fall back, they never error.

## Creating a Tab
```luau
local Tab = Window:CreateTab("Main", "house") -- Name, icon (optional)
```

## Elements

### Button
```luau
local Button = Tab:CreateButton({
	Name = "Button Example",
	Icon = "bell", -- optional
	Callback = function() end,
})

Button:Set("New Label") -- relabels it
Button:SetIcon("settings")
```

### Toggle
```luau
local Toggle = Tab:CreateToggle({
	Name = "Toggle Example",
	CurrentValue = false,
	Flag = "Toggle1", -- identifier for config saving; keep every Flag unique
	Callback = function(value) end, -- value is a boolean
})
```

A toggle can carry its own keybind inline - a pill left of the switch that flips it. Give it a
`Keybind` table with the same shape as a standalone Keybind element:

```luau
local Toggle = Tab:CreateToggle({
	Name = "Auto collect orbs",
	Flag = "AutoCollectOrbs",
	Keybind = {
		CurrentKeybind = "L", -- KeyCode name; the pill shows it and rebinds on click
		HoldToInteract = false, -- true: on while held, off on release
		Flag = "AutoCollectOrbsKey", -- own Flag, so the chosen key is saved too
	},
	Callback = function(value) end,
})
```

### Slider
```luau
local Slider = Tab:CreateSlider({
	Name = "Slider Example",
	Range = { 0, 100 }, -- { min, max }
	Increment = 10,
	Suffix = "Bananas", -- optional, appended to the displayed value
	CurrentValue = 10,
	Flag = "Slider1",
	Callback = function(value) end, -- number, snapped to the increment
})

Slider:SetRange(0, 25) -- retarget it; the value is clamped into the new range
```

### Input
```luau
local Input = Tab:CreateInput({
	Name = "Input Example",
	IsNumber = false, -- true rejects non-numbers and snaps back to the last valid value
	CurrentValue = "",
	Placeholder = "Enter text",
	Flag = "Input1",
	Callback = function(value) end, -- string, or number when IsNumber is true
})
```

### Dropdown
```luau
local Dropdown = Tab:CreateDropdown({
	Name = "Dropdown Example",
	Options = { "Option1", "Option2", "Option3" },
	CurrentOption = { "Option1" }, -- optional; applied without firing the Callback
	MultipleOptions = true, -- defaults to true; false for single-select. Multi-select shows an "All" toggle
	Flag = "Dropdown1",
	Callback = function(options) end, -- array of the selected names
})

Dropdown:Refresh({ "New1", "New2" }) -- swap the options at runtime
Dropdown:GetOptions() -- the current option list
```

`:Refresh` is what you want when the options are not known while the UI is being built - a
game directory that is still loading, a list that depends on what the player owns. Selections
that still exist in the new list survive; the rest are dropped silently (the user did not
deselect them, the option went away).

### Keybind
```luau
local Keybind = Tab:CreateKeybind({
	Name = "Keybind Example",
	CurrentKeybind = "F", -- KeyCode *name*, not the enum: that is what survives the config file
	HoldToInteract = false, -- true: Callback(true) on press, Callback(false) on release
	Flag = "Keybind1",
	Callback = function() end,
})
```
Click the element, then press a key, to rebind it. Click again to cancel.

### Label, Section, Paragraph, Divider
```luau
local Label = Tab:CreateLabel("Label Example") -- body text
local Section = Tab:CreateSection("Group Heading") -- muted heading with a rule, groups what follows
local Divider = Tab:CreateDivider() -- a drawn line

local Paragraph = Tab:CreateParagraph({
	Title = "Paragraph Title",
	Content = "Longer body text that wraps and grows in height automatically.",
})

Paragraph:Set("New Title")
Paragraph:SetContent("New body text.")
```

## Element Interface
Every element - value or not - has the same handle:

```luau
Element:Get()               -- current value (bool / number / string / array of strings)
Element:Set(value)          -- applies it AND fires the Callback, exactly like a click would
Element:SetSilent(value)    -- applies it WITHOUT firing the Callback
Element:SetName("New name")
Element:SetVisible(false)   -- hide/show without destroying it
Element:IsVisible()
Element:Destroy()           -- removes it from the tab for good
Element.Type                -- "Toggle", "Slider", "Dropdown", ...
Element.Flag                -- the config key, if it has one
```

Elements without a value of their own (Button, Label, Section, Paragraph, Divider) treat their
text as the value, so `Button:Set("Go")` relabels it and `:Get()` returns the text.

## Reaching elements from anywhere
Every element with a Flag is in the registry:

```luau
PixlLib.Flags.Toggle1:Set(true) -- turns the feature on, callback and all
```

## Window
```luau
Window:CreateTab(name, icon)
Window:SelectTab(tab)
Window:GetTabs()

Window:SetVisibility(false) -- hides the whole interface, Open pill included
Window:IsVisible()

Window:Minimize()       -- flips it
Window:Minimize(true)   -- slides the window away, leaves the Open pill
Window:IsMinimized()
```

## Settings view
The gear button in the topbar (between the player display and the minimize button) swaps the
tab content for a built-in settings panel. There is no API to build - it is always there - and
it holds two controls:

- **Change UI keybind** - a rebind pill for the window's toggle key. Click it, press a new key
  (Escape cancels). The change is live, and with `Saving` on it is written to the config, so it
  survives a reload.
- **Unload UI** - tears the whole interface down, same as `PixlLib:Destroy()` (flushes a pending
  save, stops every active toggle, removes the GUI). It asks for a second click to confirm.

Picking a tab in the sidebar leaves the settings view again.

## Library
```luau
PixlLib:Notify({
	Title = "Saved",
	Content = "Your configuration was saved successfully.",
	Icon = "bell", -- optional
	Duration = 5, -- optional, seconds; defaults to 6
})
-- returns a function that dismisses the toast early

PixlLib:Save() -- force a write now
PixlLib:Load() -- re-apply the saved config
PixlLib:SetVisibility(false)
PixlLib:IsVisible()
PixlLib:Destroy() -- flushes a pending save, then tears everything down
```

Running the script a second time unmounts the previous interface automatically, so a stale
window can never be left behind listening to input.
