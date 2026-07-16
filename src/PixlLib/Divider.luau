local vide = require("@vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create

local Divider = {}

-- A drawn line, not just empty space: it is the thing you reach for to say "the group above
-- ended here". Blank spacers cannot do that, they just look like a layout accident.
function Divider.new(config)
	local divider = Element.new("Divider", config or {})

	function divider:render()
		return create("Frame")({
			Size = UDim2.new(0.98, 0, 0, 9), -- the line plus breathing room above and below
			BackgroundTransparency = 1,
			Visible = divider.visible,

			create("Frame")({
				Size = UDim2.new(1, 0, 0, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Colors.stroke,
				BorderSizePixel = 0,
			}),
		})
	end

	return divider
end

return Divider
