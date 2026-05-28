local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local source = vide.source

local Tab = {}

function Tab.new(name, image)
	local tab = {
		name = name,
		image = image,
		children = source({}),
	}

	function tab:createButton(config) end

	return tab
end

return Tab
