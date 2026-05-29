local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.UILib.Button)
local Divider = require(ReplicatedStorage.UILib.Divider)
local Label = require(ReplicatedStorage.UILib.Label)
local Paragraph = require(ReplicatedStorage.UILib.Paragraph)
local Slider = require(ReplicatedStorage.UILib.Slider)
local Toggle = require(ReplicatedStorage.UILib.Toggle)

local source = vide.source

local Tab = {}

function Tab.new(name, image)
	local tab = {
		name = name,
		image = image,
		children = source({}),
	}

	function tab:CreateButton(config)
		local button = Button.new(config.Name, config.Callback)

		local new = table.clone(self.children())
		table.insert(new, button)
		self.children(new)

		return button
	end

	function tab:CreateLabel(name)
		local label = Label.new(name)

		local new = table.clone(self.children())
		table.insert(new, label)
		self.children(new)

		return label
	end

	function tab:CreateDivider(name)
		local divider = Divider.new(name)

		local new = table.clone(self.children())
		table.insert(new, divider)
		self.children(new)

		return divider
	end

	function tab:CreateParagraph(config)
		local paragraph = Paragraph.new(config.Title, config.Content)

		local new = table.clone(self.children())
		table.insert(new, paragraph)
		self.children(new)

		return paragraph
	end

	function tab:CreateToggle(config)
		local toggle = Toggle.new(config.Name, config.CurrentValue, config.Flag, config.Callback)

		local new = table.clone(self.children())
		table.insert(new, toggle)
		self.children(new)

		return toggle
	end

	function tab:CreateSlider(config)
		local slider = Slider.new(config.Name, config.Suffix, config.Range, config.Increment, config.CurrentValue, config.Flag, config.Callback)

		local new = table.clone(self.children())
		table.insert(new, slider)
		self.children(new)

		return slider
	end

	return tab
end

return Tab
