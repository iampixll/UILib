local vide = require("@vide")
local Colors = require("./Colors")
local Element = require("./Element")

local create = vide.create

local Label = {}

function Label.new(config)
	local label = Element.new("Label", config)

	local name = label.name
	local color = config.Color or Colors.textPrimary

	function label:render()
		return create("TextLabel")({
			Size = UDim2.new(0.98, 0, 0, 28),
			BackgroundTransparency = 1,
			Visible = label.visible,

			Text = name,
			TextColor3 = color,
			TextSize = 32,
			TextXAlignment = "Left",
			TextYAlignment = "Bottom",

			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		})
	end

	return label
end

return Label
