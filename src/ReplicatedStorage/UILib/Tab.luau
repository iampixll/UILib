local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.UILib.Button)
local Divider = require(ReplicatedStorage.UILib.Divider)
local Dropdown = require(ReplicatedStorage.UILib.Dropdown)
local InputBox = require(ReplicatedStorage.UILib.InputBox)
local Label = require(ReplicatedStorage.UILib.Label)
local Paragraph = require(ReplicatedStorage.UILib.Paragraph)
local Slider = require(ReplicatedStorage.UILib.Slider)
local Toggle = require(ReplicatedStorage.UILib.Toggle)

local source = vide.source

local Tab = {}

local function addChild(self, handle)
	local new = table.clone(self.children())
	table.insert(new, handle)
	self.children(new)

	return handle
end

function Tab.new(name, image)
	local tab = {
		name = name,
		image = image,
		children = source({}),
	}

	function tab:CreateButton(config)
		return addChild(self, Button.new(config.Name, config.Callback))
	end

	function tab:CreateLabel(name)
		return addChild(self, Label.new(name))
	end

	function tab:CreateDivider(name)
		return addChild(self, Divider.new(name))
	end

	function tab:CreateParagraph(config)
		return addChild(self, Paragraph.new(config.Title, config.Content))
	end

	function tab:CreateToggle(config)
		return addChild(self, Toggle.new(config.Name, config.CurrentValue, config.Flag, config.Callback))
	end

	function tab:CreateSlider(config)
		return addChild(self, Slider.new(config.Name, config.Suffix, config.Range, config.Increment, config.CurrentValue, config.Flag, config.Callback))
	end

	function tab:CreateInput(config)
		return addChild(self, InputBox.new(config.Name, config.InputType, config.CurrentValue, config.Placeholder, config.Flag, config.Callback))
	end

	function tab:CreateDropdown(config)
		return addChild(self, Dropdown.new(config.Name, config.MultipleOptions, config.Options))
	end

	return tab
end

return Tab
