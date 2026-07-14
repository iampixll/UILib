local vide = require("./Packages/vide")

local Button = require("./Button")
local Divider = require("./Divider")
local Dropdown = require("./Dropdown")
local InputBox = require("./InputBox")
local Keybind = require("./Keybind")
local Label = require("./Label")
local Paragraph = require("./Paragraph")
local Section = require("./Section")
local Slider = require("./Slider")
local Toggle = require("./Toggle")

local source = vide.source

local Tab = {}

function Tab.new(name, icon, flags, onChanged)
	local tab = {
		name = name,
		icon = icon,
		flags = flags,
		onChanged = onChanged,
		children = source({}),
	}

	-- Every Create* funnels through here: the element goes into the tab's child list (which
	-- vide renders), into the flag registry if it carries a Flag, and gets handed the way
	-- back out again so :Destroy() can remove it.
	local function addChild(handle)
		local new = table.clone(tab.children())
		table.insert(new, handle)
		tab.children(new)

		if handle.flag then
			if flags[handle.flag] then
				warn(`[PixlLib] duplicate Flag "{handle.flag}" - the config will only keep one of them`)
			end
			flags[handle.flag] = handle
		end

		handle._remove = function()
			local remaining = {}
			for _, child in tab.children() do
				if child ~= handle then
					table.insert(remaining, child)
				end
			end
			tab.children(remaining)

			if handle.flag and flags[handle.flag] == handle then
				flags[handle.flag] = nil
			end
		end

		return handle
	end

	function tab:CreateButton(config)
		return addChild(Button.new(config))
	end

	function tab:CreateLabel(config)
		-- Historically the text was positional: CreateLabel("Text")
		if type(config) == "string" then
			config = { Name = config }
		end
		return addChild(Label.new(config))
	end

	function tab:CreateSection(config)
		if type(config) == "string" then
			config = { Name = config }
		end
		return addChild(Section.new(config))
	end

	function tab:CreateDivider()
		return addChild(Divider.new({}))
	end

	function tab:CreateParagraph(config)
		return addChild(Paragraph.new(config))
	end

	function tab:CreateToggle(config)
		return addChild(Toggle.new(config, onChanged))
	end

	function tab:CreateSlider(config)
		return addChild(Slider.new(config, onChanged))
	end

	function tab:CreateInput(config)
		return addChild(InputBox.new(config, onChanged))
	end

	function tab:CreateDropdown(config)
		return addChild(Dropdown.new(config, onChanged))
	end

	function tab:CreateKeybind(config)
		return addChild(Keybind.new(config, onChanged))
	end

	return tab
end

return Tab
