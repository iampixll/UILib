local vide = require("../Packages/vide")

local create = vide.create

local Divider = {}

function Divider.new()
	local divider = {}

	function divider:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 5),
			BackgroundTransparency = 1,
		})
	end

	return divider
end

return Divider
