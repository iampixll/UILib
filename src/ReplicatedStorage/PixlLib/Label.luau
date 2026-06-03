local vide = require("./Packages/vide")
local Colors = require("./Colors")

local create = vide.create
local source = vide.source

local Label = {}

function Label.new(name)
	local label = {}

	name = source(name)

	function label:render()
		return create("TextLabel")({
			Size = UDim2.new(0.98, 0, 0, 28),
			BackgroundTransparency = 1,

			Text = name,
			TextColor3 = Colors.textPrimary,
			TextSize = 24,
			TextXAlignment = "Left",
			TextYAlignment = "Bottom",

			FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),
		})
	end

	function label:Set(newName)
		name(newName)
	end

	return label
end

return Label
