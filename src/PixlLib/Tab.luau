local vide = require("@vide")

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

		-- Reads the child list, so it re-evaluates on its own when elements come and go.
		-- A Section uses it to drop the gap it would otherwise put above itself: that gap
		-- exists to separate it from the group before it, and at the top of a tab there is
		-- no group before it.
		handle.isFirst = function()
			return tab.children()[1] == handle
		end

		local function register(element)
			if not (element and element.flag) then
				return
			end

			if flags[element.flag] then
				warn(`[PixlLib] duplicate Flag "{element.flag}" - the config will only keep one of them`)
			end
			flags[element.flag] = element
		end

		register(handle)

		-- An element may carry an inline keybind (a Toggle with Keybind = {...}). It is a
		-- value in its own right, so it gets its own flag entry and is saved and reachable
		-- like any other: PixlLib.Flags.AutoFarmKey:Get()
		register(handle.keybind)

		handle._remove = function()
			local remaining = {}
			for _, child in tab.children() do
				if child ~= handle then
					table.insert(remaining, child)
				end
			end
			tab.children(remaining)

			for _, element in { handle, handle.keybind } do
				if element.flag and flags[element.flag] == element then
					flags[element.flag] = nil
				end
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
