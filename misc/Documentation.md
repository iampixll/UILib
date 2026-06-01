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
| `ToggleKey` | string | Name of an `Enum.KeyCode` (e.g. `"K"`, `"RightControl"`). Pressing it toggles the window open/closed. Defaults to `"K"`. |

The window can also be opened/closed with the always-visible top button, dragged by its topbar or top button, and locked in place by right-clicking the top button.

## Creating a Tab

```luau
local Tab = Window:CreateTab("Tab Example", 15637376279) -- name, icon asset id
```

The icon argument is an asset id (number). If omitted, a default icon is used. The first tab created becomes the active tab automatically.

## Elements

All elements are created from a tab. Most return a handle exposing `:Get()`, `:Set()`, and a `flag` — see [Element Interface](#element-interface) below.

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
    Options = { "Option 1", "Option 2", "Option 3" },
    MultipleOptions = true, -- defaults to true; set false for single-select
    Flag = "Dropdown1",
    Callback = function(options)
        -- options is an array of the currently selected option names
    end,
})
```

The panel includes a search field to filter options. In multi-select mode an "All" button selects/clears every option at once. `:Get()` returns an array of selected names, and `:Set()` takes an array of names.

### Label

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
- **`element.flag`** — the identifier passed via `Flag`, used as the key under which the value will be stored by the configuration system.

```luau
Toggle:Set(true)        -- updates state, no callback
local on = Toggle:Get() -- reads current state

print(Toggle.flag)      -- "Toggle1"
```

## Planned

The following is on the roadmap and **not yet available**:

- **`PixlLib:Notify({ Title, Content, Image, Duration })`** — toast notifications stacking in the bottom-right corner.