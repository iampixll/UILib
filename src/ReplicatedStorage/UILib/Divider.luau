local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vide = require(ReplicatedStorage.Packages.vide)

local create = vide.create

local Divider = {}

function Divider.new(name)
	local divider = {}

	divider.node = create("Frame")({
		Size = UDim2.new(0.98, 0, 0, 5),
		BackgroundTransparency = 1,
	})

	return divider
end

return Divider
