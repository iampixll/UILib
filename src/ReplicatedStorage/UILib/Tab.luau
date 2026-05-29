local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)
local Button = require(ReplicatedStorage.UILib.Button)

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

	return tab
end

return Tab
