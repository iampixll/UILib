# PixlLib

A Rayfield-style UI library built with [Vide](https://github.com/centau/vide).

## Getting Started

PixlLib lives in `ReplicatedStorage.PixlLib`. Require the folder itself to get the entry module:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PixlLib = require(ReplicatedStorage.PixlLib)
```

## Creating a Window

`CreateWindow` builds the main interface and returns a window handle.

```luau
local Window = PixlLib:CreateWindow({
	Title = "PixlLib",
	ToggleKey = "K", -- key to open/close the window, defaults to "K"
})
```

| Field | Type | Description |
| --- | --- | --- |
| `Title` | string | Text shown in the topbar. |
| `ToggleKey` | string | Name of an `Enum.KeyCode` (e.g. `"K"`, `"RightControl"`). Pressing it minimizes/restores the window. Defaults to `"K"`. |
| `Configuration` | table? | Optional. Enables saving/loading of element values — see below. |

The window can also be minimized/restored with the always-visible top button, dragged by its topbar or top button, and locked in place by right-clicking the top button.

To persist element values, pass a `Configuration` table. Saving and loading only happen when this is present and the respective flags are set:

```luau
local Window = PixlLib:CreateWindow({
	Title = "PixlLib",
	ToggleKey = "RightControl",

	Configuration = {
		Saving = true,
		Loading = true,
		FolderName = "PixlLib",
		FileName = "MyConfig",
	},
})
```

Saving requires an executor with `writefile`/`readfile`; in Studio these are absent and loading is skipped gracefully. Values are keyed by each element's `Flag`.

## Creating a Tab

`CreateTab` takes the name and an optional icon asset id as **positional** arguments (not a config table):

```luau
local Tab = Window:CreateTab("Main", 15637376279) -- name, icon asset id
```

The icon argument is an asset id (number, or the numeric string works too). If omitted, a default icon is used. The first tab created becomes the active tab automatically.

## Elements

All elements are created from a tab. Stateful elements return a handle exposing `:Get()`, `:Set()`, and a `flag` — see [Element Interface](#element-interface).

### Button

```luau
local Button = Tab:CreateButton({
	Name = "Button Example",
	Callback = function()
		-- runs when the button is clicked
	end,
})
```

`Button:Set(name)` updates the button's label.

### Toggle

```luau
local Toggle = Tab:CreateToggle({
	Name = "Toggle Example",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(value)
		-- value is a boolean
	end,
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
	Callback = function(value)
		-- value is a number, snapped to the increment
	end,
})
```

### Input

```luau
local Input = Tab:CreateInput({
	Name = "Input Example",
	IsNumber = false, -- true restricts input to valid numbers
	CurrentValue = "",
	Placeholder = "Enter text",
	Flag = "Input1",
	Callback = function(value)
		-- value is a string, or a number when IsNumber is true
	end,
})
```

When `IsNumber` is `true`, invalid entries are rejected and the field snaps back to the last valid value.

### Dropdown

```luau
local Dropdown = Tab:CreateDropdown({
	Name = "Dropdown Example",
	Options = { "Option1", "Option2", "Option3" },
	MultipleOptions = true, -- defaults to true; set false for single-select
	Flag = "Dropdown1",
	Callback = function(options)
		-- options is an array of the currently selected option names
	end,
})
```

The panel includes a search field to filter options. In multi-select mode an "All" button selects/clears every option at once. `:Get()` returns an array of selected names, and `:Set()` takes an array of names.

### Label

`CreateLabel` takes the text as a **positional** string argument:

```luau
local Label = Tab:CreateLabel("Label Example")
```

`Label:Set(text)` updates the text.

### Paragraph

```luau
local Paragraph = Tab:CreateParagraph({
	Title = "Paragraph Title",
	Content = "Longer body text that wraps and grows in height automatically.",
})
```

### Divider

```luau
local Divider = Tab:CreateDivider()
```

A blank spacer used to separate elements.

## Element Interface

Stateful elements (Toggle, Slider, Input, Dropdown) share a common interface:

- **`element:Get()`** — returns the current value (boolean, number, string, or array of strings depending on the element).
- **`element:Set(value)`** — sets the value **silently**: the state updates but the `Callback` does **not** fire. The callback only runs on real user interaction. This keeps loading saved configurations from re-triggering side effects.
- **`element.flag`** — the identifier passed via `Flag`, used as the key under which the value is stored by the configuration system.

```luau
Toggle:Set(true)        -- updates state, no callback
local on = Toggle:Get() -- reads current state

print(Toggle.flag)      -- "Toggle1"
```

Button, Label, Paragraph and Divider have no stored value, so they have no `Flag` and no `:Get()`. Button and Label still expose `:Set()` to update their displayed text.

## Notifications

`PixlLib:Notify` shows a toast in the bottom-right corner. Toasts stack upward and remove themselves automatically after their duration.

```luau
PixlLib:Notify({
	Title = "Saved",
	Content = "Your configuration was saved successfully.",
	Duration = 5, -- optional, seconds; defaults to 6
})
```

| Field | Type | Description |
| --- | --- | --- |
| `Title` | string | Bold heading shown at the top of the toast. |
| `Content` | string | Body text; wraps and grows the toast height automatically. |
| `Duration` | number? | Optional seconds before the toast disappears. Defaults to `6`. |

Notifications require a window to be visible: `Notify` always records the toast, but it is only rendered once `CreateWindow` has been called (the window hosts the stack container).