local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.PixlLib.Button)
local Divider = require(ReplicatedStorage.PixlLib.Divider)
local Dropdown = require(ReplicatedStorage.PixlLib.Dropdown)
local InputBox = require(ReplicatedStorage.PixlLib.InputBox)
local Label = require(ReplicatedStorage.PixlLib.Label)
local Paragraph = require(ReplicatedStorage.PixlLib.Paragraph)
local Slider = require(ReplicatedStorage.PixlLib.Slider)
local Toggle = require(ReplicatedStorage.PixlLib.Toggle)

local source = vide.source

local Tab = {}

local function addChild(self, handle)
	local new = table.clone(self.children())
	table.insert(new, handle)
	self.children(new)

	if handle.flag then
		self.flags[handle.flag] = handle
	end

	return handle
end

function Tab.new(name, image, flags, onChanged)
	local tab = {
		name = name,
		image = image,
		flags = flags,
		onChanged = onChanged,
		children = source({}),
	}

	function tab:CreateButton(config)
		return addChild(self, Button.new(config.Name, config.Callback))
	end

	function tab:CreateLabel(name)
		return addChild(self, Label.new(name))
	end

	function tab:CreateDivider()
		return addChild(self, Divider.new())
	end

	function tab:CreateParagraph(config)
		return addChild(self, Paragraph.new(config.Title, config.Content))
	end

	function tab:CreateToggle(config)
		return addChild(self, Toggle.new(config.Name, config.CurrentValue, config.Flag, config.Callback, self.onChanged))
	end

	function tab:CreateSlider(config)
		return addChild(self, Slider.new(config.Name, config.Suffix, config.Range, config.Increment, config.CurrentValue, config.Flag, config.Callback, self.onChanged))
	end

	function tab:CreateInput(config)
		return addChild(self, InputBox.new(config.Name, config.IsNumber, config.CurrentValue, config.Placeholder, config.Flag, config.Callback, self.onChanged))
	end

	function tab:CreateDropdown(config)
		return addChild(self, Dropdown.new(config.Name, config.Options, config.MultipleOptions, config.Flag, config.Callback, self.onChanged))
	end

	return tab
end

return Tab
